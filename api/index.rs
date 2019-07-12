use http::{self, Request, Response, StatusCode};
use reqwest::{header, Client};
use scraper::{Html, Selector};
use serde_derive::Serialize;
use serde_json;
use std::collections::HashMap;
use url::Url;

#[derive(Debug, Serialize)]
struct ElementResponse {
    innerHTML: String,
    innerText: Vec<String>,
}

#[derive(Debug, Serialize)]
struct ResponseBody {
    selector: String,
    elements: Vec<ElementResponse>,
}

fn extract_selector(html: &String, selector_str: &str) -> ResponseBody {
    let fragment = Html::parse_document(html);
    let selector = Selector::parse(selector_str).unwrap();

    let elements: Vec<_> = fragment
        .select(&selector)
        .map(|el| ElementResponse {
            innerHTML: el.inner_html(),
            innerText: el.text().map(|text| text.to_string()).collect(),
        })
        .collect();
    let res = ResponseBody {
        selector: selector_str.to_string(),
        elements,
    };
    res
}

fn handler(request: Request<()>) -> http::Result<Response<String>> {
    // TODO: handle `#id` selectors
    let uri_str = request.uri().to_string();
    let url = Url::parse(&uri_str).unwrap();
    let hash_query: HashMap<_, _> = url.query_pairs().to_owned().collect();

    match (hash_query.get("url"), hash_query.get("selector")) {
        (Some(ref url), Some(ref selector)) => {
            let url = format!("http://{}", url);
            let url = Url::parse(&url).expect("Failed to parse URL");
            let client = Client::new();
            let mut res = client
                .get(url)
                .header(header::ACCEPT, "text/html")
                .send()
                .expect("Failed to send HTTP request");

            assert_eq!(res.status(), StatusCode::OK);
            let page_html = res.text().expect("Failed to get response HTML");
            let content = extract_selector(&page_html, selector);
            let content_str =
                serde_json::to_string_pretty(&content).expect("Failed to serialize to JSON");
            let response = Response::builder()
                .status(StatusCode::OK)
                .header(header::CONTENT_TYPE, "application/json")
                .body(content_str)
                .expect("failed to render response");
            Ok(response)
        }

        _ => Response::builder()
            .status(StatusCode::BAD_REQUEST)
            .body("`selector` and `url` are required query params".to_string()),
    }
}

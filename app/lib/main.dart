import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: "I don't like trading"),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;

  void _incrementCounter() {
    setState(() {
      _counter++;
    });
  }

  void _decrementCounter() {
    setState(() {
      if (_counter > 0) {
        _counter--;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: ListView.builder(
        itemCount: _counter,
        itemBuilder: (BuildContext context, int index) {
          return ListTile(
            leading: Icon(Icons.new_releases),
            title: Text('new'),
            onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => SecondPage()),
                ),
          );
        },
      ),
      floatingActionButton: Column(
        verticalDirection: VerticalDirection.up,
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          FloatingActionButton(
            // heroTag: https://stackoverflow.com/questions/51125024/there-are-multiple-heroes-that-share-the-same-tag-within-a-subtree#answer-51359266
            heroTag: "incrementBtn",
            onPressed: _incrementCounter,
            tooltip: 'increment',
            child: Icon(Icons.add),
          ),
          Container(
            margin: EdgeInsets.only(bottom: 16.0),
            child: FloatingActionButton(
              heroTag: "decrementBtn",
              onPressed: _decrementCounter,
              tooltip: 'decrement',
              child: Icon(Icons.remove),
            ),
          ),
        ],
      ),
    );
  }
}

class SecondPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Second Screen'),
      ),
      body: Center(
        child: RaisedButton.icon(
            onPressed: () => Navigator.pop(context),
            label: Text('Go back'),
            icon: Icon(FontAwesomeIcons.stepBackward)),
      ),
    );
  }
}

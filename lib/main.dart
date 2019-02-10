import 'package:flutter/material.dart';
import 'package:english_words/english_words.dart';

void main() => runApp(MyApp3());

class MyApp extends StatelessWidget{
  @override
  Widget build(BuildContext context){
    return MaterialApp(
      title: 'Startup Name Generator',
      home: RandomWords(),
    );
  }
}

class MyApp2 extends StatelessWidget{
  @override
  Widget build(BuildContext context){
    return MaterialApp(
      title: 'POP',
      color: Colors.red[50],
      home: MainPage(),
    );
  }
}

class MyApp3 extends StatelessWidget{
  @override
  Widget build(BuildContext context){
    return MaterialApp(
      title:'App3',
      home: EntryPage(),
    );
  }
}

class RandomWordsState extends State<RandomWords>{
    final _suggestions = <WordPair>[];
    final _biggerFont = const TextStyle(fontSize: 100.0);

    Widget _buildSuggestions(){
      return ListView.builder(
        padding: const EdgeInsets.all(16.0),
        itemBuilder: (context, i){
      if (i.isOdd) return Divider();

      final index = i ~/ 2;
      if (index >= _suggestions.length){
      _suggestions.addAll(generateWordPairs().take(10));
      }
      return _buildRow(_suggestions[index]);
      });
    }

    Widget _buildRow(WordPair pair){
      return ListTile(
        title: Text(
          pair.asPascalCase,
          style: _biggerFont,
        ),
      );
    }
    @override
    Widget build(BuildContext context){
      return Scaffold(
        appBar: AppBar(
          title: Text('Oranges'),
        ),
        body: _buildSuggestions(),
      );
  }
}

class RandomWords extends StatefulWidget{
  @override
  RandomWordsState createState() => new RandomWordsState();
}

class MyBubble extends State<MainPage> {
  bool pressed = false;

  Widget bubble(String txt) {
    return new Stack(
      alignment: Alignment.center,
      children: <Widget>[
      Container(
      width: 200.0,
      height: 200.0,
      child: new RawMaterialButton(
        shape: new CircleBorder(),
        fillColor: pressed ? Colors.blue[100] : Colors.red[100],
//        fillColor: Colors.red[500],
        onPressed: () {
          setState(() {
            pressed = !pressed;
          });
        },
      ),

    ),
     Text(
       txt,
       style: TextStyle(
         fontSize: 20.0,
         color: Colors.blue[700],
       ),
     ),]
     );
  }


  Widget build(BuildContext context){
    return new Center(
      child: Container(
        alignment: Alignment.center,
        child: bubble('Boop'),
      )
    );
  }
}


class MainPage extends StatefulWidget{
  MyBubble createState() => MyBubble();
}

class Bubble{
  String _entry;
  double _priority;

  Bubble(String _entry, double _priority){
    this._entry = _entry;
    this._priority = _priority;
  }

  String getEntry(){
    return this._entry;
  }

  double getPriority(){
    return this._priority;
  }
}

class TextEntryBubble extends State<EntryPage> {
  Bubble b1 = new Bubble('hello', 300);
  String t1 = 'BUBL';
  Widget makeBubble(Bubble bubble) {
    {
      bool pressed = false;
      return new Stack(
          alignment: Alignment.center,
          children: <Widget>[
            Container(
              width: bubble.getPriority(),
              height: bubble.getPriority(),
              child: new RawMaterialButton(
                shape: new CircleBorder(),
                fillColor: pressed ? Colors.blue[500] : Colors.red[100],
                //        fillColor: Colors.red[500],
                onPressed: () {
                  setState(() {
                    pressed = !pressed;
                  });
                },
              ),

            ),
            Text(
              bubble.getEntry(),
              style: TextStyle(
                fontSize: 20.0,
                color: Colors.blue[700],
              ),
            ),
          ]
      );
    }
  }

  Widget build(BuildContext context){
    return Scaffold(
      appBar: AppBar(
        title: Text(t1),
      ),
      body: makeBubble(new Bubble('Please work :) 1', 500)),
      backgroundColor: Colors.red[500],
    );
  }
}

class EntryPage extends StatefulWidget{
  TextEntryBubble createState() => TextEntryBubble();
}
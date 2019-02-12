import 'package:flutter/material.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget{
  @override
  Widget build(BuildContext context){
    return MaterialApp(
      title:'App3',
      home: EntryPage(),
    );
  }
}

class MyGrid extends State<EntryPage>{
  int _widthTiles;
  int _heightTiles;
  List<Widget> _myList;
  
  MyGrid(int _widthTiles, int _heightTiles){
    this._widthTiles = _widthTiles;
    this._heightTiles = _heightTiles;
    this._myList = new List(_widthTiles);
  }
  
  int getHeightTiles(){
    return this._heightTiles;
  }
  
  int getWidthTiles(){
    return this._widthTiles;
  }

  List<Widget> _generateList(BuildContext context){
    _myList[0] = new Bubble('Pop!', 200, true).build(context);
    return _myList;
  }

  Widget makeBubble(Bubble b){
    return new Opacity(opacity: b.getPressed() ? 1.0 : 0.0,
        child: FloatingActionButton(
          backgroundColor: Colors.blueAccent[300],
          child: Text(b.getEntry()),
          onPressed: ((){
            setState((){
//              print('' + b.getPressed().toString());
              b.changePressed();
//              print('' + b.getPressed().toString());
            });
          })
        )
    );
  }
  Bubble b1 = new Bubble('Pop!', 300, true);

  Widget build(BuildContext context){
    return Scaffold(
      appBar: AppBar(
        title: Text('BUBL'),
    ),
    body: makeBubble(b1),
    backgroundColor: Colors.amber[100],
    );
  }
}

class Bubble extends State<EntryPage>{
  String _entry;
  double _priority;
  bool _pressed;

  Bubble(String _entry, double _priority, bool _pressed){
    this._entry = _entry;
    this._priority = _priority;
    this._pressed = _pressed;
  }

  bool getPressed(){
    return this._pressed;
  }
  void changePressed(){
    _pressed = !_pressed;
  }

  String getEntry(){
    return this._entry;
  }

  double getPriority(){
    return this._priority;
  }
  @override
  Widget build(BuildContext context){
    return new Opacity(opacity: _pressed? 1.0 : 0.0,
       child: FloatingActionButton(
         backgroundColor: Colors.blueAccent[300],
         child: Text(_entry),
      )
    );
  }

  Widget getW(bool _pressed){
    return new Opacity(opacity: _pressed? 1.0 : 0.0,
        child: FloatingActionButton(
          backgroundColor: Colors.blueAccent[300],
          child: Text(_entry),
        )
    );
  }

}


class EntryPage extends StatefulWidget{
  MyGrid createState() => MyGrid(5, 5);
}
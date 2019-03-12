import 'package:flutter/material.dart';
import 'dart:math';
import 'bubbles.dart';

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
  int _maxWidthTiles; //Maximum number of tiles to be held on the screen across the width
  int _maxHeightTiles; //Maximum number of tiles to be held on the screen across the height
  BubblesList _bList; //List of bubbles
  double _tileWidth; //width of a given tile
  double _tileHeight; //height of a given tile
  List<Widget> _myList; //List of physical widgets
  Widget _grid;

  MyGrid(int _maxWidthTiles, int _maxHeightTiles){
    this._bList = populateBList(5); //TODO: Make this not for testing/prototype 1
    this._maxWidthTiles =_maxWidthTiles;
    this._maxHeightTiles =_maxHeightTiles;
    _tileWidth = 0.0; //Initialized to 0, will set in makeBubble
    _tileHeight = 0.0; //Initialized to 0, will set in makeBubble
    _myList = new List<Widget>();
    _grid = makeGrid();
  }

  //Widget creation instructions for a bubble widget based on Bubble b
  Widget makeBubble(Bubble b, BuildContext context){
    double _screenWidth = MediaQuery.of(context).size.width; //width of the screen
    double _screenHeight = MediaQuery.of(context).size.height; //height of the screen

    double _pW = _screenWidth / _maxWidthTiles; //PlaceHolder Width
    double _pH = _screenHeight / _maxHeightTiles; //PlaceHolder Height

    double _tileSize = min(_pW, _pH); //set the tile size to the smallest placeholder, will be used to form a square Container

    double _bubbleSize = b.getPriority() * _tileSize;

    // bool vis = b.getPressed();
    // print("Vis is set to " + vis.toString());
    return Container(
        width: _tileSize,
        height: _tileSize,
        child: Center(
          child: Opacity(
            opacity: b.getPressed() ? 1.0 : 0.0,
            child: Container(
              width: _bubbleSize,
              height:_bubbleSize,
                child:InkResponse(
                  onTap: (){
                    setState((){ //TODO: FIX THIS PLEASE SOMEONE
                      print(b.getPressed().toString());
                      b.changePressed();
                      print(b.getPressed().toString());
                    });
                  },
                  onLongPress: (){
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => BubbleDescription(presscount: b.getNumPressed(),)),
                    );
                  },
                  child: new Container(
                    width: _bubbleSize,
                    height:_bubbleSize,
                    decoration: new BoxDecoration(
                      color: Colors.blue,
                      border: new Border.all(color:Colors.white, width: _bubbleSize),
                      borderRadius: new BorderRadius.circular(_bubbleSize),
                    ),
                  ),
                ),
              ),
            ),
          )
    );
  }



  //FOR TESTING/PROTOTYPE 1 ONLY
  //Used to populate _bList
  BubblesList populateBList(int howMany){
    BubblesList nList = new BubblesList();
    for (int i = 0; i < howMany; i++){
      nList.addBubble(new Bubble(i.toString(), (i*10.0)/100.0, true, 0, i));
    }
    return nList;
  }

  //FOR TESTING/PROTOTYPE 1 ONLY
  //creates a list of widgets with bubbles
  void makeBubbles(BuildContext context){
    for (int i = 0; i < this._bList.getSize(); i++) {
      _myList.add(makeBubble(this._bList.getBubbleAt(i), context));
    }
  }

  //Specifies how to build grid
  //TODO: Remove magic numbers
  Widget makeGrid(){
    return new GridView.count(
      primary: false,
      padding: EdgeInsets.all(5.0),
      crossAxisSpacing: 5.0,
      crossAxisCount: 5,
      children: _myList,
    );
  }
  Widget build(BuildContext context) {
    makeBubbles(context);
    return Scaffold(
        appBar: AppBar(
          title: Text('BUBL'),
        ),
        body: makeGrid()
        );
  }
}

class EntryPage extends StatefulWidget{
  MyGrid createState() => MyGrid(5, 5);
}

//Page that displays information about the Bubble that was pressed
class BubbleDescription extends StatelessWidget{
  int presscount;

  BubbleDescription({Key, key, @required this.presscount}) : super(key : key);

  Widget build(BuildContext context){
    return Scaffold(
      appBar: AppBar(
        title: Text('Bubble Info'),
      ),
      body: Center(
          child: Text("Number of times button was pressed: " + presscount.toString())
      ),

      bottomNavigationBar:
      RaisedButton(
        onPressed: () {
          Navigator.pop(context);
        },
        child: Text('Back'),
      ),
    );
  }
}
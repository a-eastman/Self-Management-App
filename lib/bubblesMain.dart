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

  MyGrid(int _maxWidthTiles, int _maxHeightTiles){
    //Initialize everything
    this._bList = new BubblesList();
    this._maxWidthTiles =_maxWidthTiles;
    this._maxHeightTiles =_maxHeightTiles;
  }

  @override
  void initState(){
    this._bList = populateBList(3); //populate the bubblesList on start
  }

  //FOR TESTING/PROTOTYPE 1 ONLY
  //Used to populate _bList with Bubble objects
  BubblesList populateBList(int howMany){
    BubblesList nList = new BubblesList();
    for (int i = 0; i < howMany; i++){
      nList.addBubble(new Bubble(i.toString(), ((i+1)*33)/100.0, true, 0, i)); //100.0 is used to convert to percent
    }
    return nList;
  }

  //creates a grid of widgets given a list of Bubble objects
  Widget makeGrid(BubblesList bL, double padding, double spacing, int crossCount, BuildContext context){//BuildContext context){
    double _screenWidth = MediaQuery.of(context).size.width; //width of the screen
    double _screenHeight = MediaQuery.of(context).size.height; //height of the screen

    double _pW = _screenWidth / _maxWidthTiles; //PlaceHolder Width
    double _pH = _screenHeight / _maxHeightTiles; //PlaceHolder Height

    print("_pW = " + _pW.toString());
    print("_pH = " + _pH.toString());

    double _tileSize = min(_pW, _pH); //set the tile size to the smallest placeholder, will be used to form a square Container
    
    print("I chose: " + _tileSize.toString());

    List<Widget> _widgetList = []; //Used to read the bubbles into
    //goes through BubblesList param and creates a widget list based off of it
    for (int i = 0; i < bL.getSize(); i++) {
      double _currPrior = bL.getBubbleAt(i).getPriority();
      double _size = _currPrior * _tileSize; //sets the size that the widget will be based off of screen size
      _widgetList.add(new Container(
        width: _size,
        height: _size,
        child: Center(
          
            child: Container(
              
                width: _size,
                height: _size,
                child: Opacity(
                    opacity: _bList.getBubbleAt(i).getPressed() ? 1.0 : 0.0,
                    child: InkResponse(
                      
                      onTap: () {                         
                          setState(() {
                            print(_bList.getBubbleAt(i).getPressed().toString());
                            _bList.changeElementPressed(i);
                            print(_bList.getBubbleAt(i).getPressed().toString());
                            print(_bList.getBubbleAt(i).getNumPressed().toString());
                          });
                        },
                        onLongPress: (){
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => BubbleDescription(presscount:_bList.getBubbleAt(i).getNumPressed())),
                        );
                      },

                      child: Container(
                        width: _size,
                        height: _size,
                        decoration: new BoxDecoration(
                          color: Colors.blue,
                          border: new Border.all(color: Colors.white, width: _size),
                          borderRadius: new BorderRadius.circular(_size),
                        ),
                        child: Text(_bList.getBubbleAt(i).getEntry(), textAlign: TextAlign.center,)
                      ),
                    ),
                ),
            
            ),
        ),
      ));
    }
      //returns the gridview of the widget list
      return new GridView.count(
        primary: false,
        padding: EdgeInsets.all(padding),
        mainAxisSpacing: spacing,
        crossAxisSpacing: spacing,
        crossAxisCount: crossCount,
        children: _widgetList,
      );
  }    
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Bubble'),
        ),
        body: makeGrid(_bList, 0.5, 0.5, 3, context),
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
import 'package:flutter/material.dart';
import 'bubbles.dart';
import 'package:flutter/gestures.dart';

void main() => runApp(BubbleView());

class BubbleView extends StatelessWidget {
    @override
  Widget build(BuildContext context){
    return MaterialApp(
      title:'App3',
      home: BubblePage(),
    );
  }
}

class BubbleWidget extends State {
  // GestureTapCallback _onTap;
  // GestureLongPressCallback _onLongPress;
  Bubble _myBubble;
  // double _initTop;
  // double _initLeft;

  BubbleWidget(Bubble _myBubble){
    this._myBubble =_myBubble;
  }

  BubbleWidget.defaultBubbleWidget() {
    this._myBubble = new Bubble.defaultBubble();
  }
  // BubbleWidget ({Key key, this._myBubble, this._onLongPress, this._initTop, this._initLeft}) : super(key: key);
  
  @override
  Widget build(BuildContext context) {
    double screenHeight =MediaQuery.of(context).size.height;
    double screenWidth =MediaQuery.of(context).size.width;
    return new Positioned( 
      child:GestureDetector(
        onTap: () {
          // _myBubble.changePressed();
          // build(context);
        },
        onDoubleTap: (){
          print("Double tap");
        },
        onLongPress: () { Navigator.push(
                  context,
                  //Pass into Bubble Description Page ---> presscount, entry, description
                  MaterialPageRoute(builder: (context) => BubbleDescription(presscount: _myBubble.getNumPressed(), 
                                                                            entry: _myBubble.getEntry(), 
                                                                            description: _myBubble.getDescription(),
                                                          )
                  ),
                );
        },
        
            child: new Draggable(
              child: Container(
                color: Colors.transparent,
                width: _myBubble.getSize(),
                height: _myBubble.getSize(),
                child: new Opacity(
                  opacity: _myBubble.getPressed() ? 1.0 : 0.0,
                child:FloatingActionButton(
                  heroTag: null,
                  onPressed: (){
                    _myBubble.changePressed();
                    //_myBubble.changeOpacity(0.0);
                  },
                  backgroundColor: _myBubble.getColor(),
                  child: Container(
                    color: Colors.transparent,
                    child: Text(_myBubble.getEntry()),
                  )
                ), 
              ),
              ),

          feedback: new Material(
            child: Container(
              color: Colors.transparent,
                width: _myBubble.getSize(),
                height: _myBubble.getSize(),
                child:FloatingActionButton(
                  backgroundColor: _myBubble.getColor(),
                  child: Container(
                    color: Colors.transparent,
                    child: Text(_myBubble.getEntry()),
                  )
                ),
                  
                
              ),
            // color: Colors.white,
            // child: new InkResponse(
            //   radius: _myBubble.getSize(),
            //   child: new Container(
            //     width: _myBubble.getSize(),
            //     height: _myBubble.getSize(),
            //     decoration: new BoxDecoration(
            //       color: _myBubble.getColor(),
            //       //shape: BoxShape.circle,
            //       border: new Border.all(color: Colors.white, width: _myBubble.getSize()),
            //       borderRadius: new BorderRadius.circular(_myBubble.getSize()),
            //     ),
            //   ),
            // ),
          ),
          childWhenDragging: Container(),
        ),
      ),
    
    
    
    top: screenHeight * _myBubble.getYPercent(),
    left: screenWidth * _myBubble.getXPercent(),
    );
  }

  //TODO: Make method actually display description
  // void displayDescription(){
  //   print("displayDescription");
  // }
  // //This is just for testing
  // void doOnTap(){
  //   print("Tapped");
  // }
  // //Testing Purposes
  // void doOnLongHold(){
  //   print("HOLDDDDD ON");
  // }
}

class BubblePage extends StatefulWidget{
  EntryPage createState() => EntryPage();
}

class EntryPage extends State<BubblePage>{
  Bubble b1 = new Bubble.defaultBubble();
  Bubble b2 = new Bubble("DOUG DIMMADOME", 
                        "OWNER OF THE DIMSDALE DIMMADOME",
                        Colors.red,
                        200.0,
                        true,
                        0.2,
                        0.2,
                        1.0
  );
  @override
  Widget build(BuildContext context) {
    return new Container(
      color: Colors.white,
      child: new Center(
        child: new Stack(
          children: <Widget>[
            //new Draggable(
                new BubbleWidget (b1).build(context),
                new BubbleWidget (b2).build(context),
              //feedback: new Material(
                //color: Colors.white,
                //child: new CircleButton(size:150)
              //),
              //childWhenDragging: new Material(color: Colors.black),
            //),
          ],
        ),
      ),
    );
  }
}

//*OnLongHold:* Bubble Description Page
class BubbleDescription extends StatelessWidget{
  @override
  int presscount;
  String entry;
  String description;

  BubbleDescription({Key key, @required this.presscount, @required this.entry, @required this.description}) : super(key : key);

  Widget build(BuildContext context){
    return Scaffold(
    appBar: AppBar(
      title: Text('Bubble Info'),
    ),
    body: Center(
      child: Text("Number of times button was pressed: " + presscount.toString() + 
      "\nEntry: " + entry +
      "\nDescription: " + description,
      style: new TextStyle(
          fontSize: 18.0,
          fontFamily: 'Roboto',
          color: Colors.black
        )
      )
    ),

    bottomNavigationBar: 
      FloatingActionButton(
        onPressed: () {
          Navigator.pop(context);
        },
        child: Text('Back'),
      ),
    );
  }
}

class AllowMultipleGestureRecognizer extends TapGestureRecognizer {
  @override
  void rejectGesture(int pointer) {
    acceptGesture(pointer);
  }
}
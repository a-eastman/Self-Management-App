import 'package:flutter/material.dart';
import 'bubbles.dart';

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

class BubbleWidget extends StatelessWidget {
  // GestureTapCallback _onTap;
  // GestureLongPressCallback _onLongPress;
  Bubble _myBubble;
  // double _initTop;
  // double _initLeft;

  BubbleWidget(Bubble _myBubble){
    this._myBubble =_myBubble;
  }

  BubbleWidget.defaultBubbleWidget(){
    this._myBubble = new Bubble.defaultBubble();
  }
  // BubbleWidget ({Key key, this._myBubble, this._onLongPress, this._initTop, this._initLeft}) : super(key: key);
  
  @override
  Widget build(BuildContext context) {
    double screenHeight =MediaQuery.of(context).size.height;
    double screenWidth =MediaQuery.of(context).size.width;
    return new Positioned( 
    child: new Opacity(
      opacity: _myBubble.getOpacity(),
      child: new Draggable(
        child: new Material(
          child:InkResponse(
          onTap: (){
            doOnTap();
          },
          onLongPress: (){
            doOnLongHold();
          },
          child: new Container(
            width: _myBubble.getSize(),
            height: _myBubble.getSize(),
            decoration: new BoxDecoration(
              color: _myBubble.getColor(),
              border: new Border.all(color: Colors.white, width: _myBubble.getSize()),
              borderRadius: new BorderRadius.circular(_myBubble.getSize()),
            ),
          ),
        ),
        ),
      feedback: new Material(
        color: Colors.white,
        child: new InkResponse(
          radius: _myBubble.getSize(),
          child: new Container(
            width: _myBubble.getSize(),
            height: _myBubble.getSize(),
            decoration: new BoxDecoration(
              color: _myBubble.getColor(),
              //shape: BoxShape.circle,
              border: new Border.all(color: Colors.white, width: _myBubble.getSize()),
              borderRadius: new BorderRadius.circular(_myBubble.getSize()),
            ),
          ),
        ),
      ),
      childWhenDragging: Container(),
    ),
    ),
    top: screenHeight * _myBubble.getYPercent(),
    left: screenWidth * _myBubble.getXPercent(),
    );
  }

  //TODO: Make method actually display description
  void displayDescription(){
    print("displayDescription");
  }
  //This is just for testing
  void doOnTap(){
    print("Tapped");
  }
  //Testing Purposes
  void doOnLongHold(){
    print("HOLDDDDD ON");
  }
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
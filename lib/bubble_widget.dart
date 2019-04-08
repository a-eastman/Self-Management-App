import 'package:flutter/material.dart';
import 'bubbles.dart';

class BubbleWidget extends StatefulWidget{
  //final String entr;
  final Bubble bubble;
  const BubbleWidget({Key key, this.bubble}) : super(key : key);
  BubbleWidgetState createState() => BubbleWidgetState(this.bubble);
}

//Bubble class
class BubbleWidgetState extends State<BubbleWidget>{ 
  Bubble _bubble;
  BubbleWidgetState(Bubble _bubble){
    this._bubble = _bubble;
  }

  Widget build(BuildContext context) {
    double _screenHeight =MediaQuery.of(context).size.height;
    double _screenWidth =MediaQuery.of(context).size.width;
    print(_screenHeight.toString());
    print(_screenWidth.toString());
    return new Positioned(
      child: Container(
        width: _bubble.getSize(),
        height: _bubble.getSize(),
          child: new Opacity( 
            opacity: _bubble.getPressed() ? 1.0 : 0.0,
            child: new GestureDetector(
              onDoubleTap: () {
                setState((){
                  _bubble.changePressed();
                  _bubble.setPopState();
                });
              },
              onPanUpdate: (DragUpdateDetails details) {
                // print(details.focalPoint.distanceSquared);
                  setState((){
                    _bubble.changeXPos(details.globalPosition.dx, _screenWidth);
                    _bubble.changeYPos(details.globalPosition.dy, _screenHeight);
                  });
              },
              child: Container(
                decoration: new BoxDecoration(
                  color: _bubble.getColor(),
                  shape:BoxShape.circle,
                ),
                child: Center(
                  child:Text(_bubble.getEntry()),
                ),
              ), 
            ),
          ),
        ),
      top: _bubble.getYPos(),
      left: _bubble.getXPos(),
    );
  }  
}
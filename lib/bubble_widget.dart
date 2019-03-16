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

  void _pushDetail(){
    final TextStyle _biggerFont = const TextStyle(fontSize: 18.0);
    Navigator.of(context).push(
      new MaterialPageRoute<void>(
        builder: (BuildContext context){
          return new Scaffold(
            appBar: new AppBar(
              title: Text("Bubble: " + _bubble.getEntry()),
              actions: <Widget>[
                new IconButton(icon: const Icon(Icons.edit), onPressed: null),
              ],
            ),
            body: new Center(
              child: new Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text("Title: " + _bubble.getEntry(), style: _biggerFont),
                    Text("Description: " + _bubble.getDescription(), style:_biggerFont),
                    Text("Size: " + _bubble.getSize().toInt().toString(), style:_biggerFont),
                    Text("Completed: " + _bubble.getNumPressed().toString(), style:_biggerFont),
                  ]
              ),
            ),
          );
        },
      ),
    );
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
          opacity: _bubble.getPressed() ? _bubble.getOrgOpacity() : 0.0,
          child: new GestureDetector(
            onDoubleTap: () {
              setState((){
                _bubble.changePressed();
                _bubble.setPopState();
              });
            },
            onLongPress: (){
              _pushDetail();
            },
            onPanUpdate: (DragUpdateDetails details) {
              // print(details.focalPoint.distanceSquared);
              setState((){
                _bubble.changeXPos(details.globalPosition.dx);
                _bubble.changeYPos(details.globalPosition.dy);
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
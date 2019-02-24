import 'package:flutter/material.dart';

void main() {
  runApp(new MaterialApp(home: new ExampleWidget()));
}

class ExampleWidget extends StatelessWidget {
  //CircleButton c = new CircleButton(onTap: () => print("nice!"), size:150);
  @override
  Widget build(BuildContext context) {
    return new Material(
      color: Colors.white,
      child: new Center(
        child: new Stack(
          children: <Widget>[
            //new Draggable(
                new Bubble (size:150, visible: true, initTop: 10, initLeft: 10),
                new Bubble (size:150, visible: true, initTop: 500, initLeft:250),
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

class Bubble extends StatelessWidget {
  GestureTapCallback onTap;
  GestureLongPressCallback onLongPress;
  final Text text;
  final double size;
  bool visible;
  double initTop;
  double initLeft;

  Bubble ({Key key, this.onLongPress, this.text, this.size, this.visible, this.initTop, this.initLeft}) : super(key: key);
  
  @override
  Widget build(BuildContext context) {

    return new Positioned( 
    child: new Opacity(
      opacity: visible ? 1.0:0.0,
      child: new Draggable(
      child: new InkResponse(
        onTap: onTap,
        onLongPress: onLongPress,
        child: new Container(
          width: size,
          height: size,
          decoration: new BoxDecoration(
            color: Colors.blue,
            shape: BoxShape.circle,
          ),
        ),
      ),
      feedback: new Material(
        color: Colors.white,
        child: new InkWell(
          child: new Container(
            width: size,
            height: size,
            decoration: new BoxDecoration(
              color: Colors.blue,
              border: new Border.all(color: Colors.white, width: size),
              borderRadius: new BorderRadius.circular(size)
            ),
          ),
        ),
      ),
      childWhenDragging: Container(),
    ),
    ),
    top: initTop,
    left: initLeft,
    );
  }

  setVisible(){
    visible = !visible;
  }
}

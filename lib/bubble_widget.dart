import 'package:flutter/material.dart';
import 'bubbles.dart';
<<<<<<< HEAD
//import 'package:audioplayer/audioplayer.dart';
=======
import 'package:audioplayer/audioplayer.dart';
>>>>>>> 85eaf95df3ad23ae04a9302e3a0ca2d4badc787c

class BubbleWidget extends StatefulWidget{
  //final String entr;
  final Bubble bubble;
  const BubbleWidget({Key key, this.bubble}) : super(key : key);

  Bubble getBubble(){
    return bubble;
  }

  BubbleWidgetState createState() => BubbleWidgetState(this.bubble);
}

//Bubble class
class BubbleWidgetState extends State<BubbleWidget>{
  Bubble _bubble;
  static final TextStyle _bubbleFont = const TextStyle(fontWeight: FontWeight.bold,
<<<<<<< HEAD
      fontSize: 15.0,
      fontFamily: 'SoulMarker');
=======
                                                       fontSize: 15.0,
                                                       fontFamily: 'SoulMarker');
>>>>>>> 85eaf95df3ad23ae04a9302e3a0ca2d4badc787c
  // AudioPlayer ap = new AudioPlayer();
  BubbleWidgetState(Bubble _bubble){
    this._bubble = _bubble;
  }

  // void _pushDetail(BuildContext context,List<BubbleWidget> _list){
  //   final TextStyle _biggerFont = const TextStyle(fontSize: 18.0);
  //   Navigator.of(context).push(
  //     new MaterialPageRoute<void>(
  //       builder: (BuildContext context){
  //         return new Scaffold(
  //           appBar: new AppBar(
  //             title: Text("Bubble: " + _bubble.getEntry()),
  //             actions: <Widget>[
  //               new IconButton(icon: const Icon(Icons.edit), onPressed: null),
  //             ],
  //           ),
  //           body: new Center(
  //             child: new Column(
  //                 mainAxisAlignment: MainAxisAlignment.spaceEvenly,
  //                 crossAxisAlignment: CrossAxisAlignment.center,
  //                 children: [
  //                   fakeBubble(),
  //                   Text("Title: " + _bubble.getEntry(),
  //                     style: _biggerFont,
  //                     textAlign: TextAlign.center,
  //                     overflow: TextOverflow.ellipsis,),
  //                   Text("Description: " + _bubble.getDescription(),
  //                     style:_biggerFont,
  //                     textAlign: TextAlign.center,
  //                     overflow: TextOverflow.clip,),
  //                   Text("Size: " + _bubble.getSize().toInt().toString(),
  //                     style:_biggerFont,
  //                     textAlign: TextAlign.center,
  //                     overflow: TextOverflow.ellipsis,),
  //                   Text("Completed: " + _bubble.getNumPressed().toString(),
  //                     style:_biggerFont,
  //                     textAlign: TextAlign.center,
  //                     overflow: TextOverflow.ellipsis,),
  //                   RaisedButton(
  //                     color: Colors.red[100],
  //                     onPressed: (){
  //                       this._bubble.setToDelete();
  //                       Navigator.pop(context);
  //                     },
  //                     child: Text("DELETE"),
  //                   )
  //                 ]
  //             ),
  //           ),
  //         );
  //       },
  //     ),
  //   );
  // }

  Widget fakeBubble(){
    return new Container(
      width: _bubble.getSize(),
      height:_bubble.getSize(),
      child: new Container(
        decoration: new BoxDecoration(
          color: _bubble.getColor(),
          shape:BoxShape.circle,
        ),
        child: new Center(
          child: Text(_bubble.getEntry(), style:_bubbleFont),
        ),
      ),
    );
  }

  void _pushDetail(TextStyle _bubbleFont){
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
<<<<<<< HEAD
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    fakeBubble(),
                    Text("Title: " + _bubble.getEntry(),
                      style: _biggerFont,
                      textAlign: TextAlign.center,
                      overflow: TextOverflow.ellipsis,),
                    Text("Description: " + _bubble.getDescription(),
                      style:_biggerFont,
                      textAlign: TextAlign.center,
                      overflow: TextOverflow.clip,),
                    Text("Size: " + _bubble.getSize().toInt().toString(),
                      style:_biggerFont,
                      textAlign: TextAlign.center,
                      overflow: TextOverflow.ellipsis,),
                    Text("Completed: " + _bubble.getNumPressed().toString(),
                      style:_biggerFont,
                      textAlign: TextAlign.center,
                      overflow: TextOverflow.ellipsis,),
                    RaisedButton(
                      color: Colors.red[100],
                      onPressed: (){
                        _bubble.setToDelete();
                      },
                      child: Text("DELETE"),
                    )
                  ]
=======
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  fakeBubble(),
                  Text("Title: " + _bubble.getEntry(), 
                        style: _biggerFont,
                        textAlign: TextAlign.center,
                        overflow: TextOverflow.ellipsis,),
                  Text("Description: " + _bubble.getDescription(), 
                        style:_biggerFont,
                        textAlign: TextAlign.center,
                        overflow: TextOverflow.clip,),
                  Text("Size: " + _bubble.getSize().toInt().toString(), 
                        style:_biggerFont,
                        textAlign: TextAlign.center,
                        overflow: TextOverflow.ellipsis,),
                  Text("Completed: " + _bubble.getNumPressed().toString(), 
                        style:_biggerFont,
                        textAlign: TextAlign.center,
                        overflow: TextOverflow.ellipsis,),
                  RaisedButton(
                    color: Colors.red[100],
                    onPressed: (){
                      this._bubble.setToDelete();
                    },
                    child: Text("DELETE"),
                  )
                ]
>>>>>>> 85eaf95df3ad23ae04a9302e3a0ca2d4badc787c
              ),
            ),
          );
        },
      ),
    );
  }

  Widget fakeBubble(){
    return new Container(
      width: _bubble.getSize(),
      height:_bubble.getSize(),
      child: new Container(
        decoration: new BoxDecoration(
          color: _bubble.getColor(),
          shape:BoxShape.circle,
        ),
        child: new Center(
          child: Text(_bubble.getEntry(), style:_bubbleFont),
        ),
      ),
    );
  }

  Widget build(BuildContext context) {
    double _screenHeight =MediaQuery.of(context).size.height;
    double _screenWidth =MediaQuery.of(context).size.width;
    print(_screenHeight.toString());
    print(_screenWidth.toString());
    return new Positioned(
      width: _bubble.getSize(),
      height: _bubble.getSize(),
<<<<<<< HEAD
      child: new Opacity(
        opacity: _bubble.getPressed() ? _bubble.getOrgOpacity() : 0.0,
        child: new Draggable(
          onDraggableCanceled: (Velocity velocity, Offset offset){
            setState((){
              _bubble.changeXPos(offset.dx, _screenWidth);
              _bubble.changeYPos(offset.dy - _bubble.getSize()/2.0, _screenHeight);
            });
          },
          child: new InkResponse(
            highlightColor: _bubble.getColor(),
            child: new Container(
              height: _bubble.getSize(),
              width: _bubble.getSize(),
              decoration: new BoxDecoration(
                shape:BoxShape.circle,
                color:_bubble.getColor(),
              ),
              child: Center(
                child:Text(
                  _bubble.getEntry(),
                  style:_bubbleFont,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ),
            onTap: () {
              setState((){
                _bubble.nextSize();
              });
            },
            onDoubleTap: (){
              setState((){ //pop bubble
                _bubble.changePressed();
                _bubble.setPopState();
                // switch (_bubble.getSizeIndex()){
                //   case 0: {
                //     ap.play("Sounds/SmallPop.mp3");
                //   }
                //   break;
                //   case 1: {
                //     ap.play("Sounds/MedPop.mp3");
                //   }
                //   break;
                //   case 2: {
                //     ap.play("Sounds/LargePop.mp3");
                //   }
                //   break;
                //   case 3: {
                //     ap.play("Sounds/XLPop.mp3");
                //   }
                // }
              });
            },
            onLongPress: (){
              _pushDetail(_bubbleFont);
            },
          ),
          feedback: new Material(
            shape: CircleBorder(),
            child: new InkResponse(
=======
        child: new Opacity( 
          opacity: _bubble.getPressed() ? _bubble.getOrgOpacity() : 0.0,
          child: new Draggable(
            onDraggableCanceled: (Velocity velocity, Offset offset){
              setState((){
                _bubble.changeXPos(offset.dx, _screenWidth);
                _bubble.changeYPos(offset.dy - _bubble.getSize()/2.0, _screenHeight);
              });
            },
            child: new InkResponse(
              highlightColor: _bubble.getColor(),
>>>>>>> 85eaf95df3ad23ae04a9302e3a0ca2d4badc787c
              child: new Container(
                height: _bubble.getSize(),
                width: _bubble.getSize(),
                decoration: new BoxDecoration(
                  shape:BoxShape.circle,
                  color:_bubble.getColor(),
                ),
                child: Center(
                  child:Text(
                    _bubble.getEntry(),
<<<<<<< HEAD
                    style:_bubbleFont,
                    overflow: TextOverflow.ellipsis,
=======
                     style:_bubbleFont,
                     overflow: TextOverflow.ellipsis,
                  ),
                ), 
              ),
              onTap: () {
                setState((){
                _bubble.nextSize();
                });
              },
              onDoubleTap: (){
                setState((){ //pop bubble
                  _bubble.changePressed();
                  _bubble.setPopState();
                  // switch (_bubble.getSizeIndex()){
                  //   case 0: {
                  //     ap.play("Sounds/SmallPop.mp3");
                  //   }
                  //   break;
                  //   case 1: {
                  //     ap.play("Sounds/MedPop.mp3");
                  //   }
                  //   break;
                  //   case 2: {
                  //     ap.play("Sounds/LargePop.mp3");
                  //   }
                  //   break;
                  //   case 3: {
                  //     ap.play("Sounds/XLPop.mp3");
                  //   }
                  // }
                });
              },
              onLongPress: (){
                _pushDetail();
              },
            ),
            feedback: new Material(
              shape: CircleBorder(),
              child: new InkResponse(
                child: new Container(
                  height: _bubble.getSize(),
                  width: _bubble.getSize(),
                  decoration: new BoxDecoration(
                    shape:BoxShape.circle,
                    color:_bubble.getColor(),
                  ),
                  child: Center(
                    child:Text(
                    _bubble.getEntry(), 
                    style:_bubbleFont,
                    overflow: TextOverflow.ellipsis,
                    ),
>>>>>>> 85eaf95df3ad23ae04a9302e3a0ca2d4badc787c
                  ),
                ),
              ),
            ),
            childWhenDragging: Container(),
          ),
          childWhenDragging: Container(),
        ),
      ),
      top: _bubble.getYPos(),
      left: _bubble.getXPos(),
    );
<<<<<<< HEAD
  }
}
=======
  } 
}
>>>>>>> 85eaf95df3ad23ae04a9302e3a0ca2d4badc787c

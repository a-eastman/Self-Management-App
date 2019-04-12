import 'themeSelection.dart';
import 'package:flutter/material.dart';
// import 'themeSelection.dart';
import 'themes.dart';
import 'bubbles.dart';
import 'add_widget.dart';
import 'edit_widget.dart';
import 'detail_widget.dart';
import 'pop_particles.dart';
import 'dart:async';
//import 'package:audioplayer/audioplayer.dart';

// ignore: must_be_immutable
class BubbleWidget extends StatefulWidget{

  //final String entr;
  BubbleTheme _theme;
  BubblesList _bList;
  // const BubbleWidget({Key key, this.bubble}) : super(key : key);
  BubbleWidget(BubblesList _bList, BubbleTheme _theme){
    // this._bubble = _bubble;
    this._bList =_bList;
    this._theme = _theme;
  }

  // Bubble getBubble(){
  //   return _bubble;
  // }
  BubblesList getBList(){
    return _bList;
  }

  BubbleWidgetState createState() =>
      BubbleWidgetState(this._bList, this._theme);
}

//Bubble class
class BubbleWidgetState extends State<BubbleWidget>{
  BubblesList _bList;
  BubbleTheme _theme;
  List<PopParticles> _popParticlesList = [];
  // AudioPlayer ap = new AudioPlayer();
  BubbleWidgetState(BubblesList _bList, BubbleTheme _theme){
    // this._bubble = _bubble;
    this._bList = _bList;
    this._theme = _theme;
  }

  Widget makeBubble(Bubble _bubble, BuildContext context) {
    double _screenHeight =MediaQuery.of(context).size.height;
    double _screenWidth = MediaQuery.of(context).size.width;
    double _bSize = _screenHeight * _bubble.getSize();
    
    TextStyle _bubbleFont = TextStyle(
      fontWeight: FontWeight.bold,
      fontSize: .15 * _bSize,
      color: Colors.black,
      fontFamily: 'SoulMarker');

    // TODO style copy
    var strikeThroughFont =
    TextStyle(
      fontWeight: FontWeight.bold,
      fontSize: 15.0,
      fontFamily: 'SoulMarker',
      decoration: TextDecoration.lineThrough);
      
    print(_screenHeight.toString());

    return new AnimatedPositioned(
      curve:  ElasticOutCurve(.9) ,
      duration: Duration(milliseconds: _bubble.lastActionGrabbed() ? 0 : 250),
      width: _bSize,
      height: _bSize,
      top: _bubble.getYPos() - _bSize / 2.0,
      left: _bubble.getXPos() - _bSize / 2.0,
      child: Stack(children: <Widget>[
        Container(
          width: _bSize,
          height: _bSize,
          child:
            AnimatedOpacity(
              duration: Duration(milliseconds: _bubble.getDotAppear() ? 250 : 100),
              opacity: _bubble.getDotAppear() ? 0.3 : 0.0,
              child:
                Stack(
                  children: <Widget>[
                    Center(
                      child: Text(
                        _bubble.getEntry(),
                        style:strikeThroughFont,
                        overflow: TextOverflow.ellipsis,
                      ),
                    )
                    ,
                    Image.asset('images/bubble.png'),
                  ],
                )
            )
            ,),
        new AnimatedOpacity(
          duration: Duration(milliseconds: 100),
          opacity: _bubble.getPressed() ? _bubble.getOrgOpacity() * .8 : 0.0,
          child: new Draggable(
            onDraggableCanceled: (Velocity velocity, Offset offset){
              setState((){
                _bubble.changeXPos(offset.dx + _bSize / 2.0, _bSize, _screenWidth);
                _bubble.changeYPos(
                    offset.dy + _bSize / 2.0 - _bSize/2.0, _bSize, _screenHeight);
                _bubble.setLastActiongrabbed(true);
                
                setState((){
                  _bList.moveToFront(_bubble);
                });
              });
            },
            child: new InkResponse(
              highlightColor: _bubble.getColor(),
              child: new Container(
                //height: _bSize,
                //width: _bSize,
                decoration: new BoxDecoration(
                  shape:BoxShape.circle,
                  color:_bubble.getColor(),
                ),
                child: Center(
                  child: AnimatedDefaultTextStyle(
                    curve:  ElasticOutCurve(.9),
                    duration: Duration(milliseconds: _bubble.lastActionGrabbed() ? 0 : 250),
                    style: _bubbleFont,
                    child:Text(
                      _bubble.getEntry(),
                      softWrap: true,
                      overflow: TextOverflow.ellipsis,
                    )
                  ),
                ),
              ),
              onTap: () {
                setState((){
                  _bubble.setLastActiongrabbed(false);
                  _bubble.nextSize();
                  _bList.moveToFront(_bubble);
                });
              },
              onDoubleTap: (){
                setState((){ //pop bubble
                  _bubble.changePressed();
                  _bubble.setPopState();
                  if (!_bubble.getPressed())
                  {
                    _popParticlesList.add(PopParticles(_bubble, _screenWidth, _screenHeight));
                    Timer(Duration(milliseconds: 500), () {
                      setState(() {
                        if (!_bubble.getPressed())
                          _bubble.setDotAppear(true);
                      });
                    });
                  }
                  else
                    _bubble.setDotAppear(false);
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
                //_pushDetail(_bubble, _bubbleFont);
                Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) =>
                      DetailWidget(_bList, _theme, _bubble, _screenHeight, _screenWidth),
                ));
              },
            ),
            feedback: new Material(
              shape: CircleBorder(),
              child: new InkResponse(
                child: new Container(
                  height: _bSize,
                  width: _bSize,
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
              ),
            ),
            childWhenDragging: Container(),
          ),
        )
      ],)
      ,
    );
  }

  List<Widget> _makeWidList(BuildContext context){
    List<Widget> _widList = [];
    // _widList.clear();
    for (int i = 0; i < _bList.getSize(); i++){
      if (!_bList.getBubbleAt(i).getShouldDelete()){
        _widList.add(makeBubble(_bList.getBubbleAt(i), context));
      }
    }
    for (int i = 0; i < _popParticlesList.length; i++){
      {
        _widList.add(_popParticlesList[i]);
      }
    }
    return _widList;
  }

  Widget build(BuildContext context){
    //ThemeBloc themeBloc = new ThemeBloc();
    return Scaffold(
      appBar: AppBar(
        title: Text('BUBL'),
        actions: <Widget>[
          new IconButton(
            icon: Icon(Icons.brush),
            onPressed: (){
              Navigator.of(context).push(MaterialPageRoute(
                builder: (context) =>
                    ThemeSelectorPage(theme: _theme, bublist: _bList),
              ));
            },
          ),
          new IconButton(
            icon: Icon(Icons.add_circle_outline),
            onPressed: (){
              setState(() {
                Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) =>
                      AddWidget(this._bList, _theme),
                ));
              });
            },
          ),
        ],
      ),
      body: new Stack(
        children: _makeWidList(context),
      ),
    );
  }
}
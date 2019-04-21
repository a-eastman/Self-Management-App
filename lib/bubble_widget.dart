
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
import 'settingsScreen.dart';
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
    // Reset animation values
    for (int i = 0; i < _bList.getSize(); i++)
    {
      var _bubble = _bList.getBubbleAt(i);
      _bubble.setDotAppear(!_bubble.getPressed());
      _bubble.setLastActiongrabbed(false);
    }
    this._theme = _theme;
  }

  void cleanUpParticles()
  {
    for(int i = 0; i < _popParticlesList.length; i++)
    {
      if (_popParticlesList[i].expired())
      {
        _popParticlesList.removeAt(i);
        i--;
      }
    }
    print("POP LENGTH");
    print(_popParticlesList.length);
  }
  
  // Animation values for tweaking
  final double _bubbleOpacity = .8;                       // Opacity of bubble in bubble view
  final int _ghostAppearMS = 250;                         // How long it takes ghost bubble to fade in after delay
  final int _ghostDisappearMS = 100;                      // How long it takes ghost bubble to disappear when unpopped
  final int _ghostAppearDelayMS = 500;                    // How long a delay after popping before ghost bubble starts to fade in
  final int _normalAlphaMS = 100;                         // How long it takes for the bubble to fade in/out after popping/unpopping
  final double _ghostOpacity = .3;                        // Opacity of ghost bubble
  final Curve _sizeChangeCurve = ElasticOutCurve(.9);     // Curve of bubble resizing
  final int _sizeChangeMS = 250;                          // Duration of bubble resizing

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
      key: Key(_bubble.globalIndex().toString()),
      curve: _sizeChangeCurve,
      duration: Duration(milliseconds: _bubble.lastActionGrabbed() ? 0 : _sizeChangeMS),
      width: _bSize,
      height: _bSize,
      top: (_bubble.getYPos() * _screenHeight) - _bSize / 2.0,
      left: (_bubble.getXPos() * _screenWidth) - _bSize / 2.0,
        child: new Draggable(
          onDraggableCanceled: (Velocity velocity, Offset offset){
            setState((){
              _bubble.changeXPos(offset.dx, _bSize, _screenWidth);
              _bubble.changeYPos(offset.dy, _bSize, _screenHeight);
              _bubble.setLastActiongrabbed(true);
              
              setState((){
                _bList.moveToFront(_bubble);
              });
            });
          },
          child: new Stack(children: <Widget>[
            
            // Ghost bubble
            makeBubbleGraphic(_bubble, _bubbleFont, true),

            // Normal interactable bubble
            new InkResponse(
              highlightColor: _bubble.getPressed() ? _bubble.getColor() : Colors.white10,
              child: makeBubbleGraphic(_bubble, _bubbleFont, false),
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
                    cleanUpParticles();
                    Timer(Duration(milliseconds: _ghostAppearDelayMS), () {
                      setState(() {
                        if (!_bubble.getPressed())
                          _bubble.setDotAppear(true);
                      });
                    });
                  }
                  else
                    _bubble.setDotAppear(false);
                });
              },
              onLongPress: (){
                Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) =>
                      DetailWidget(_bList, _theme, _bubble, _screenHeight, _screenWidth),
                ));
              },
            ),
          ],),

          //Feedback dragging bubble
          feedback: new Material(
            shape: CircleBorder(),
            child: new InkResponse(
              child: Container(
                width: _bSize,
                height: _bSize,
                child: makeBubbleGraphic(_bubble, _bubbleFont, !_bubble.getPressed()),
              ),
            )
          ),
          childWhenDragging: Container(),
        ),
    );
  }

  // Must inherit: size from ancestor
  Widget makeBubbleGraphic(Bubble _bubble, TextStyle _bubbleFont, bool isGhost)
  {
    return new AnimatedOpacity(
      duration: isGhost
      ? Duration(milliseconds: _bubble.getDotAppear() ? _ghostAppearMS : _ghostDisappearMS)
      : Duration(milliseconds: _normalAlphaMS),
      opacity: isGhost
      ? _bubble.getDotAppear() ? _ghostOpacity : 0.0
      : _bubble.getPressed() ? _bubble.getOrgOpacity() * _bubbleOpacity : 0.0,
      child: AnimatedDefaultTextStyle(
        curve: _sizeChangeCurve,
        duration: Duration(milliseconds: _bubble.lastActionGrabbed() ? 0 : _sizeChangeMS),
        style: _bubbleFont,
        child: new Container(
          decoration: new BoxDecoration(
            shape: BoxShape.circle,
            color: isGhost ? Colors.transparent : _bubble.getColor(),
            image: isGhost
            ? new DecorationImage(
                image: new AssetImage('images/bubble.png'),
                fit: BoxFit.fill,
              )
            : null,
          ),
          child: Stack(children: <Widget>[
            //isGhost ? Image.asset('images/bubble.png') : null,
            Center(
              child: Text(
                _bubble.getEntry(),
                softWrap: true,
                overflow: TextOverflow.ellipsis,
                style: new TextStyle(decoration: isGhost ? TextDecoration.lineThrough : TextDecoration.none),
              ),
            ),
          ],),
        )
      )
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
        leading: new IconButton(
          icon: Icon(Icons.settings),
          onPressed: () {
            setState(() {
              Navigator.of(context).push(MaterialPageRoute(
                builder: (context) =>
                    SettingsScreen(this._bList, _theme),
              ));
            });
          },
        ),
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
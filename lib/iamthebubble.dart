import 'themeSelection.dart';
import 'package:flutter/material.dart';
// import 'themeSelection.dart';
import 'themes.dart';
import 'bubbles.dart';
import 'add_widget.dart';
import 'edit_widget.dart';
import 'detail_widget.dart';
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
  static final TextStyle _bubbleFont = const TextStyle(
      fontWeight: FontWeight.bold,
      fontSize: 15.0,
      fontFamily: 'SoulMarker');
  // AudioPlayer ap = new AudioPlayer();
  BubbleWidgetState(BubblesList _bList, BubbleTheme _theme){
    // this._bubble = _bubble;
    this._bList = _bList;
    this._theme = _theme;
  }

  Widget makeBubble(Bubble _bubble, BuildContext context) {
    double _screenHeight =MediaQuery.of(context).size.height;
    double _screenWidth =MediaQuery.of(context).size.width;
    print(_screenHeight.toString());
    print(_screenWidth.toString());
    return new Positioned(
      width: _bubble.getSize(),
      height: _bubble.getSize(),
      child: new Opacity(
        opacity: _bubble.getPressed() ? _bubble.getOrgOpacity() : 0.0,
        child: new Draggable(
          onDraggableCanceled: (Velocity velocity, Offset offset){
            setState((){
              _bubble.changeXPos(offset.dx, _screenWidth);
              _bubble.changeYPos(
                  offset.dy - _bubble.getSize()/2.0, _screenHeight);
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
              //_pushDetail(_bubble, _bubbleFont);
              Navigator.of(context).push(MaterialPageRoute(
                builder: (context) =>
                    DetailWidget(_bList, _theme, _bubble),
              ));
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
                ),
              ),
            ),
          ),
          childWhenDragging: Container(),
        ),
      ),
      top: _bubble.getYPos(),
      left: _bubble.getXPos(),
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
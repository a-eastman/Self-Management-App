import 'package:flutter/material.dart';
import 'package:flutter_app/themeSelection.dart';
import 'package:flutter_app/themes.dart';
import 'bubbles.dart';
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

  BubbleWidgetState createState() => BubbleWidgetState(this._bList, this._theme);
}

//Bubble class
class BubbleWidgetState extends State<BubbleWidget>{
  BubblesList _bList;
  BubbleTheme _theme;
  static final TextStyle _bubbleFont = const TextStyle(fontWeight: FontWeight.bold,
      fontSize: 15.0,
      fontFamily: 'SoulMarker');
  // AudioPlayer ap = new AudioPlayer();
  BubbleWidgetState(BubblesList _bList, BubbleTheme _theme){
    // this._bubble = _bubble;
    this._bList = _bList;
    this._theme = _theme;
  }

  Widget fakeBubble(Bubble _bubble){
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

  void _pushDetail(Bubble _bubble, TextStyle _bubbleFont){
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
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    fakeBubble(_bubble),
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
              ),
            ),
          );
        },
      ),
    );
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
              _pushDetail(_bubble, _bubbleFont);
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


  _addNewBubble(){
    final myController = TextEditingController();
    final myController2 = TextEditingController();
    final myController3 = TextEditingController();
    Bubble newBubble = new Bubble.defaultBubble();
    //newBubble.changePressed();
   
      
    //final TextStyle _biggerFont = const TextStyle(fontSize: 18.0);
    FocusNode fn;
    FocusNode fn2;
    fn = FocusNode();

    void initState() {
      super.initState();
    }

    void dispose(){
      fn.dispose();
      fn2.dispose();
      myController.dispose();
      super.dispose();
    }

    void _editBubble() {
      newBubble.setEntry(myController.text);
      newBubble.setDescription(myController2.text);
      newBubble.setSize(int.parse(myController3.text));
    }

    Navigator.of(context).push(
      new MaterialPageRoute<void>(
        builder: (BuildContext context) {
          //initState();
          return new Scaffold(
            appBar: new AppBar(
              title: const Text('Create New Task'),
            ),
            body: new Center(
                child: new Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                  TextFormField(
                    autofocus: true,
                    controller: myController,
                    decoration: const InputDecoration(
                      labelText: 'Task Name',
                    ),
                  ),
                  TextFormField(
                    autofocus: false,
                    focusNode: fn,
                    controller: myController2,
                    decoration: const InputDecoration(
                      labelText: 'Description',
                    ),
                  ),
                  TextFormField(
                    autofocus: false,
                    focusNode: fn2,
                    //enabled: fn.hasFocus,
                    controller: myController3,
                    decoration: const InputDecoration(
                      labelText: 'Priority (0 to 3)',
                    ),
                  ),
                  FlatButton(
                    onPressed: () {
                      setState ((){
                        _editBubble();
                        _bList.addBubble(newBubble);
                        newBubble.setColor(_bList.getBubbleAt(0).getColor());
                        // _myList.add(BubbleWidget(newBubble); 
                        Navigator.pop(context);
                      });
                    },
                    child: const Text('Save Bubble'),
                  ),
                ])),
          );
        },
      ),
    );

    //return newBubble;
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
                  builder: (context) => ThemeSelectorPage(theme: _theme, bublist: _bList),
                ));
                
              },
              
            ),
            new IconButton(
              icon: Icon(Icons.add_circle_outline),
              onPressed: (){
                setState(() {
                  _addNewBubble();
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
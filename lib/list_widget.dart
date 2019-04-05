import 'package:flutter/material.dart';
import 'themeSelection.dart';
import 'iamthebubble.dart';
import 'themes.dart';
import 'bubbles.dart';
import 'add_widget.dart';
import 'edit_widget.dart';

// ignore: must_be_immutable
class ListWidget extends StatefulWidget {
  BubblesList myList; //List of bubbles
  //List<BubbleWidget> widList; //List of bubble widgets
  BubbleTheme _theme;


  //ListWidget({Key key, this.myList}) : super(key : key);
  ListWidget(
      BubblesList myList, BubbleTheme _theme) {
    this.myList = myList;
    //this.widList = widList;
    this._theme = _theme;
  }

  ListWidgetState createState() =>
      ListWidgetState(this.myList, this._theme);
}

class ListWidgetState extends State<ListWidget> {
  static final TextStyle _bubbleFont = const TextStyle(
      fontWeight: FontWeight.bold, fontSize: 15.0, fontFamily: 'SoulMarker');
  BubblesList _myList;
  BubblesList _curList;
  //List<BubbleWidget> _widList;
  BubbleTheme _theme;
  bool addView;

  //int dropdownValue;
  //bool checkBox;

  ListWidgetState(
      BubblesList myList, BubbleTheme _theme) {
    this._myList = myList;
    //this._widList = widList;
    this._theme = _theme;
    addView = false;
  }

  //Creates the list view with dividers based on number of bubbles
  Widget _buildTasks() {
    return new ListView.builder(
        padding: const EdgeInsets.all(16.0),
        itemCount: _curList.getSize() * 2 - 1,
        itemBuilder: (BuildContext _context, int i) {
          // Add a one-pixel-high divider widget before each row
          // in the ListView.
          if (i.isOdd) {
            return new Divider();
          }
          final int index = i ~/ 2;
          return _buildRow(_curList.getBubbleAt(index));
        });
  }

  @override
  Widget build(BuildContext context) {
    // _myList.orderBubbles();
    _curList = new BubblesList();
    for (int i = 0; i < _myList.getSize(); i++) {
      if (!_myList.getBubbleAt(i).getShouldDelete()) {
        _curList.addBubble(_myList.getBubbleAt(i));
      }
    }
    _curList.orderBubbles();
    return Scaffold(

      appBar: AppBar(
        title: Text("BUBL List View"),
        actions: <Widget>[
          new IconButton(
            icon: Icon(Icons.brush),
            onPressed: () {
              Navigator.of(context).push(MaterialPageRoute(
                builder: (context) =>
                    ThemeSelectorPage(theme: _theme, bublist: _curList),
              ));
            },
          ),
          new IconButton(
            icon: Icon(Icons.add_circle_outline),
            onPressed: () {
              setState(() {
                Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) =>
                      AddWidget(this._myList, _theme),
                ));
              });
            },
          ),
        ],
      ),
      body: _buildTasks(),
    );
  }

  Widget _buildRepeat(Bubble _bubble) {
    final bool repeat = _bubble.getRepeat();
    return new Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        new Text(
          "Repeat      ",
          textScaleFactor: 1.25,
        ),
        new Icon(
          repeat ? Icons.check_box : Icons.check_box_outline_blank,
          color: repeat ? _bubble.getColor() : Colors.black,
        ),
      ],
    );
  }

  Widget _buildDay(String day, Bubble _bubble) {
    final bool repeat = _bubble.getRepeatDay(day);
    return new Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          new Container(
            width: 55,
            child: new FlatButton(
                child: new Icon(
                  repeat ? Icons.check_box : Icons.check_box_outline_blank,
                  color: repeat ? _bubble.getColor() : Colors.black,
                ),
            ),
          ),
          new Text(day),
        ]);
  }

  Widget _buildWeek(Bubble _bubble) {
    if(_bubble.getRepeat()) {
      return new Row(mainAxisSize: MainAxisSize.min, children: <Widget>[
        _buildDay("Sun", _bubble),
        _buildDay("Mon", _bubble),
        _buildDay("Tue", _bubble),
        _buildDay("Wed", _bubble),
        _buildDay("Thu", _bubble),
        _buildDay("Fri", _bubble),
        _buildDay("Sat", _bubble),
      ]);
    }
    else{
      return new Row();
    }
  }

  //Creates a list tile for a bubble
  Widget _buildRow(Bubble bubble) {
    final bool alreadyCompleted = !(bubble.getPressed());
    return new ListTile(
      title: new Text(
        bubble.getEntry(),
      ),
      trailing: new Icon(
        alreadyCompleted ? Icons.check_box : Icons.check_box_outline_blank,
        color: alreadyCompleted ? bubble.getColor() : Colors.black,
      ),
      subtitle: new Text(bubble.getDescription()),
      onTap: () {
        setState(() {
          bubble.changePressed();
        });
      },
      onLongPress: () {
        _pushDetail(bubble);
      },
    );
  }

  void _pushDetail(Bubble _bubble) {
    final TextStyle _biggerFont = const TextStyle(fontSize: 18.0);
    Navigator.of(context).push(
      new MaterialPageRoute<void>(
        builder: (BuildContext context) {
          return new Scaffold(
            appBar: new AppBar(
              title: Text("Bubble: " + _bubble.getEntry()),
              actions: <Widget>[
                new IconButton(
                    icon: const Icon(Icons.edit),
                    onPressed: () {
                      Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) =>
                            EditWidget(this._myList, _theme, _bubble),
                      ));
                    }),
              ],
            ),
            body: new Center(
              child: new Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    fakeBubble(_bubble),
                    Text(
                      "Title: " + _bubble.getEntry(),
                      style: _biggerFont,
                      textAlign: TextAlign.center,
                      overflow: TextOverflow.ellipsis,
                    ),
                    Text(
                      "Description: " + _bubble.getDescription(),
                      style: _biggerFont,
                      textAlign: TextAlign.center,
                      overflow: TextOverflow.clip,
                    ),
                    Text(
                      "Size: " + _bubble.getSize().toInt().toString(),
                      style: _biggerFont,
                      textAlign: TextAlign.center,
                      overflow: TextOverflow.ellipsis,
                    ),
                    Text(
                      "Completed: " + _bubble.getNumPressed().toString(),
                      style: _biggerFont,
                      textAlign: TextAlign.center,
                      overflow: TextOverflow.ellipsis,
                    ),
                    _buildRepeat(_bubble),
                    _buildWeek(_bubble),
                    RaisedButton(
                      color: Colors.red[100],
                      onPressed: () {
                        _bubble.setToDelete();
                      },
                      child: Text("DELETE"),
                    )
                  ]),
            ),
          );
        },
      ),
    );
  }

  Widget fakeBubble(Bubble _bubble) {
    return new Container(
      width: _bubble.getSize(),
      height: _bubble.getSize(),
      child: new Container(
        decoration: new BoxDecoration(
          color: _bubble.getColor(),
          shape: BoxShape.circle,
        ),
        child: new Center(
          child: Text(_bubble.getEntry(), style: _bubbleFont),
        ),
      ),
    );
  }

}

import 'package:flutter/material.dart';
import 'themeSelection.dart';
import 'themes.dart';
import 'bubbles.dart';
import 'add_widget.dart';
import 'edit_widget.dart';

// ignore: must_be_immutable
class DetailWidget extends StatefulWidget {
  BubblesList myList; //List of bubbles
  BubbleTheme _theme;
  Bubble bubble;

  //ListWidget({Key key, this.myList}) : super(key : key);
  DetailWidget(BubblesList myList, BubbleTheme _theme, Bubble bubble) {
    this.myList = myList;
    this._theme = _theme;
    this.bubble = bubble;
  }

  DetailWidgetState createState() =>
      DetailWidgetState(this.myList, this._theme, this.bubble);
}

class DetailWidgetState extends State<DetailWidget> {
  static final TextStyle _bubbleFont = const TextStyle(
      fontWeight: FontWeight.bold, fontSize: 15.0, fontFamily: 'SoulMarker');
  final TextStyle _biggerFont = const TextStyle(fontSize: 18.0);
  BubblesList _myList;
  BubbleTheme _theme;
  Bubble _bubble;

  DetailWidgetState(BubblesList myList, BubbleTheme _theme, Bubble bubble) {
    this._myList = myList;
    this._theme = _theme;
    this._bubble = bubble;
  }

  /// Creates a fake bubble to show in the details screen
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

  /// Builds the row to be shown in the details screen of
  /// the repeat text with the checkbox
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

  /// Builds the days of the week to be displayed on the
  /// detail screen.
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

  /// Creates the row of days of the week that will appear if the
  /// bubble has repeat set to true.
  Widget _buildWeek(Bubble _bubble) {
    if (_bubble.getRepeat()) {
      return new Row(mainAxisSize: MainAxisSize.min, children: <Widget>[
        _buildDay("Sun", _bubble),
        _buildDay("Mon", _bubble),
        _buildDay("Tue", _bubble),
        _buildDay("Wed", _bubble),
        _buildDay("Thu", _bubble),
        _buildDay("Fri", _bubble),
        _buildDay("Sat", _bubble),
      ]);
    } else {
      return new Row();
    }
  }

  /// Configures the Container on top of the
  /// example bubble
  Widget getBottomSpacing(Bubble _bubble) {
    double height = 0;
    if (_bubble.getSizeIndex() == 3) {
      height = 10;
    } else if (_bubble.getSizeIndex() == 2) {
      height = 25;
    } else if (_bubble.getSizeIndex() == 1) {
      height = 35;
    } else if (_bubble.getSizeIndex() == 0) {
      height = 50;
    }
    return new Container(height: height);
  }

  /// Configures the Container on bottom of the
  /// example bubble
  Widget getTopSpacing(Bubble _bubble) {
    double height = 0;
    if (_bubble.getSizeIndex() == 3) {
      height = 10;
    } else if (_bubble.getSizeIndex() == 2) {
      height = 25;
    } else if (_bubble.getSizeIndex() == 1) {
      height = 35;
    } else if (_bubble.getSizeIndex() == 0) {
      height = 50;
    }
    return new Container(height: height);
  }

  @override
  Widget build(BuildContext context) {
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
      body: ListView(shrinkWrap: false, children: <Widget>[
        Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              getTopSpacing(_bubble),
              fakeBubble(_bubble),
              getBottomSpacing(_bubble),
              Text(
                "Title: " + _bubble.getEntry(),
                style: _biggerFont,
                textAlign: TextAlign.center,
                overflow: TextOverflow.ellipsis,
              ),
              Container(height: 20),
              Text(
                "Description: " + _bubble.getDescription(),
                style: _biggerFont,
                textAlign: TextAlign.center,
                overflow: TextOverflow.clip,
              ),
              Container(height: 20),
              Text(
                "Size: " + _bubble.getSize().toInt().toString(),
                style: _biggerFont,
                textAlign: TextAlign.center,
                overflow: TextOverflow.ellipsis,
              ),
              Container(height: 20),
              Text(
                "Completed: " + _bubble.getNumPressed().toString(),
                style: _biggerFont,
                textAlign: TextAlign.center,
                overflow: TextOverflow.ellipsis,
              ),
              Container(height: 15),
              _buildRepeat(_bubble),
              Container(height: 5),
              _buildWeek(_bubble),
              Container(height: 10),
              RaisedButton(
                color: Colors.red[100],
                onPressed: () {
                  _bubble.setToDelete();
                  Navigator.pop(context);
                },
                child: Text("DELETE"),
              )
            ]),
      ]),
    );
  }
}

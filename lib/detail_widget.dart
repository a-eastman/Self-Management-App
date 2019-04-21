///Screen for showing the details of a bubble
///@author Abigail Eastman, Caeleb Nasoff, Chris Malitsky
///
///
///LAST EDIT : April 19, 2019

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
  Bubble _bubble;
  double _screenHeight;
  double _screenWidth;

  //ListWidget({Key key, this.myList}) : super(key : key);
  DetailWidget(BubblesList _myList, BubbleTheme _theme, Bubble _bubble,
      double _screenHeight, double _screenWidth) {
    this.myList = _myList;
    this._theme = _theme;
    this._bubble = _bubble;
    this._screenHeight = _screenHeight;
    this._screenWidth = _screenWidth;
  }

  DetailWidgetState createState() =>
      DetailWidgetState(this.myList, this._theme, this._bubble, this._screenHeight, this._screenWidth);
}

class DetailWidgetState extends State<DetailWidget> {
  static final TextStyle _bubbleFont = const TextStyle(
      fontWeight: FontWeight.bold, fontSize: 15.0, fontFamily: 'SoulMarker');
  final TextStyle _biggerFont = const TextStyle(fontSize: 18.0);
  BubblesList _myList;
  BubbleTheme _theme;
  Bubble _bubble;
  double _screenHeight;
  double _screenWidth;

  DetailWidgetState(BubblesList _myList, BubbleTheme _theme, Bubble _bubble,
      double _screenHeight, double _screenWidth) {
    this._myList = _myList;
    this._theme = _theme;
    this._bubble = _bubble;
    this._screenHeight = _screenHeight;
    this._screenWidth = _screenWidth;
  }

  /// Creates a fake bubble to show in the details screen.
  Widget fakeBubble(Bubble _bubble, double _screenHeight) {
    double _bSize = _screenHeight * _bubble.getSize();
    return new Container(
      width: _bSize,
      height: _bSize,
      child: new Container(
        decoration: new BoxDecoration(
          color: _bubble.getColor(),
          shape: BoxShape.circle,
        ),
        child: new Center(
          child: Text(_bubble.getEntry()),
        ),
      ),
    );
  }

  /// Builds the row to be shown in the details screen of
  /// the repeat text with the checkbox.
  Widget _buildRepeat(Bubble _bubble) {
    bool _placeholder = false;
    if (_bubble.getRepeat() != null)
    {
      _placeholder = _bubble.getRepeat();
    }
    final bool _repeat = _placeholder;
    return new Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        new Text(
          "Repeat      ",
          //textScaleFactor: 1.25,
        ),
        new Icon(
          _repeat ? Icons.check_box : Icons.check_box_outline_blank,
          color: _repeat ? _bubble.getColor() : Colors.black,
        ),
      ],
    );
  }

  /// Builds the days of the week to be displayed on the
  /// detail screen.
  Widget _buildDay(String day, Bubble _bubble) {
    final bool repeat = _bubble.getRepeatDay(day);
    double _w = this._screenWidth / 7.5;
    return new Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          new Container(
            // width: 55,
            width: _w,
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
    bool _ph = false;
    if (_bubble.getRepeat() != null){
      _ph = _bubble.getRepeat();
    }
    if (_ph) {
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

  /// Configures the Container on bottom and top of the
  /// example bubble.
  Widget getSpacing(Bubble _bubble) {
    double _height = 0;
    if (_bubble.getSizeIndex() == 3) {
      _height = 10;
    } else if (_bubble.getSizeIndex() == 2) {
      _height = 25;
    } else if (_bubble.getSizeIndex() == 1) {
      _height = 35;
    } else if (_bubble.getSizeIndex() == 0) {
      _height = 50;
    }
    return new Container(height: _height);
  }

  @override
  Widget build(BuildContext context) {
    double _screenHeight =MediaQuery.of(context).size.height;
    double _screenWidth = MediaQuery.of(context).size.width;
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
              getSpacing(_bubble),
              fakeBubble(_bubble, _screenHeight),
              getSpacing(_bubble),
              Text(
                "Title: " + _bubble.getEntry(),
                //style: _biggerFont,
                textAlign: TextAlign.center,
                overflow: TextOverflow.ellipsis,
              ),
              Container(height: 20),
              Text(
                "Description: " + _bubble.getDescription(),
                //style: _biggerFont,
                textAlign: TextAlign.center,
                overflow: TextOverflow.clip,
              ),
              Container(height: 20),
              Text(
                "Size: " + _bubble.getSizeIndex().toString(),
                //style: _biggerFont,
                textAlign: TextAlign.center,
                overflow: TextOverflow.ellipsis,
              ),
              Container(height: 20),
              Text(
                "Completed: " + _bubble.getNumPressed().toString(),
                //style: _biggerFont,
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

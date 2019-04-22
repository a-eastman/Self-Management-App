/// Edit view screen for bubbles
///@author Abigail Eastman, Caeleb Nasoff, Chris Malitsky
///
///
///LAST EDIT : April 19, 2019
///

import 'package:flutter/material.dart';
import 'themeSelection.dart';
import 'themes.dart';
import 'bubbles.dart';

// ignore: must_be_immutable
class EditWidget extends StatefulWidget {
  BubblesList _myList; //List of bubbles
  BubbleTheme _theme;
  Bubble _bubble;

  //ListWidget({Key key, this.myList}) : super(key : key);
  EditWidget(BubblesList _myList, BubbleTheme _theme, Bubble _bubble) {
    this._myList = _myList;
    this._theme = _theme;
    this._bubble = _bubble;
  }

  EditWidgetState createState() =>
      EditWidgetState(this._myList, this._theme, this._bubble);
}

class EditWidgetState extends State<EditWidget> {
  static final TextStyle _bubbleFont = const TextStyle(
      fontWeight: FontWeight.bold, fontSize: 15.0, fontFamily: 'SoulMarker');
  BubblesList _myList;
  BubbleTheme _theme;
  Bubble _bubble;

  EditWidgetState(BubblesList _myList, BubbleTheme _theme, Bubble _bubble) {
    this._myList = _myList;
    this._theme = _theme;
    this._bubble = _bubble;
  }

  var _myController;
  var _myController2;
  FocusNode _fn = FocusNode();
  FocusNode _fn2 = FocusNode();
  Bubble _temp;

  /// Set the initial values
  void initState() {
    super.initState();
    _temp = new Bubble.defaultBubble();
    print('REPEAT: ' + _bubble.getRepeat().toString());
    _temp.setRepeat(_bubble.getRepeat());
    _temp.setRepeatDay("Mon", _bubble.getRepeatDay("Mon"));
    _temp.setRepeatDay("Tue", _bubble.getRepeatDay("Tue"));
    _temp.setRepeatDay("Wed", _bubble.getRepeatDay("Wed"));
    _temp.setRepeatDay("Thu", _bubble.getRepeatDay("Thu"));
    _temp.setRepeatDay("Fri", _bubble.getRepeatDay("Fri"));
    _temp.setRepeatDay("Sat", _bubble.getRepeatDay("Sat"));
    _temp.setRepeatDay("Sun", _bubble.getRepeatDay("Sun"));
    _temp.setSize(_bubble.getSizeIndex());
    _myController = TextEditingController(text: _bubble.getEntry());
    _myController2 = TextEditingController(text: _bubble.getDescription());
  }

  /// Get rid of memory used when closing the screen
  void dispose() {
    _fn.dispose();
    _fn2.dispose();
    _myController.dispose();
    _myController2.dispose();
    super.dispose();
  }

  /// Change the values entered in to the bubble
  void _editBubble() {
    _bubble.setEntry(_myController.text);
    _bubble.setDescription(_myController2.text);
    _bubble.setSize(_temp.getSizeIndex());
    _bubble.setColor(_temp.getColor());
    /// If none of the days are selected to repeat, then set
    /// the repeat value to false.
    if(!_temp.getRepeatDay("Mon") && !_temp.getRepeatDay("Tue") &&
        !_temp.getRepeatDay("Wed") && !_temp.getRepeatDay("Thu") &&
        !_temp.getRepeatDay("Fri") && !_temp.getRepeatDay("Sat") &&
        !_temp.getRepeatDay("Sun")){
      _bubble.setRepeat(false);
    } else{
      _bubble.setRepeat(_temp.getRepeat());
    }

    /// When there is a repeat, set the days to the selected value.
    /// If no repeat, set all the days to false.
    if(_temp.getRepeat()){
      _bubble.setRepeatDay("Mon",_temp.getRepeatDay("Mon"));
      _bubble.setRepeatDay("Tue",_temp.getRepeatDay("Tue"));
      _bubble.setRepeatDay("Wed",_temp.getRepeatDay("Wed"));
      _bubble.setRepeatDay("Thu",_temp.getRepeatDay("Thu"));
      _bubble.setRepeatDay("Fri",_temp.getRepeatDay("Fri"));
      _bubble.setRepeatDay("Sat",_temp.getRepeatDay("Sat"));
      _bubble.setRepeatDay("Sun",_temp.getRepeatDay("Sun"));
    } else {
      _bubble.setRepeatDay("Mon",false);
      _bubble.setRepeatDay("Tue",false);
      _bubble.setRepeatDay("Wed",false);
      _bubble.setRepeatDay("Thu",false);
      _bubble.setRepeatDay("Fri",false);
      _bubble.setRepeatDay("Sat",false);
      _bubble.setRepeatDay("Sun",false);
    }
  }

  /// Creates the repeat checkbox.
  Widget _buildRepeat() {
    final bool repeat = _temp.getRepeat();
    return new ListTile(
      title: new Text("Repeat"),
      trailing: new Icon(
        repeat ? Icons.check_box : Icons.check_box_outline_blank,
        color: repeat ? _temp.getColor() : Colors.black,
      ),
      onTap: () {
        setState(() {
          _temp.changeRepeat();
        });
      },
    );
  }

  /// Creates a day checkbox with label.
  Widget _buildDay(String _day, double _screenWidth) {
    double _w = _screenWidth / 8;
    final bool _repeat = _temp.getRepeatDay(_day);
    return new Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          new Container(
            width: _w,
            child: new FlatButton(
                child: new Icon(
                  _repeat ? Icons.check_box : Icons.check_box_outline_blank,
                  color: _repeat ? _temp.getColor() : Colors.black,
                ),
                onPressed: () {
                  setState(() {
                    _temp.changeRepeatDay(_day);
                  });
                }),
          ),
          new Text(_day),
        ]);
  }

  /// Makes the row for the day of the week selection.
  Widget _buildWeek(double _screenWidth) {
    if (_temp.getRepeat()) {
      return new Row(mainAxisSize: MainAxisSize.min, children: <Widget>[
        _buildDay("Sun", _screenWidth),
        _buildDay("Mon", _screenWidth),
        _buildDay("Tue", _screenWidth),
        _buildDay("Wed", _screenWidth),
        _buildDay("Thu", _screenWidth),
        _buildDay("Fri", _screenWidth),
        _buildDay("Sat", _screenWidth),
      ]);
    } else {
      return new Row();
    }
  }

  @override
  Widget build(BuildContext context) {
    double _screenHeight =MediaQuery.of(context).size.height;
    double _screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
        appBar: AppBar(
          title: Text("Edit Bubble"),
        ),
        body: ListView(children: <Widget>[
          Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              TextFormField(
                autofocus: true,
                controller: _myController,
                decoration: const InputDecoration(
                  labelText: 'Task Name',
                ),
              ),
              TextFormField(
                autofocus: false,
                focusNode: _fn,
                controller: _myController2,
                decoration: const InputDecoration(
                  labelText: 'Description',
                ),
              ),
              DropdownButtonFormField<int>(
                decoration: const InputDecoration(
                  labelText: 'Priority (0 to 3)',
                ),
                value: _temp.getSizeIndex(),
                onChanged: (int newValue) {
                  setState(() {
                    _temp.setSize(newValue);
                  });
                },
                items: <int>[0, 1, 2, 3]
                    .map<DropdownMenuItem<int>>((int value) {
                  return DropdownMenuItem<int>(
                    value: value,
                    child: Text(value.toString()),
                  );
                })
                    .toList(),
              ),
              _buildColorOptions(_screenWidth),
              _buildRepeat(),
              _buildWeek(_screenWidth),
              Container(height: 20),
              RaisedButton(
                color: _temp.getColor(),
                onPressed: () {
                  _editBubble();
                  Navigator.pop(context);
                },
                child: const Text('EDIT'),
              ),
            ],
          ),
        ]));
  }

  // Builds the individual buttons to select a color
  Widget _buildColorOptionButton(String color, Color bubbleColor, double _screenWidth){
    double _w = _screenWidth / 8;
    return new Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        new Container(
          width: _w,
          child: new RaisedButton(
            color: bubbleColor,
            onPressed: (){
              setState(() {
                _temp.setColor(bubbleColor);
              });
            },
          ),
        ),
        new Text(color),
      ],
    );
  }

  // Builds the row of buttons
  Widget _buildColorOptions(double _screenWidth){
    return new Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: <Widget>[
        _buildColorOptionButton("Blue", Colors.blue[300], _screenWidth),
        _buildColorOptionButton("Orange", Colors.orange[300], _screenWidth),
        _buildColorOptionButton("Purple", Colors.purple[300], _screenWidth),
        _buildColorOptionButton("Red", Colors.red[300], _screenWidth),
        _buildColorOptionButton("Yellow", Colors.yellow[300], _screenWidth),
      ],
    );
  }

  /// Determines what color to make the bubble
  Color getBubbleColor(BubblesList _myList) {
    if (_myList.getSize() == 0) {
      return Colors.blue;
    } else {
      return _myList.getBubbleAt(0).getColor();
    }
  }
}
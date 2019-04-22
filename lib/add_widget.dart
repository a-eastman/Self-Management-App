///Screen for adding a new bubble
///@author Abigail Eastman
///
///
///LAST EDIT : April 19, 2019
///@author for EDIT ONLY : Martin Price
///
///Updated the add bubble functionality to only add a bubble at the end of the screen
///This eleminates populating the DB with null bubbles if the user decides to back out
///of the screen

import 'package:flutter/material.dart';
import 'themeSelection.dart';
import 'themes.dart';
import 'bubbles.dart';

// ignore: must_be_immutable
class AddWidget extends StatefulWidget {
  /// The list of bubbles.
  BubblesList _myList;
  /// The theme data for this page.
  BubbleTheme _theme;

  //ListWidget({Key key, this.myList}) : super(key : key);
  AddWidget(BubblesList _myList, BubbleTheme _theme) {
    this._myList = _myList;
    this._theme = _theme;
  }

  AddWidgetState createState() => AddWidgetState(this._myList, this._theme);
}

class AddWidgetState extends State<AddWidget> {
  static final TextStyle _bubbleFont = const TextStyle(
      fontWeight: FontWeight.bold, fontSize: 15.0, fontFamily: 'SoulMarker');
  BubblesList _myList;
  BubbleTheme _theme;

  AddWidgetState(BubblesList _myList, BubbleTheme _theme) {
    this._myList = _myList;
    this._theme = _theme;
  }

  final _myController = TextEditingController();
  final _myController2 = TextEditingController();
  final _myController3 = TextEditingController();

  //Bubble newBubble = new Bubble.defaultBubble();
  Bubble _newBubble;
  bool _bubbleCreated = false;
  //String entry = 'New Bubble Entry';
  //String desc = 'New Bubble Description';
  int _sizeIndex = 0;
  bool _repeat = false;
  bool _repeatMonday = false;
  bool _repeatTuesday = false;
  bool _repeatWednesday = false;
  bool _repeatThursday = false;
  bool _repeatFriday = false;
  bool _repeatSaturday = false;
  bool _repeatSunday = false;
  Color _bColor = Colors.blue;
  FocusNode _fn = FocusNode();
  FocusNode _fn2 = FocusNode();

  void initState() {
    super.initState();

    //setState((){});
  }

  void dispose() {
    _fn.dispose();
    _fn2.dispose();
    _myController.dispose();
    _myController2.dispose();
    _myController3.dispose();
    super.dispose();
  }

  /// Edits the bubble with the information entered by the user.
  void _editBubble() {
    _newBubble.setEntry(_myController.text);
    _newBubble.setDescription(_myController2.text);
  }

  /// Makes the new Bubble
  void _makeBubble(){
    int _frequency = 0;
    if(!_bubbleCreated){
      print('Make a new bubble!');
      if(!_repeat){
        _repeatMonday = false;
        _repeatTuesday = false;
        _repeatWednesday = false;
        _repeatThursday = false;
        _repeatFriday = false;
        _repeatSaturday = false;
        _repeatSunday = false;
      }
      if(!_repeatMonday && !_repeatTuesday && !_repeatWednesday &&
          !_repeatThursday && !_repeatFriday && !_repeatSaturday &&
          !_repeatSunday){
        _repeat = false;
      }

      _newBubble = new Bubble(_myController.text, _myController2.text, _bColor,
          _sizeIndex, true, 0.5, 0.5, 1.0, _frequency, _repeat, _repeatMonday,
          _repeatTuesday, _repeatWednesday, _repeatThursday, _repeatFriday,
          _repeatSaturday, _repeatSunday);
      _bubbleCreated = true;
    }
    else print('Bubble has already been made!');
  }

  /// Creates the checkbox for the repeating option.
  Widget _buildRepeat() {
    //final bool repeat = newBubble.getRepeat();
    //final bool bubRepeat = false;
    return new ListTile(
      title: new Text("Repeat"),
      trailing: new Icon(
        _repeat ? Icons.check_box : Icons.check_box_outline_blank,
        color: _repeat ? _bColor : Colors.black,
      ),
      onTap: () {
        setState(() {
          _repeat = !_repeat;
          //newBubble.changeRepeat();
        });
      },
    );
  }

  /// Makes the day checkbox and label.
  Widget _buildDay(String day, double _screenWidth) {
    //final bool repeat = newBubble.getRepeatDay(day);
    final bool dayRepeat = getRepeatDay(day);
    double _w = _screenWidth / 8;
    return new Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          new Container(
            width: _w,
            child: new FlatButton(
                child: new Icon(
                  dayRepeat ? Icons.check_box : Icons.check_box_outline_blank,
                  color: dayRepeat ? _bColor : Colors.black,
                ),
                onPressed: () {
                  setState(() {
                    //newBubble.changeRepeatDay(day);
                    changeDayRepeat(day);
                  });
                }),
          ),
          new Text(day),
        ]);
  }

  /// Brought in @author Abigail methods from [Bubble].
  /// Determines which day is being used.
  bool getRepeatDay(String _day){
    bool _result = true;
    switch(_day) {
      case "Mon": {_result = _repeatMonday; }
      break;
      case "Tue": {_result = _repeatTuesday;}
      break;
      case "Wed": {_result = _repeatWednesday;}
      break;
      case "Thu": {_result = _repeatThursday;}
      break;
      case "Fri": {_result = _repeatFriday;}
      break;
      case "Sat": {_result = _repeatSaturday;}
      break;
      case "Sun": {_result = _repeatSunday;}
      break;
    }
    return _result;
  }

  /// Uses the [_day] to determine which boolean to change.
  void changeDayRepeat(String _day){
    switch(_day) {
      case "Mon": {_repeatMonday = !_repeatMonday; print('Monday is $_repeatMonday');}
      break;
      case "Tue": {_repeatTuesday = !_repeatTuesday;}
      break;
      case "Wed": {_repeatWednesday = !_repeatWednesday;}
      break;
      case "Thu": {_repeatThursday = !_repeatThursday;}
      break;
      case "Fri": {_repeatFriday = !_repeatFriday;}
      break;
      case "Sat": {_repeatSaturday = !_repeatSaturday;}
      break;
      case "Sun": {_repeatSunday = !_repeatSunday;}
      break;
    }
  }

  /// Creates the row of days of the week.
  Widget _buildWeek(double _screenWidth) {
    //if (newBubble.getRepeat()) {
    if(_repeat){
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

  /// Builds the individual buttons to select a color based upon the screen width.
  Widget _buildColorOptionButton(String _color, Color _bubbleColor, double _screenWidth){
    double _w = _screenWidth / 8;
    return new Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        new Container(
          width: _w,
          child: new RaisedButton(
            color: _bubbleColor,
            onPressed: (){
              setState(() {
                _bColor = _bubbleColor;
              });
            },
          ),
        ),
        new Text(_color),
      ],
    );
  }

  /// Builds the row of buttons to change the color.
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

  /// Builds the screen for the user to add a new bubble.
  @override
  Widget build(BuildContext context) {
    double _screenHeight =MediaQuery.of(context).size.height;
    double _screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
        appBar: AppBar(
          title: Text("Add New Bubble"),
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
                //value: newBubble.getSizeIndex(),
                value: _sizeIndex,
                onChanged: (int _newValue) {
                  setState(() {
                    _sizeIndex = _newValue;
                    //newBubble.setSize(newValue);
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
                color: _bColor,
                onPressed: () {
                  //_editBubble();
                  _makeBubble();
                  _myList.addBubble(_newBubble);
                  //newBubble.setColor(getBubbleColor(_myList));
                  Navigator.pop(context);
                },
                child: const Text('ADD'),
              ),
            ],
          ),
        ]));
  }

  /// Determines what color to make the new bubble.
  Color getBubbleColor(BubblesList _myList) {
    if (_myList.getSize() == 0) {
      return Colors.blue;
    } else {
      return _myList.getBubbleAt(0).getColor();
    }
  }
}

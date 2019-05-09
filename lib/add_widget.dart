///Screen for adding a new bubble
///@author Abigail Eastman, Chris Malitsky
///
///
///LAST EDIT : April 29, 2019
///@author for EDIT ONLY : Martin Price
///
///Updated the add bubble functionality to only add a bubble at the
///end of the screen. This eliminates populating the DB with null bubbles
///if the user decides to back out of the screen.

import 'package:flutter/material.dart';
import 'themes.dart';
import 'bubbles.dart';

// ignore: must_be_immutable
class AddWidget extends StatefulWidget {
  BubblesList _myList; //List of bubbles
  BubbleTheme _theme; //Theme for the screen and bubbles

  AddWidget(BubblesList _myList, BubbleTheme _theme) {
    this._myList = _myList;
    this._theme = _theme;
  }

  AddWidgetState createState() => AddWidgetState(this._myList, this._theme);
}

class AddWidgetState extends State<AddWidget> {
  BubblesList _myList; //List of bubbles
  BubbleTheme _theme; //Theme for screen and bubbles

  AddWidgetState(BubblesList _myList, BubbleTheme _theme) {
    this._myList = _myList;
    this._theme = _theme;
  }

  final _myController = TextEditingController(); //Text in the first text box.
  final _myController2 = TextEditingController(); //Text in the second text box.
  Bubble _newBubble; //Bubble being created.
  bool _bubbleCreated = false; //If the bubble is created or not.
  int _sizeIndex = 0; //Size of the bubble.
  bool _repeat = false; //If the bubble repeats.
  bool _repeatMonday = false; //If the bubble repeats on Monday.
  bool _repeatTuesday = false; //If the bubble repeats on Tuesday.
  bool _repeatWednesday = false; //If the bubble repeats on Wednesday.
  bool _repeatThursday = false; //If the bubble repeats on Thursday.
  bool _repeatFriday = false; //If the bubble repeats on Friday.
  bool _repeatSaturday = false; //If the bubble repeats on Saturday.
  bool _repeatSunday = false; //If the bubble repeats on Sunday.
  Color _bColor = Colors.blue; //The color of the bubble.
  FocusNode _fn = FocusNode(); //Focus on the second text box.

  void initState() {
    super.initState();
  }

  void dispose() {
    _fn.dispose();
    _myController.dispose();
    _myController2.dispose();
    super.dispose();
  }

  /// Makes the new Bubble.
  void _makeBubble() {
    int _frequency = 0;
    // Makes a new bubble is one has not already been created.
    if (!_bubbleCreated) {
      // Sets all the days to not repeat if overall repeat set to false.
      if (!_repeat) {
        _repeatMonday = false;
        _repeatTuesday = false;
        _repeatWednesday = false;
        _repeatThursday = false;
        _repeatFriday = false;
        _repeatSaturday = false;
        _repeatSunday = false;
      }
      // Sets overall repeat to false if none of the days are set to repeat.
      if (!_repeatMonday &&
          !_repeatTuesday &&
          !_repeatWednesday &&
          !_repeatThursday &&
          !_repeatFriday &&
          !_repeatSaturday &&
          !_repeatSunday) {
        _repeat = false;
      }
      // Creates the new bubble.
      _newBubble = new Bubble(
          _myController.text,
          _myController2.text,
          _bColor,
          _sizeIndex,
          true,
          0.5,
          0.5,
          1.0,
          _frequency,
          _repeat,
          _repeatMonday,
          _repeatTuesday,
          _repeatWednesday,
          _repeatThursday,
          _repeatFriday,
          _repeatSaturday,
          _repeatSunday);
      _bubbleCreated = true;
    } else
      print('Bubble has already been made!');
  }

  /// Creates the checkbox for the repeating option.
  Widget _buildRepeat() {
    return new ListTile(
      title: new Text("Repeat"),
      trailing: new Icon(
        _repeat ? Icons.check_box : Icons.check_box_outline_blank,
        color: _repeat ? _bColor : Colors.black,
      ),
      onTap: () {
        setState(() {
          _repeat = !_repeat;
        });
      },
    );
  }

  /// Makes the day checkbox and label.
  Widget _buildDay(String day, double _screenWidth) {
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
                    changeDayRepeat(day);
                  });
                }),
          ),
          new Text(day),
        ]);
  }

  /// Determines if the [_day] is repeating in the bubble
  bool getRepeatDay(String _day) {
    bool _result = true;
    switch (_day) {
      case "Mon":
        {
          _result = _repeatMonday;
        }
        break;
      case "Tue":
        {
          _result = _repeatTuesday;
        }
        break;
      case "Wed":
        {
          _result = _repeatWednesday;
        }
        break;
      case "Thu":
        {
          _result = _repeatThursday;
        }
        break;
      case "Fri":
        {
          _result = _repeatFriday;
        }
        break;
      case "Sat":
        {
          _result = _repeatSaturday;
        }
        break;
      case "Sun":
        {
          _result = _repeatSunday;
        }
        break;
    }
    return _result;
  }

  /// Uses the [_day] to determine which boolean to change.
  void changeDayRepeat(String _day) {
    switch (_day) {
      case "Mon":
        {
          _repeatMonday = !_repeatMonday;
        }
        break;
      case "Tue":
        {
          _repeatTuesday = !_repeatTuesday;
        }
        break;
      case "Wed":
        {
          _repeatWednesday = !_repeatWednesday;
        }
        break;
      case "Thu":
        {
          _repeatThursday = !_repeatThursday;
        }
        break;
      case "Fri":
        {
          _repeatFriday = !_repeatFriday;
        }
        break;
      case "Sat":
        {
          _repeatSaturday = !_repeatSaturday;
        }
        break;
      case "Sun":
        {
          _repeatSunday = !_repeatSunday;
        }
        break;
    }
  }

  /// Creates the row of days of the week.
  Widget _buildWeek(double _screenWidth) {
    if (_repeat) {
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

  /// Builds the individual buttons to select a [_bubbleColor]
  /// for a bubble based upon the [_screenWidth].
  Widget _buildColorOptionButton(
      String _color, Color _bubbleColor, double _screenWidth) {
    double _w = _screenWidth / 8;
    return new Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        new Container(
          width: _w,
          child: new RaisedButton(
            color: _bubbleColor,
            onPressed: () {
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
  Widget _buildColorOptions(double _screenWidth) {
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
    double _screenHeight = MediaQuery.of(context).size.height;
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
                value: _sizeIndex,
                onChanged: (int _newValue) {
                  setState(() {
                    _sizeIndex = _newValue;
                  });
                },
                items:
                    <int>[0, 1, 2, 3].map<DropdownMenuItem<int>>((int value) {
                  return DropdownMenuItem<int>(
                    value: value,
                    child: Text(value.toString()),
                  );
                }).toList(),
              ),
              _buildColorOptions(_screenWidth),
              _buildRepeat(),
              _buildWeek(_screenWidth),
              Container(height: 20),
              RaisedButton(
                color: _bColor,
                onPressed: () {
                  _makeBubble();
                  _addBubbleToList();
                  Navigator.pop(context);
                },
                child: const Text('ADD'),
              ),
            ],
          ),
        ]));
  }

  ///If bubble repeats today, add it to the list.
  void _addBubbleToList() {
    if (_newBubble.repeatesToday()) _myList.addBubble(_newBubble);
  }
}

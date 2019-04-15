///Screen for adding a new bubble
///@author Abigail Eastman
///
///
///LAST EDIT : April 13, 2019
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
  BubblesList myList; //List of bubbles
  BubbleTheme _theme;

  //ListWidget({Key key, this.myList}) : super(key : key);
  AddWidget(BubblesList myList, BubbleTheme _theme) {
    this.myList = myList;
    this._theme = _theme;
  }

  AddWidgetState createState() => AddWidgetState(this.myList, this._theme);
}

class AddWidgetState extends State<AddWidget> {
  static final TextStyle _bubbleFont = const TextStyle(
      fontWeight: FontWeight.bold, fontSize: 15.0, fontFamily: 'SoulMarker');
  BubblesList _myList;
  BubbleTheme _theme;

  AddWidgetState(BubblesList myList, BubbleTheme _theme) {
    this._myList = myList;
    this._theme = _theme;
  }

  final myController = TextEditingController();
  final myController2 = TextEditingController();
  final myController3 = TextEditingController();

  //Bubble newBubble = new Bubble.defaultBubble();
  Bubble newBubble;
  bool bubbleCreated = false;
  //String entry = 'New Bubble Entry';
  //String desc = 'New Bubble Description';
  int sizeIndex = 0;
  bool repeat = false;
  bool repeatMonday = false;
  bool repeatTuesday = false;
  bool repeatWednesday = false;
  bool repeatThursday = false;
  bool repeatFriday = false;
  bool repeatSaturday = false;
  bool repeatSunday = false;
  Color bColor = Colors.blue;
  String bColorString = "blue";
  FocusNode fn = FocusNode();
  FocusNode fn2 = FocusNode();

  void initState() {
    super.initState();

    //setState((){});
  }

  void dispose() {
    fn.dispose();
    fn2.dispose();
    myController.dispose();
    myController2.dispose();
    myController3.dispose();
    super.dispose();
  }

  /// Edits the bubble with the information entered
  void _editBubble() {
    newBubble.setEntry(myController.text);
    newBubble.setDescription(myController2.text);
  }

  ///Makes the new Bubble
  void _makeBubble(){
    if(!bubbleCreated){
      print('Make a new bubble!');
      newBubble = new Bubble(myController.text, myController2.text, bColor, bColorString, 
        sizeIndex, true, 0.5, 0.5, 1.0, repeat, repeatMonday, repeatTuesday, repeatWednesday,
        repeatThursday, repeatFriday, repeatSaturday, repeatSunday);
      bubbleCreated = true;
    }
    else print('Bubble has already been made!');
  }

  /// Creates the checkbox for repeating
  Widget _buildRepeat() {
    //final bool repeat = newBubble.getRepeat();
    //final bool bubRepeat = false;
    return new ListTile(
      title: new Text("Repeat"),
      trailing: new Icon(
        repeat ? Icons.check_box : Icons.check_box_outline_blank,
        color: repeat ? getBubbleColor(_myList) : Colors.black,
      ),
      onTap: () {
        setState(() {
          repeat = !repeat;
          //newBubble.changeRepeat();
        });
      },
    );
  }

  /// Makes the day checkbox and label
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
                  color: dayRepeat ? getBubbleColor(_myList) : Colors.black,
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

  ///Brought in @author Abigail methods from Bubble
  bool getRepeatDay(String day){
    bool result = true;
    switch(day) {
      case "Mon": {result = repeatMonday; }
      break;
      case "Tue": {result = repeatTuesday;}
      break;
      case "Wed": {result = repeatWednesday;}
      break;
      case "Thu": {result = repeatThursday;}
      break;
      case "Fri": {result = repeatFriday;}
      break;
      case "Sat": {result = repeatSaturday;}
      break;
      case "Sun": {result = repeatSunday;}
      break;
    }
    return result;
  }
  void changeDayRepeat(String day){
    switch(day) {
      case "Mon": {repeatMonday = !repeatMonday; print('Monday is $repeatMonday');}
      break;
      case "Tue": {repeatTuesday = !repeatTuesday;}
      break;
      case "Wed": {repeatWednesday = !repeatWednesday;}
      break;
      case "Thu": {repeatThursday = !repeatThursday;}
      break;
      case "Fri": {repeatFriday = !repeatFriday;}
      break;
      case "Sat": {repeatSaturday = !repeatSaturday;}
      break;
      case "Sun": {repeatSunday = !repeatSunday;}
      break;
    }
  }

  /// Creates the row of days of the week
  Widget _buildWeek(double _screenWidth) {
    //if (newBubble.getRepeat()) {
    if(repeat){
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
                bColor = bubbleColor;
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
              DropdownButtonFormField<int>(
                decoration: const InputDecoration(
                  labelText: 'Priority (0 to 3)',
                ),
                //value: newBubble.getSizeIndex(),
                value: sizeIndex,
                onChanged: (int newValue) {
                  setState(() {
                    sizeIndex = newValue;
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
                color: bColor,
                onPressed: () {
                  //_editBubble();
                  _makeBubble();
                  _myList.addBubble(newBubble);
                  //newBubble.setColor(getBubbleColor(_myList));
                  Navigator.pop(context);
                },
                child: const Text('ADD'),
              ),
            ],
          ),
        ]));
  }

  /// Determines what color to make the new bubble
  Color getBubbleColor(BubblesList _myList) {
    if (_myList.getSize() == 0) {
      return Colors.blue;
    } else {
      return _myList.getBubbleAt(0).getColor();
    }
  }
}

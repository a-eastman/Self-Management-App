import 'package:flutter/material.dart';
import 'themeSelection.dart';
import 'themes.dart';
import 'bubbles.dart';

// ignore: must_be_immutable
class EditWidget extends StatefulWidget {
  BubblesList myList; //List of bubbles
  BubbleTheme _theme;
  Bubble bubble;

  //ListWidget({Key key, this.myList}) : super(key : key);
  EditWidget(BubblesList myList, BubbleTheme _theme, Bubble bubble) {
    this.myList = myList;
    this._theme = _theme;
    this.bubble = bubble;
  }

  EditWidgetState createState() =>
      EditWidgetState(this.myList, this._theme, this.bubble);
}

class EditWidgetState extends State<EditWidget> {
  static final TextStyle _bubbleFont = const TextStyle(
      fontWeight: FontWeight.bold, fontSize: 15.0, fontFamily: 'SoulMarker');
  BubblesList _myList;
  BubbleTheme _theme;
  Bubble _bubble;

  EditWidgetState(BubblesList myList, BubbleTheme _theme, Bubble bubble) {
    this._myList = myList;
    this._theme = _theme;
    this._bubble = bubble;
  }

  var myController;
  var myController2;
  FocusNode fn = FocusNode();
  FocusNode fn2 = FocusNode();
  Bubble temp;

  /// Set the initial values
  void initState() {
    super.initState();
    temp = new Bubble.defaultBubble();
    temp.setRepeat(_bubble.getRepeat());
    temp.setRepeatDay("Mon", _bubble.getRepeatDay("Mon"));
    temp.setRepeatDay("Tue", _bubble.getRepeatDay("Tue"));
    temp.setRepeatDay("Wed", _bubble.getRepeatDay("Wed"));
    temp.setRepeatDay("Thu", _bubble.getRepeatDay("Thu"));
    temp.setRepeatDay("Fri", _bubble.getRepeatDay("Fri"));
    temp.setRepeatDay("Sat", _bubble.getRepeatDay("Sat"));
    temp.setRepeatDay("Sun", _bubble.getRepeatDay("Sun"));
    temp.setSize(_bubble.getSizeIndex());
    myController = TextEditingController(text: _bubble.getEntry());
    myController2 = TextEditingController(text: _bubble.getDescription());
  }

  /// Get rid of memory used when closing the screen
  void dispose() {
    fn.dispose();
    fn2.dispose();
    myController.dispose();
    myController2.dispose();
    super.dispose();
  }

  /// Change the values entered in to the bubble
  void _editBubble() {
    _bubble.setEntry(myController.text);
    _bubble.setDescription(myController2.text);
    _bubble.setSize(temp.getSizeIndex());
    _bubble.setRepeat(temp.getRepeat());
    _bubble.setRepeatDay("Mon",temp.getRepeatDay("Mon"));
    _bubble.setRepeatDay("Tue",temp.getRepeatDay("Tue"));
    _bubble.setRepeatDay("Wed",temp.getRepeatDay("Wed"));
    _bubble.setRepeatDay("Thu",temp.getRepeatDay("Thu"));
    _bubble.setRepeatDay("Fri",temp.getRepeatDay("Fri"));
    _bubble.setRepeatDay("Sat",temp.getRepeatDay("Sat"));
    _bubble.setRepeatDay("Sun",temp.getRepeatDay("Sun"));
  }

  /// Creates the repeat checkbox
  Widget _buildRepeat() {
    final bool repeat = temp.getRepeat();
    return new ListTile(
      title: new Text("Repeat"),
      trailing: new Icon(
        repeat ? Icons.check_box : Icons.check_box_outline_blank,
        color: repeat ? getBubbleColor(_myList) : Colors.black,
      ),
      onTap: () {
        setState(() {
          temp.changeRepeat();
        });
      },
    );
  }

  /// Creates a day checkbox with label
  Widget _buildDay(String day, double _screenWidth) {
    double _w = _screenWidth / 8;
    final bool repeat = temp.getRepeatDay(day);
    return new Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          new Container(
            width: _w,
            child: new FlatButton(
                child: new Icon(
                  repeat ? Icons.check_box : Icons.check_box_outline_blank,
                  color: repeat ? getBubbleColor(_myList) : Colors.black,
                ),
                onPressed: () {
                  setState(() {
                    temp.changeRepeatDay(day);
                  });
                }),
          ),
          new Text(day),
        ]);
  }

  /// Makes the row for the day of the week selection
  Widget _buildWeek(double _screenWidth) {
    if (temp.getRepeat()) {
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
                value: temp.getSizeIndex(),
                onChanged: (int newValue) {
                  setState(() {
                    temp.setSize(newValue);
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
              _buildRepeat(),
              _buildWeek(_screenWidth),
              Container(height: 20),
              RaisedButton(
                color: getBubbleColor(_myList),
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

  /// Determines what color to make the bubble
  Color getBubbleColor(BubblesList _myList) {
    if (_myList.getSize() == 0) {
      return Colors.blue;
    } else {
      return _myList.getBubbleAt(0).getColor();
    }
  }
}

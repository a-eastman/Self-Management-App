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

  Bubble newBubble = new Bubble.defaultBubble();
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

  /// Creates the checkbox for repeating
  Widget _buildRepeat() {
    final bool repeat = newBubble.getRepeat();
    return new ListTile(
      title: new Text("Repeat"),
      trailing: new Icon(
        repeat ? Icons.check_box : Icons.check_box_outline_blank,
        color: repeat ? getBubbleColor(_myList) : Colors.black,
      ),
      onTap: () {
        setState(() {
          newBubble.changeRepeat();
        });
      },
    );
  }

  /// Makes the day checkbox and label
  Widget _buildDay(String day, double _screenWidth) {
    final bool repeat = newBubble.getRepeatDay(day);
    double _w = _screenWidth / 8;
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
                    newBubble.changeRepeatDay(day);
                  });
                }),
          ),
          new Text(day),
        ]);
  }

  /// Creates the row of days of the week
  Widget _buildWeek(double _screenWidth) {
    if (newBubble.getRepeat()) {
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
                value: newBubble.getSizeIndex(),
                onChanged: (int newValue) {
                  setState(() {
                    newBubble.setSize(newValue);
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
                  _myList.addBubble(newBubble);
                  newBubble.setColor(getBubbleColor(_myList));
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
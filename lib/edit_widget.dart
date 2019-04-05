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
  var myController3;
  FocusNode fn = FocusNode();
  FocusNode fn2 = FocusNode();

  /// Set the initial values
  void initState() {
    super.initState();
    myController = TextEditingController(text: _bubble.getEntry());
    myController2 = TextEditingController(text: _bubble.getDescription());
    myController3 =
        TextEditingController(text: _bubble.getSizeIndex().toString());
  }

  /// Get rid of memory used when closing the screen
  void dispose() {
    fn.dispose();
    fn2.dispose();
    myController.dispose();
    myController2.dispose();
    myController3.dispose();
    super.dispose();
  }

  /// Change the values entered in to the bubble
  void _editBubble() {
    _bubble.setEntry(myController.text);
    _bubble.setDescription(myController2.text);
    _bubble.setSize(int.parse(myController3.text));
  }

  /// Creates the repeat chechbox
  Widget _buildRepeat() {
    final bool repeat = _bubble.getRepeat();
    return new ListTile(
      title: new Text("Repeat"),
      trailing: new Icon(
        repeat ? Icons.check_box : Icons.check_box_outline_blank,
        color: repeat ? getBubbleColor(_myList) : Colors.black,
      ),
      onTap: () {
        setState(() {
          _bubble.changeRepeat();
        });
      },
    );
  }

  /// Creates a day checkbox with label
  Widget _buildDay(String day) {
    final bool repeat = _bubble.getRepeatDay(day);
    return new Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          new Container(
            width: 55,
            //title: new Text("Repeat"),
            child: new FlatButton(
                child: new Icon(
                  repeat ? Icons.check_box : Icons.check_box_outline_blank,
                  color: repeat ? getBubbleColor(_myList) : Colors.black,
                ),
                onPressed: () {
                  setState(() {
                    _bubble.changeRepeatDay(day);
                  });
                }),
          ),
          new Text(day),
        ]);
  }

  /// Makes the row for the day of the week selection
  Widget _buildWeek() {
    if (_bubble.getRepeat()) {
      return new Row(mainAxisSize: MainAxisSize.min, children: <Widget>[
        _buildDay("Sun"),
        _buildDay("Mon"),
        _buildDay("Tue"),
        _buildDay("Wed"),
        _buildDay("Thu"),
        _buildDay("Fri"),
        _buildDay("Sat"),
      ]);
    } else {
      return new Row();
    }
  }

  @override
  Widget build(BuildContext context) {
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
              TextFormField(
                autofocus: false,
                focusNode: fn2,
                controller: myController3,
                decoration: const InputDecoration(
                  labelText: 'Priority (0 to 3)',
                ),
              ),
              _buildRepeat(),
              _buildWeek(),
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

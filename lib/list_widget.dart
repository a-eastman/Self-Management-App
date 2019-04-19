/// List view screen for bubbles
///@author Abigail Eastman
///
///
///LAST EDIT : April 19, 2019
///
import 'package:flutter/material.dart';
import 'themeSelection.dart';
import 'themes.dart';
import 'bubbles.dart';
import 'add_widget.dart';
import 'detail_widget.dart';

// ignore: must_be_immutable
class ListWidget extends StatefulWidget {
  BubblesList _myList; //List of bubbles
  BubbleTheme _theme; //Theme for the bubbles


  //ListWidget({Key key, this.myList}) : super(key : key);
  ListWidget(
      BubblesList _myList, BubbleTheme _theme) {
    this._myList = _myList; //List of bubbles
    this._theme = _theme; //Theme for bubbles
  }

  ListWidgetState createState() =>
      ListWidgetState(this._myList, this._theme);
}

class ListWidgetState extends State<ListWidget> {
  static final TextStyle _bubbleFont = const TextStyle(
      fontWeight: FontWeight.bold, fontSize: 15.0, fontFamily: 'SoulMarker');

  BubblesList _myList; //Original list with deleted bubbles
  BubblesList _curList; //List of bubbles without those marked shouldDelete
  BubbleTheme _theme; //Theme

  ListWidgetState(
      BubblesList myList, BubbleTheme _theme) {
    this._myList = myList;
    this._theme = _theme;
  }

  /// Creates the list view with dividers based on number of bubbles
  Widget _buildTasks(double _screenHeight, double _screenWidth) {
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
          return _buildRow(_curList.getBubbleAt(index), _screenHeight, _screenWidth);
        });
  }

  /// Creates the list view of the BUBL application
  @override
  Widget build(BuildContext context) {
    /// Stores the height of the screen.
    double _screenHeight =MediaQuery.of(context).size.height;
    /// Stores the width of the screen.
    double _screenWidth = MediaQuery.of(context).size.width;
    _curList = new BubblesList.newEmptyBubbleList();

    for (int i = 0; i < _myList.getSize(); i++) {
      if (!_myList.getBubbleAt(i).getShouldDelete()) {
        _curList.addBubble(_myList.getBubbleAt(i));
      }
    }
    _curList.orderBubbles(); // Puts the bubbles in order of highest priority.
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
      /// Builds the actual list of tasks.
      body: _buildTasks(_screenHeight, _screenWidth),
    );
  }

  /// Creates a list tile for the [_bubble] using [__screenHeight]
  /// and the [_screenWidth] to get the correct size.
  Widget _buildRow(Bubble _bubble, double _screenHeight, double _screenWidth) {
    final bool alreadyCompleted = !(_bubble.getPressed());
    return new ListTile(
      title: new Text(
        _bubble.getEntry(),
      ),
      trailing: new Icon(
        alreadyCompleted ? Icons.check_box : Icons.check_box_outline_blank,
        color: alreadyCompleted ? _bubble.getColor() : Colors.black,
      ),
      subtitle: new Text(_bubble.getDescription()),
      onTap: () {
        setState(() {
          _bubble.changePressed();
        });
      },
      onLongPress: () {
        Navigator.of(context).push(MaterialPageRoute(
          builder: (context) =>
              DetailWidget(this._myList, _theme, _bubble, _screenHeight, _screenWidth),
        ));
      },
    );
  }

}

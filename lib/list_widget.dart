/// List view screen for bubbles
///@author Abigail Eastman
///
///
///LAST EDIT : April 29, 2019
///
import 'package:flutter/material.dart';
import 'themes.dart';
import 'bubbles.dart';
import 'add_widget.dart';
import 'detail_widget.dart';
import 'main.dart';
import 'settingsScreen.dart';

// ignore: must_be_immutable
class ListWidget extends StatefulWidget {
  BubblesList _myList; // The list of bubbles
  BubbleTheme _theme; // Theme for the bubbles

  //ListWidget({Key key, this.myList}) : super(key : key);
  ListWidget(BubblesList _myList, BubbleTheme _theme) {
    this._myList = _myList;
    this._theme = _theme;
  }

  ListWidgetState createState() => ListWidgetState(this._myList, this._theme);
}

class ListWidgetState extends State<ListWidget> {
  BubblesList _myList; //Original list with deleted bubbles
  BubblesList _curList; //List of bubbles without those marked shouldDelete
  BubbleTheme _theme; //Theme for bubbles

  ListWidgetState(BubblesList _myList, BubbleTheme _theme) {
    this._myList = _myList;
    this._theme = _theme;
  }

  /// Creates the list view with dividers based on number of bubbles.
  ///
  /// Uses the [_screenHeight] and the [_screenWidth] to determine
  /// the correct height and width of the tiles.
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
          return _buildRow(
              _curList.getBubbleAt(index), _screenHeight, _screenWidth);
        });
  }

  /// Creates the list view of the BUBL application.
  @override
  Widget build(BuildContext context) {
    // The height of the screen.
    double _screenHeight = MediaQuery.of(context).size.height;
    // Width of the screen.
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
        leading: new IconButton(
          icon: Icon(Icons.settings),
          onPressed: () {
            setState(() {
              Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => SettingsScreen(this._myList, _theme),
              ));
            });
          },
        ),
        title: Text("BUBL List View"),
        actions: <Widget>[
          new IconButton(
            icon: Icon(Icons.add_circle_outline),
            onPressed: () {
              BubbleAppState.instance.setState(() {
                Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => AddWidget(this._myList, _theme),
                ));
              });
            },
          ),
        ],
      ),
      // Builds the actual list of tasks.
      body: _buildTasks(_screenHeight, _screenWidth),
    );
  }

  /// Creates a list tile for the [_bubble].
  ///
  /// Uses [__screenHeight] and the [_screenWidth] to get the correct size.
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
        BubbleAppState.instance.setState(() {
          _bubble.changePressed();
          _bubble.setDotAppear(!_bubble.getPressed());
        });
      },
      onLongPress: () {
        Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => DetailWidget(
              this._myList, _theme, _bubble, _screenHeight, _screenWidth),
        ));
      },
    );
  }
}

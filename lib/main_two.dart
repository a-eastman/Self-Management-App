import 'package:flutter/material.dart';
import 'iamthebubble.dart';
import 'list_widget.dart';
import 'bubbles.dart';
import 'themeSelection.dart';
import 'themes.dart';
import 'database.dart';

void main() => runApp(BubbleView());

class BubbleView extends StatelessWidget {
  @override
  Widget build(BuildContext context){
    final BubbleTheme theme =BubbleTheme();

    return StreamBuilder<ThemeData>(
      initialData: theme.initialTheme().data,
      stream: theme.themeDataStream,
      builder: (BuildContext context, AsyncSnapshot<ThemeData> snapshot) {
        return MaterialApp(
          title: 'Bubl with DB Integrated',
          theme: snapshot.data,
          home: BubbleApp(
            theme: theme,
          ),
        );
      },
    );

  }
}

class BubbleApp extends StatefulWidget{
  final BubbleTheme theme;
  final Color globalBubbleColor;
  BubblesList _bList;
  List<BubbleWidget> _widList = [];

  BubbleApp({Key key, this.theme, this.globalBubbleColor,});
  @override
  BubbleAppState createState() =>
      BubbleAppState(_bList, _widList, theme, globalBubbleColor);
}

class BubbleAppState extends State<BubbleApp>{
  BubbleTheme _theme;
  Color globalBubbleColor;
  List<BubbleWidget> _myList;
  BubblesList _bList;
  BubbleAppState(BubblesList _bList, List<BubbleWidget> _widList,
      this._theme, this.globalBubbleColor){
    this._bList =_bList;
    this._myList = _widList;
  }

  void setBubbleColor(Color newBubbleColor){
    this.globalBubbleColor = newBubbleColor;
  }

  @override
  void initState(){
    super.initState();
    _bList = new BubblesList();
    _myList = [];
  }

  ListWidget _buildListView(){
    return new ListWidget(_bList, _myList, _theme);
  }

  Widget _buildBubbleView(){
    return new BubbleWidget(_bList, _theme);
  }

  Widget build(BuildContext context){
    return PageView(
      children: <Widget>[
        _buildBubbleView(),
        _buildListView(),
        //_buildButton(),
      ],
      pageSnapping: true,
    );
  }
}

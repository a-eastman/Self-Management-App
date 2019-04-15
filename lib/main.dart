import 'package:flutter/material.dart';
import 'bubble_widget.dart';
import 'list_widget.dart';
import 'bubbles.dart';
import 'themeSelection.dart';
import 'themes.dart';
import 'database.dart';

final db = DB.instance;
void main() => runApp(BubbleView());


// ignore: must_be_immutable
class BubbleApp extends StatefulWidget{
  final BubbleTheme theme;
  final Color globalBubbleColor;
  BubblesList _bList;
  List<BubbleWidget> _widList = [];
  
  BubbleApp(this._bList, {Key key, this.theme, this.globalBubbleColor});
  @override
  BubbleAppState createState() =>
      BubbleAppState(_bList, _widList, theme, globalBubbleColor);
}

class BubbleAppState extends State<BubbleApp>{
  BubbleTheme _theme;
  Color _globalBubbleColor;
  List<BubbleWidget> _myList;
  BubblesList _bList;
  BubbleAppState(BubblesList _bList, List<BubbleWidget> _widList,
      this._theme, this._globalBubbleColor){
    this._bList =_bList;
    this._myList = _widList;
  }

  void setBubbleColor(Color newBubbleColor){
    this._globalBubbleColor = newBubbleColor;
  }

  @override
  void initState(){
    super.initState();
    //setState(() {build(context);} );
    _myList = [];
    //_bList = new BubblesList();
  }

  ListWidget _buildListView(){
    return new ListWidget(_bList, _theme);
  }

  Widget _buildBubbleView(){
    return new BubbleWidget(_bList, _theme, _globalBubbleColor);
  }

  Widget build(BuildContext context){
    return PageView(
      children: <Widget>[
        _buildBubbleView(),
        _buildListView(),
      ],
      pageSnapping: true,
    );
  }
}

class BubbleView extends StatelessWidget {
  bool newDay;
  @override
  Widget build(BuildContext context){
    final BubbleTheme theme =BubbleTheme();
    login();
    BubblesList _bList;
    if(newDay == true) {_bList = new BubblesList(); print('New Day'); }    // new day, fresh list
    else {_bList = new BubblesList.unpoppedBubbles(); print('Welcome Back');}// same day

    return StreamBuilder<ThemeData>(
      initialData: theme.initialTheme().data,
      stream: theme.themeDataStream,
      builder: (BuildContext context, AsyncSnapshot<ThemeData> snapshot) {
        return MaterialApp(
          title: 'Bubl with DB Integrated',
          theme: snapshot.data,
          home: BubbleApp(
            _bList,
            theme: theme,
          ),
        );
      },
    );
  }
  
  ///determines whether it is a new day
  void login() async
  { newDay = await db.login(); }
}
import 'package:flutter/material.dart';
import 'bubble_widget.dart';
//import 'iamthebubble.dart';
import 'list_widget.dart';
import 'bubbles.dart';
import 'themeSelection.dart';
import 'themes.dart';
import 'database.dart';
import 'settingsScreen.dart';

final db = DB.instance;
void main() => runApp(BubbleView());

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
      initialData: theme.buildBubbleTheme().data,
      stream: theme.themeDataStream,
      builder: (BuildContext context, AsyncSnapshot<ThemeData> snapshot) {
        return MaterialApp(
          title: 'Bubl with DB Integrated',
          theme: snapshot.data,
          home: BubbleApp(
            theme: theme,
            bList: _bList,
          ),
        );
      },
    );
  }
  
  ///determines whether it is a new day
  void login() async
  { newDay = await db.login(); }
}

// ignore: must_be_immutable
class BubbleApp extends StatefulWidget{
  final BubbleTheme theme;
  final Color globalBubbleColor;
  BubblesList bList;
  List<BubbleWidget> _widList = [];
  
  BubbleApp({Key key, this.theme, this.globalBubbleColor, this.bList});
  @override
  BubbleAppState createState() =>
      BubbleAppState(bList, _widList, theme, globalBubbleColor);
}

class BubbleAppState extends State<BubbleApp>{
  static BubbleAppState instance;
  BubbleTheme _theme;
  Color globalBubbleColor;
  List<BubbleWidget> _myList;
  BubblesList _bList;
  BubbleAppState(BubblesList _bList, List<BubbleWidget> _widList,
      this._theme, this.globalBubbleColor){
    this._bList =_bList;
    this._myList = _widList;
    instance = this;
  }

  void updateState()
  {
    setState(() { });
  }

  void setBubbleColor(Color newBubbleColor){
    this.globalBubbleColor = newBubbleColor;
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
    return new BubbleWidget(_bList, _theme);
  }

  Widget _buildSettingsScreen() {
    return new SettingsScreen(_bList, _theme);
  }

  Widget build(BuildContext context){
    return PageView(
      children: <Widget>[
        _buildSettingsScreen(),
        _buildBubbleView(),
        _buildListView(),
      ],
      controller: PageController(initialPage: 1),
      physics: PageScrollPhysics(),
      pageSnapping: true,
      //onPageChanged: (int page){setState(() { });},
    );
  }
}

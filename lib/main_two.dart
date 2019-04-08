import 'package:flutter/material.dart';
import 'iamthebubble.dart';
import 'list_widget.dart';
import 'bubbles.dart';
import 'themes.dart';
import 'database.dart';

final db = DB.instance;
void main() => runApp(BubbleView());

class BubbleView extends StatelessWidget {
  
  @override
  Widget build(BuildContext context){
    final BubbleTheme theme =BubbleTheme();
    final newDay = login();
    BubblesList _bList;
    if(newDay == true) _bList = new BubblesList();    // new day, fresh list
    else _bList = new BubblesList.unpoppedBubbles(); // same day

    return StreamBuilder<ThemeData>(
      initialData: theme.initialTheme().data,
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
  static Future<bool> login() async
  { return await db.login(); }
}

class BubbleApp extends StatefulWidget{
  final BubbleTheme theme;
  final Color globalBubbleColor;
  BubblesList bList;
  List<BubbleWidget> _widList;

  BubbleApp({Key key, this.theme, this.globalBubbleColor, this.bList});
  @override
  BubbleAppState createState() => 
                BubbleAppState(bList, _widList, theme, globalBubbleColor);
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
  void initState() 
  {
    super.initState();
    _myList = [];
  }

  ///List View displays all the bubbles,, not just ones unpopped
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

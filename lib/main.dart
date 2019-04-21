import 'package:flutter/material.dart';
import 'bubble_widget.dart';
import 'list_widget.dart';
import 'bubbles.dart';
import 'themes.dart';
import 'database.dart';
import 'settingsScreen.dart';
import 'stats.dart';

final db = DB.instance;
void main() => runApp(BubbleView());

class BubbleView extends StatelessWidget {
  bool newDay;
  @override
  Widget build(BuildContext context){
    final BubbleTheme theme =BubbleTheme();
    BubblesList _bList = new BubblesList.newEmptyBubbleList();
    //db.initXML().then((result){});
    return StreamBuilder<ThemeData>(
      initialData: theme.buildBubbleTheme().data,
      //initialData: theme.getSelectedTheme().data,
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
  bool populatedSettings;
  bool populatedBubbles;
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
    populatedSettings = false;
    populatedBubbles = false;
    db.getSettings().then((result){
      setState(() {
        _theme.selectedTheme.add(_theme.getSelectedTheme(result['theme']['current_theme']));
        //_theme.selectedTheme.add(_theme.getSelectedFont(context, result['font']['font_size']));
        populatedSettings = true; 
      });
    });
    _bList.populateBubblesForWidget().then((result){
      setState(() {
        populatedBubbles = true;
      });
    });
    _myList = [];
  }

  Widget build(BuildContext context){
    if(populatedSettings == false){
      return Scaffold(
        appBar: AppBar(
          title: Text('Loading in'),
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              CircularProgressIndicator(),
            ],
          ),
        ),
      );
    }
    else{
      if(populatedBubbles == false){
        return Scaffold(
          appBar: AppBar(
            title: Text('Loading in'),
          ),
          body: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                CircularProgressIndicator(),
              ],
            ),
          ),
        );
      }
      else{
        return PageView(
          children: <Widget>[
            //_buildSettingsScreen(),
            _buildBubbleView(),
            _buildListView(),
            _buildStatsScreen(),
          ],
          controller: PageController(initialPage: 1),
          pageSnapping: true,
        );
      }
    }
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

  Widget _buildStatsScreen(){
    return new StatsWidget(_theme);
  }
}
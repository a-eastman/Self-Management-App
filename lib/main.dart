import 'package:flutter/material.dart';
import 'iamthebubble.dart';
import 'list_widget.dart';
import 'bubbles.dart';
import 'themeSelection.dart';
import 'themes.dart';

void main() => runApp(BubbleView());


// ignore: must_be_immutable
class BubbleApp extends StatefulWidget{
  final BubbleTheme theme;
  final Color globalBubbleColor;
  BubblesList _bList = new BubblesList();
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
  Bubble b0;
  Bubble b1;
  Bubble b2;

  void setBubbleColor(Color newBubbleColor){
    this.globalBubbleColor = newBubbleColor;
  }

  @override
  void initState(){
    super.initState();
    //ThemeBloc themeBloc = new ThemeBloc();
    _myList = [];
    _bList = new BubblesList();
    // b0 = new Bubble("Caeleb", "Nasoff", Colors.blue, 2,
    //                  true, 50.0, 50.0, 0.8);
    // b1 = new Bubble.defaultBubble();
    // b2 = new Bubble("DOUG DIMMADOME",
    //     "OWNER OF THE DIMSDALE DIMMADOME",
    //     Colors.red,
    //     3,
    //     true,
    //     0.2,
    //     0.2,
    //     1.0
    // );
    // _myList.add(BubbleWidget(bubble: b1));
    // _bList.addBubble(b0);
    // _myList.add(BubbleWidget(_bList, _theme));
    // _myList.removeAt(0);
    // _bList.removeBubbleAt(0);
    // _myList.add(BubbleWidget(bubble: b2));
    //_bList.addBubble(b1);
    // _bList.addBubble(b0);
    //_bList.addBubble(b2); //Cleared screen initially
  }

  ListWidget _buildListView(){
    return new ListWidget(_bList, _theme);
  }
//a
  Widget _buildBubbleView(){
    return new BubbleWidget(_bList, _theme);
  }

  Widget build(BuildContext context){
    return PageView(
      children: <Widget>[
        _buildBubbleView(),
        _buildListView(),
        _buildListView(),
      ],
      controller: PageController(initialPage: 1),
      pageSnapping: true,
    );
  }
}

class BubbleView extends StatelessWidget {

  @override
  Widget build(BuildContext context){
    final BubbleTheme theme =BubbleTheme();
    return StreamBuilder<ThemeData>(
      initialData: theme.initialTheme().data,
      stream: theme.themeDataStream,
      builder: (BuildContext context, AsyncSnapshot<ThemeData> snapshot) {
        return MaterialApp(
          title: 'App3',
          theme: snapshot.data,
          home: BubbleApp(
            theme: theme,
          ),
        );
      },
    );

  }
}
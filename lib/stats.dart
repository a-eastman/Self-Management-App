///Displays the overall stats for the users
///@author Martin Price
///@date 4/20/2019 - nice
import 'package:charts_flutter/flutter.dart' as charts;
import 'package:flutter/material.dart';
import 'bubbles.dart';
import 'database.dart';
import 'themes.dart';

final db = DB.instance;
class StatsWidget extends StatefulWidget{
  BubbleTheme _theme;
  
  StatsWidget(BubbleTheme _theme){
    this._theme = _theme;
  }
  StatsWidgetState createState() => StatsWidgetState(this._theme);
}

///Widget Class that build the Stats page
class StatsWidgetState extends State<StatsWidget>{
  static final TextStyle _bubbleFont = const TextStyle(
    fontWeight: FontWeight.bold, fontSize: 15.0, fontFamily: 'SoulMarker');
  BubbleTheme _theme;
  BubblesList _bList;
  Bubble preview = new Bubble.defaultBubble();
  bool populated;
  int bubbleMostPopped;
  int totalPops;

  StatsWidgetState(BubbleTheme _theme){
    this._theme = _theme;
    bubbleMostPopped = 0;
    totalPops = 0;
    populated = false;
    gatherInfo().then((result){
      setState(() {
        populated = true;
      });
    });
  }

  ///Populates the bubbles list
  ///@version 1 : hard code to all the bubbles
  ///@return true : populated
  Future<bool> gatherInfo() async{
    final bub = await db.queryBubble();
    if(bub.isEmpty)
      return true;
    
    //most popped bubble
    int max = bub[0]['times_popped'];
    totalPops = 0;
    bubbleMostPopped = bub[0]['bID'];
    for(var y in bub){
      totalPops += y['times_popped'];
      if(y['times_popped'] > max){
        max = y['times_popped'];
        bubbleMostPopped = y['bID'];
      }
    }
    final y = await db.queryFullBubbleByID(bubbleMostPopped);
    preview = new Bubble.BubbleFromDatabase(y['bID'],y['title'],y['description'],
          new Color.fromRGBO(y['color_red'],y['color_green'], y['color_blue'],y['opacity']),
          y['size'], y['posX'], y['posX'], y['opacity'], y['times_popped'], y['frequency'],
          y['repeat'], 
          y['days_to_repeat']);
    return true;
  }

  @override
  ///Creates the stats view for BUBL
  ///Similar layout to the listtview
  Widget build(BuildContext context){
    double _screenHeight = MediaQuery.of(context).size.height;
    double _screenWeight = MediaQuery.of(context).size.width;
    if(!populated){
      return new Center(child: CircularProgressIndicator());
    }
    else{
      return new Scaffold(
        appBar: new AppBar(
          title: Text('Stats View'),
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text('Most popped bubble'),
              Text('\n'),
              makePreviewBubble(_screenHeight),
              Text('\n'),
              Text('Total number of pops: $totalPops'),
            ],
          ),
        ),
      );
    }
  }

  //Makes a preview bubble widget
  Widget makePreviewBubble(double _screenHeight){
    return new Container(
      width: preview.getSize() * _screenHeight,
      height: preview.getSize() * _screenHeight,
      child: new Container(
        decoration: new BoxDecoration(
          color: preview.getColor(),
          shape: BoxShape.circle,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(preview.getEntry()),
            Text(preview.getDescription()),
          ]
        )
      )
    );
  }

  ///
  ///Creates the graph to be displayed
  ///@return gragh widget
  Widget buildGraph(double _screenHeight, double _screenwdith){

  }
}
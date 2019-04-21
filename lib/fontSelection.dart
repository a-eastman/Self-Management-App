///Handles the font selection
///@author Matt Rubin
///Created using [themeSelection.dart] as a base
///@date April 19, 2019
import 'package:flutter/material.dart';
import 'themes.dart';
import 'bubbles.dart';
import 'database.dart';

class FontSelectorPage extends StatefulWidget {
  final BubbleTheme theme;
  final BubblesList bublist;
  final Color bubbleColor;

  FontSelectorPage({Key key, this.theme, this.bublist,
    this.bubbleColor}) : super(key: key);

  FontSelectorPageState createState() =>
      FontSelectorPageState(this.theme, this.bublist, this.bubbleColor);
}

class FontSelectorPageState extends State<FontSelectorPage>{
  BubbleTheme theme;
  BubblesList bublist;
  Color previewColor;
  Color bubbleColor;
  final db = DB.instance;
  
  Bubble preview = new Bubble.defaultBubble();

  FontSelectorPageState(this.theme, this.bublist, this.bubbleColor);

  //Bubble preview = new Bubble.defaultBubble();

  Widget _previewBubble(double _screenHeight){
    if(bublist.getSize() == 0){
      previewColor = Colors.blue;
    }else{
      previewColor = bublist.getBubbleAt(0).getColor();
    }
    preview.setColor(previewColor);
    preview.setSize(1);
    preview.setEntry("Preview Bubble");
    return new Container(
      width: preview.getSize() * _screenHeight,
      height: preview.getSize() * _screenHeight,
      child: new Container(
        decoration: new BoxDecoration(
          color: preview.getColor(),
          shape:BoxShape.circle,
        ),
        child: new Center(
          child: Text(preview.getEntry(),),
        ),
      ),
    );
  }

  DemoTheme _buildSmallTheme() {
    db.enterFontSize(10.0);
    print('Font size is now ${db.getStoredFontSize()}');
    return DemoTheme(
      'Small',
      ThemeData(
        brightness: Theme.of(context).brightness,
        buttonColor: Theme.of(context).buttonColor,
        accentColor: Theme.of(context).accentColor,
        primaryColor: Theme.of(context).primaryColor,
        textTheme: TextTheme(
          body1: TextStyle(fontSize: 10.0),
          button: TextStyle(fontSize: 10.0),
        ),
      )
    );
  }

  DemoTheme _buildMediumTheme() {
    db.enterFontSize(14.0);
    print('Font size is now ${db.getStoredFontSize()}');
    return DemoTheme(
        'Medium',
        ThemeData(
          brightness: Theme.of(context).brightness,
          buttonColor: Theme.of(context).buttonColor,
          accentColor: Theme.of(context).accentColor,
          primaryColor: Theme.of(context).primaryColor,
          textTheme: TextTheme(
            body1: TextStyle(fontSize: 14.0),
            button: TextStyle(fontSize: 14.0),
          ),
        )
    );
  }

  DemoTheme _buildLargeTheme() {
    db.enterFontSize(18.0);
    print('Font size is now ${db.getStoredFontSize()}');
    return DemoTheme(
        'Large',
        ThemeData(
          brightness: Theme.of(context).brightness,
          buttonColor: Theme.of(context).buttonColor,
          accentColor: Theme.of(context).accentColor,
          primaryColor: Theme.of(context).primaryColor,
          textTheme: TextTheme(
            body1: TextStyle(fontSize: 18.0),
            button: TextStyle(fontSize: 18.0),
          ),
        )
    );
  }

  Color getBubbleColor(){
    return bubbleColor;
  }

  ///Returns the font size for initialization
  DemoTheme getFontTheme(double fontSize){
    switch(fontSize.truncate()){
      case 10 : return _buildSmallTheme();
      case 14 : return _buildMediumTheme();
      case 18 : return _buildLargeTheme();
    }
  }

  @override
  Widget build(BuildContext context){
    double _screenHeight =MediaQuery.of(context).size.height;
    double _screenWidth = MediaQuery.of(context).size.width;
    return new Scaffold(
      appBar: new AppBar(
        title: const Text("Change Font"),
      ),
      body: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            new Center(child: _previewBubble(_screenHeight),),
            RaisedButton(
                onPressed:() => theme.selectedTheme.add(_buildSmallTheme()),
                child: Text("Small")
            ),
            RaisedButton(
              onPressed: () => theme.selectedTheme.add(_buildMediumTheme()),
              child: Text("Medium"),
            ),
            RaisedButton(
              onPressed: () => theme.selectedTheme.add(_buildLargeTheme()),
              child: Text("Large"),
            ),
          ]
      ),
    );
  }

}
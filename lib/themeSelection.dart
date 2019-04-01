import 'package:flutter/material.dart';
import 'themes.dart';
import 'bubbles.dart';

class ThemeSelectorPage extends StatefulWidget {
  final BubbleTheme theme;
  final BubblesList bublist;
  final Color bubbleColor;

  ThemeSelectorPage({Key key, this.theme, this.bublist, this.bubbleColor}) : super(key: key);

  ThemeSelectorPageState createState() => ThemeSelectorPageState(this.theme, this.bublist, this.bubbleColor);
}

class ThemeSelectorPageState extends State<ThemeSelectorPage>{
  BubbleTheme theme;
  BubblesList bublist;
  Color previewColor;
  Color bubbleColor;
  Bubble preview;

  ThemeSelectorPageState(this.theme, this.bublist, this.bubbleColor);

  //Bubble preview = new Bubble.defaultBubble();
  

  Widget _previewBubble(){
    preview = new Bubble.defaultBubble();
    if(bublist.getSize() == 0){
      previewColor = Colors.blue;
    }else{
      previewColor = bublist.getBubbleAt(0).getColor();
    }
    preview.setColor(previewColor);
    preview.setSize(150);
    preview.setEntry("Preview Bubble");
    return new Container(
      width: preview.getSize(),
      height: preview.getSize(),
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

  DemoTheme _buildBubbleTheme() {
    bubbleColor = Colors.blue;
    previewColor = bubbleColor;
    for(int i = 0; i < bublist.getSize(); i++){
      bublist.getBubbleAt(i).setColor(bubbleColor);
    }
    return DemoTheme(
      'Bubble',
      ThemeData(
        brightness: Brightness.light,
        buttonColor: bubbleColor,
        accentColor: bubbleColor,
        primaryColor: bubbleColor,
      ));
  }

  DemoTheme _buildSunsetTheme() {
    bubbleColor = Colors.deepOrange[200];
    previewColor = bubbleColor;
    for(int i = 0; i < bublist.getSize(); i++){
      bublist.getBubbleAt(i).setColor(bubbleColor);
    }
    return DemoTheme(
      'Sunset',
      ThemeData(
        brightness: Brightness.dark,
        accentColor: bubbleColor,
        buttonColor: bubbleColor,
        primaryColor: bubbleColor,
      ));
  }

  DemoTheme _buildDuskTheme() {
    bubbleColor = Colors.purple[200];
    previewColor =bubbleColor;
    for(int i = 0; i < bublist.getSize(); i++){
      bublist.getBubbleAt(i).setColor(bubbleColor);
    }
    return DemoTheme(
      'Dusk',
      ThemeData(
        brightness: Brightness.dark,
        buttonColor: bubbleColor,
        accentColor: bubbleColor,
        primaryColor: bubbleColor,
      ));
  }

  DemoTheme _buildSunnyTheme(){
    this.bubbleColor = Colors.yellow[200];
    previewColor = bubbleColor;
    for(int i = 0; i < bublist.getSize(); i++){
      bublist.getBubbleAt(i).setColor(bubbleColor);
    }
    return DemoTheme(
      'Sunny',
      ThemeData(
      backgroundColor: Colors.blue[100],
      buttonColor: bubbleColor,
      canvasColor: Colors.blue[100],
      brightness: Brightness.light,
      accentColor: bubbleColor,
      primaryColor: bubbleColor)
    );
  }

  DemoTheme _buildOceanTheme(){
    bubbleColor = Colors.blue[100];
    previewColor = bubbleColor;
    for(int i = 0; i < bublist.getSize(); i++){
      bublist.getBubbleAt(i).setColor(bubbleColor);
    }
    return DemoTheme(
      'Ocean',
      ThemeData(
      backgroundColor: bubbleColor,
      buttonColor: bubbleColor,
      canvasColor: Colors.lightBlue[300],
      brightness: Brightness.light,
      accentColor: bubbleColor,
      primaryColor: bubbleColor)
    );
  }

  Color getBubbleColor(){
    return bubbleColor;
  }

  @override
  Widget build(BuildContext context){
    //Widget preview = _previewBubble();
      //String themeValue = 'Sunny Day';
            return new Scaffold(
              appBar: new AppBar(
                title: const Text("Change Theme"),
              ),
              body: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  new Center(child: _previewBubble(),),
                  
                  RaisedButton(
                    onPressed:() => theme.selectedTheme.add(_buildBubbleTheme()),
                    child: Text("Bubble")  
                  ),

                  RaisedButton(
                    onPressed: () => theme.selectedTheme.add(_buildSunsetTheme()),
                    child: Text("Sunset"),
                  ),

                  RaisedButton(
                    onPressed: () => theme.selectedTheme.add(_buildSunnyTheme()),
                    child: Text("Sunny"),
                  ),

                  RaisedButton(
                    onPressed: () => theme.selectedTheme.add(_buildDuskTheme()),
                    child: Text("Dusk"),
                  ),

                  RaisedButton(
                    onPressed: () => theme.selectedTheme.add(_buildOceanTheme()),
                    child: Text("Ocean"),
                  ),
                ]

                ),
              );
          }
  
}


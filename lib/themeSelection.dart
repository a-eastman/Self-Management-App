import 'package:flutter/material.dart';
import 'themes.dart';
import 'bubbles.dart';

class ThemeSelectorPage extends StatefulWidget {
  final BubbleTheme theme;
  final BubblesList bublist;

  ThemeSelectorPage({Key key, this.theme, this.bublist}) : super(key: key);

  ThemeSelectorPageState createState() => ThemeSelectorPageState(this.theme, this.bublist);
}

class ThemeSelectorPageState extends State<ThemeSelectorPage>{
  BubbleTheme theme;
  BubblesList bublist;

  ThemeSelectorPageState(this.theme, this.bublist);
  
  Bubble preview = new Bubble.defaultBubble();

  Widget _previewBubble(){
    
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
    preview.setColor(Colors.blue);
    for(int i = 0; i < bublist.getSize(); i++){
      bublist.getBubbleAt(i).setColor(Colors.blue);
    }
    return DemoTheme(
      'Bubble',
      ThemeData(
        brightness: Brightness.light,
        buttonColor: Colors.blue,
        accentColor: Colors.blue,
        primaryColor: Colors.blue,
      ));
  }

  DemoTheme _buildSunsetTheme() {
    preview.setColor(Colors.deepOrange[300]);
    for(int i = 0; i < bublist.getSize(); i++){
      bublist.getBubbleAt(i).setColor(Colors.deepOrange[300]);
    }
    return DemoTheme(
      'Sunset',
      ThemeData(
        brightness: Brightness.dark,
        accentColor: Colors.deepOrange[300],
        buttonColor: Colors.deepOrange[300],
        primaryColor: Colors.deepOrange[300],
      ));
  }

  DemoTheme _buildDarkTheme() {
    preview.setColor(Colors.purple[200]);
    for(int i = 0; i < bublist.getSize(); i++){
      bublist.getBubbleAt(i).setColor(Colors.purple[200]);
    }
    return DemoTheme(
      'Dark',
      ThemeData(
        brightness: Brightness.dark,
        buttonColor: Colors.purple[200],
        accentColor: Colors.purple[200],
        primaryColor: Colors.purple[200],
      ));
  }

  DemoTheme _buildSunnyTheme(){
    preview.setColor(Colors.yellow[200]);
    _previewBubble();
    for(int i = 0; i < bublist.getSize(); i++){
      bublist.getBubbleAt(i).setColor(Colors.yellow[200]);
    }
    return DemoTheme(
      'Sunny',
      ThemeData(
      backgroundColor: Colors.blue[100],
      buttonColor: Colors.yellow[200],
      canvasColor: Colors.blue[100],
      brightness: Brightness.light,
      accentColor: Colors.yellow[200],
      primaryColor: Colors.yellow[200])
    );
  }

  DemoTheme _buildOceanTheme(){
    preview.setColor(Colors.blue[100]);
    _previewBubble();
    for(int i = 0; i < bublist.getSize(); i++){
      bublist.getBubbleAt(i).setColor(Colors.blue[100]);
    }
    return DemoTheme(
      'Ocean',
      ThemeData(
      backgroundColor: Colors.blue[100],
      buttonColor: Colors.blue[100],
      canvasColor: Colors.lightBlue[300],
      brightness: Brightness.light,
      accentColor: Colors.blue[100],
      primaryColor: Colors.blue[100])
    );
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
                    onPressed: () => theme.selectedTheme.add(_buildDarkTheme()),
                    child: Text("Dark"),
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
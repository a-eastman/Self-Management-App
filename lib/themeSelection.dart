///Theme Selection Page for altering themes in app and saving those selections in the DB
///@author Chris Malitsky
///@date March 2019
///
///@author FOR EDIT ONLY Martin Price
///editted to integrate with the Database to store and retrive settings
///@date April 17, 2019
///RUN TIME
///
///Inspired by: https://medium.com/flutter-community/flutter-how-to-change-the-apps-theme-at-runtime-using-the-bloc-pattern-30a3e3ce5b6a
import 'package:flutter/material.dart';
import 'themes.dart';
import 'bubbles.dart';
import 'database.dart';

// Class ThemeSelectorPage requires extension of StatefulWidget to allow for SetState changes
// to [theme]. Takes as parameters [theme], [bublist], and [bubbleColor]. DemoThemes contain
// the data used by the stream to change the appearance of the app
class ThemeSelectorPage extends StatefulWidget {
  final BubbleTheme theme;
  final BubblesList bublist;
  final Color bubbleColor;

  ThemeSelectorPage({Key key, this.theme, this.bublist,
    this.bubbleColor}) : super(key: key);

  ThemeSelectorPageState createState() =>
      ThemeSelectorPageState(this.theme, this.bublist, this.bubbleColor);
}

// Class ThemeSelectorPageState extends ThemeSelectorPage and defines the characteristics of 
// the page and generates the buttons which define theme state changes based on DemoThemes
class ThemeSelectorPageState extends State<ThemeSelectorPage>{
  BubbleTheme theme;
  BubblesList bublist;
  Color previewColor;
  Color bubbleColor;
  final db = DB.instance;
  Bubble preview = new Bubble.defaultBubble();
  
  double get size => db.getStoredFontSize();
  
  ThemeSelectorPageState(this.theme, this.bublist, this.bubbleColor);

  //Bubble Theme Characteristics
  DemoTheme _buildBubbleTheme() {
    db.enterThemeID(1);
    print('Theme is now ${db.getStoredThemeID()}');
    bubbleColor = Colors.blue[300];
    return DemoTheme(
        'Bubble',
        ThemeData(
         backgroundColor: bubbleColor,
            buttonColor: bubbleColor,
            canvasColor: Colors.lightBlue[50],
            brightness: Brightness.light,
            accentColor: bubbleColor,
            primaryColor: bubbleColor,
            textTheme: TextTheme(
            body1: TextStyle(fontSize: size),
            button: TextStyle(fontSize: size),
            subhead: TextStyle(fontSize: size),
          ),
        ));
  }

  //Sunset Theme Characteristics
  DemoTheme _buildSunsetTheme() {
    db.enterThemeID(2);
    print('Theme is now ${db.getStoredThemeID()}');
    bubbleColor = Colors.deepOrange[200];
    return DemoTheme(
        'Sunset',
        ThemeData(
          brightness: Brightness.dark,
          accentColor: bubbleColor,
          buttonColor: bubbleColor,
          primaryColor: bubbleColor,
          canvasColor: Colors.grey[800],
          textTheme: TextTheme(
            body1: TextStyle(fontSize: size),
            button: TextStyle(fontSize: size),
            subhead: TextStyle(fontSize: size),
          ),
        ));
  }

  //Dusk Theme Characteristics
  DemoTheme _buildDuskTheme() {
    db.enterThemeID(3);
    print('Theme is now ${db.getStoredThemeID()}');
    bubbleColor = Colors.purple[100];
    return DemoTheme(
        'Dusk',
        ThemeData(
          brightness: Brightness.dark,
          canvasColor: Colors.grey[800],
          buttonColor: bubbleColor,
          accentColor: bubbleColor,
          primaryColor: bubbleColor,
          textTheme: TextTheme(
            body1: TextStyle(fontSize: size),
            button: TextStyle(fontSize: size),
            subhead: TextStyle(fontSize: size),
          ),
        ));
  }

  //Sunny Theme Characteristics
  DemoTheme _buildSunnyTheme(){
    db.enterThemeID(4);
    print('Theme is now ${db.getStoredThemeID()}');
    bubbleColor = Colors.yellow[200];
    return DemoTheme(
        'Sunny',
        ThemeData(
            backgroundColor: Colors.blue[100],
            buttonColor: bubbleColor,
            canvasColor: Colors.blue[100],
            brightness: Brightness.light,
            accentColor: bubbleColor,
            primaryColor: bubbleColor,
            textTheme: TextTheme(
            body1: TextStyle(fontSize: size),
            button: TextStyle(fontSize: size),
            subhead: TextStyle(fontSize: size),
          ),
        )
    );
  }

  //Ocean Theme Characteristics
  DemoTheme _buildOceanTheme(){
    db.enterThemeID(5);
    print('Theme is now ${db.getStoredThemeID()}');
    bubbleColor = Colors.teal[300];
    return DemoTheme(
        'Ocean',
        ThemeData(
            canvasColor: Colors.teal[100],
            brightness: Brightness.light,
            buttonColor: bubbleColor,
            accentColor: bubbleColor,
            primaryColor: bubbleColor,
            textTheme: TextTheme(
            body1: TextStyle(fontSize: size),
            button: TextStyle(fontSize: size),
            subhead: TextStyle(fontSize: size),
          ),
        )
    );
  }

  //Build the page - takes parameter [context]
  @override
  Widget build(BuildContext context){
    return new Scaffold(
      appBar: new AppBar(
        title: const Text("Change Theme"),
      ),
      body: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            new Center(),
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

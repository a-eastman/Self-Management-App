///Stores various themes for initialization purposes only - used to create initial themes
///See themeSelection for in app theme changes - this class is used only to create the initial theme
///so, when the theme is changed in app, the DB saves it and then, upon reopening the app, selects the
///corresponding theme from the themes below for initialization.
///This Class also contains the initialization for the stream and sink (stream handles data sent
/// to it by the sink)
/// COMPILE TIME
///@author Chris Malitsky
///@date March 2019
///
///Inspired by: https://medium.com/flutter-community/flutter-how-to-change-the-apps-theme-at-runtime-using-the-bloc-pattern-30a3e3ce5b6a
import 'package:flutter/material.dart';
import 'package:rxdart/rxdart.dart';
import 'dart:async';
import 'database.dart';

// Class DemoTheme used to create actual passable [theme] parameters 
class DemoTheme {
  final String name;
  final ThemeData data;
  const DemoTheme(this.name, this.data,);
}

class BubbleTheme {
  final Stream<ThemeData> themeDataStream; //Accepts data sent by sink
  final Sink<DemoTheme> selectedTheme; // Sends data to the stream
  final db;
 //final textSize; //TESTING
  double get tempsize => db.getStoredFontSize();

  factory BubbleTheme() {
    final selectedTheme = PublishSubject<DemoTheme>();
    //This is where the theme data actually gets passed to the stream
    final themeDataStream = selectedTheme
        .distinct()
        .map((theme) => theme.data);
    final db = DB.instance;
    //final double textSize = 1.0; //TESTING
    //Bubble theme returned with new theme data
    return BubbleTheme._(themeDataStream, selectedTheme, db,);
  }

  const BubbleTheme._(this.themeDataStream, this.selectedTheme, this.db,);
  //double get tempsize => db.getStoredFontSize();

  // TESTING
  // void getTextSize(double newSize){
  //   // if(tempsize != null){
  //   //   newSize = tempsize;
  //   // }
  //   newSize = textSize;
  // }

  DemoTheme initialTheme() {
    //double newSize;
    //getTextSize(newSize);
    return DemoTheme(
      'initial',
      ThemeData(
        backgroundColor: Colors.blue[300],
        buttonColor: Colors.blue[300],
        canvasColor: Colors.lightBlue[50],
        brightness: Brightness.light,
        accentColor: Colors.blue[300],
        primaryColor: Colors.blue[300],
        textTheme: TextTheme(
            body1: TextStyle(fontSize: tempsize),
            button: TextStyle(fontSize: tempsize),
            subhead: TextStyle(fontSize: tempsize),
          ),
      )
    );
  }

  DemoTheme buildBubbleTheme() {
    //double newSize;
    //getTextSize(newSize);
    return DemoTheme(
      'Bubble',
      ThemeData(
        backgroundColor: Colors.blue[300],
        buttonColor: Colors.blue[300],
        canvasColor: Colors.lightBlue[50],
        brightness: Brightness.light,
        accentColor: Colors.blue[300],
        primaryColor: Colors.blue[300],
        textTheme: TextTheme(
            body1: TextStyle(fontSize: tempsize),
            button: TextStyle(fontSize: tempsize),
            subhead: TextStyle(fontSize: tempsize),
          ),
      ));
  }

  DemoTheme buildSunsetTheme() {
    //double newSize;
    //getTextSize(newSize);
    return DemoTheme(
      'Sunset',
      ThemeData(
        brightness: Brightness.dark,
        accentColor: Colors.deepOrange[200],
        buttonColor: Colors.deepOrange[200],
        primaryColor: Colors.deepOrange[200],
        canvasColor: Colors.grey[800],
        textTheme: TextTheme(
            body1: TextStyle(fontSize: tempsize),
            button: TextStyle(fontSize: tempsize),
            subhead: TextStyle(fontSize: tempsize),
          ),
      ));
  }

  DemoTheme buildDuskTheme() {
    return DemoTheme(
      'Dusk',
      ThemeData(
        brightness: Brightness.dark,
        buttonColor: Colors.purple[100],
        accentColor: Colors.purple[100],
        primaryColor: Colors.purple[100],
        canvasColor: Colors.grey[800],
      ));
  }

  DemoTheme buildSunnyTheme(){
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

  DemoTheme buildOceanTheme(){
    return DemoTheme(
      'Ocean',
      ThemeData(
        canvasColor: Colors.teal[100],
        brightness: Brightness.light,
        buttonColor: Colors.teal[300],
        accentColor: Colors.teal[300],
        primaryColor: Colors.teal[300])
    );
  }

  ///
  ///Brought in methods from FontSelection to change the font
  /// Without changing the theme
  /// 

  DemoTheme _buildSmallTheme(BuildContext context) {
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

  DemoTheme _buildMediumTheme(BuildContext context) {
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

  DemoTheme _buildLargeTheme(BuildContext context) {
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

  ///@returns the specific theme based on param
  DemoTheme getSelectedTheme(int currTheme){
    switch(currTheme){
      case 1: return initialTheme(); break;
      case 2: return buildSunsetTheme(); break;
      case 3: return buildDuskTheme(); break;
      case 4: return buildSunnyTheme(); break;
      case 5: return buildOceanTheme(); break;
    }
  }
  
  ///Returns the font size for initialization
  DemoTheme getSelectedFont(BuildContext context, double fontSize){
    switch(fontSize.truncate()){
      case 10 : return _buildSmallTheme(context); break;
      case 14 : return _buildMediumTheme(context); break;
      case 18 : return _buildLargeTheme(context); break;
    }
  }
}

import 'package:flutter/material.dart';
import 'package:rxdart/rxdart.dart';
import 'dart:async';
import 'database.dart';

class DemoTheme {
  final String name;
  final ThemeData data;
  const DemoTheme(this.name, this.data,);
}

class BubbleTheme {
  final Stream<ThemeData> themeDataStream;
  final Sink<DemoTheme> selectedTheme;

  factory BubbleTheme() {
    final selectedTheme = PublishSubject<DemoTheme>();
    final themeDataStream = selectedTheme
        .distinct()
        .map((theme) => theme.data);
    return BubbleTheme._(themeDataStream, selectedTheme,);
  }

  const BubbleTheme._(this.themeDataStream, this.selectedTheme,);

  DemoTheme initialTheme() {
    return DemoTheme(
        'initial',
        ThemeData(
          brightness: Brightness.light,
          accentColor: Colors.blue,
          primaryColor: Colors.blue,
        )
    );
  }

  DemoTheme buildOceanTheme() {
    return DemoTheme(
      'Bubble',
      ThemeData(
        canvasColor: Colors.teal[100],
        brightness: Brightness.light,
        buttonColor: Colors.teal[300],
        accentColor: Colors.teal[300],
        primaryColor: Colors.teal[300],
      ));
  }

  DemoTheme buildSunsetTheme() {
    return DemoTheme(
      'Sunset',
      ThemeData(
        brightness: Brightness.dark,
        accentColor: Colors.deepOrange[200],
        buttonColor: Colors.deepOrange[200],
        primaryColor: Colors.deepOrange[200],
      ));
  }

  DemoTheme buildDuskTheme() {
    return DemoTheme(
      'Dusk',
      ThemeData(
        brightness: Brightness.dark,
        buttonColor: Colors.purple[200],
        accentColor: Colors.purple[200],
        primaryColor: Colors.purple[200],
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

  DemoTheme buildBubbleTheme(){
    return DemoTheme(
      'Ocean',
      ThemeData(
      backgroundColor: Colors.blue[300],
      buttonColor: Colors.blue[300],
      canvasColor: Colors.lightBlue[50],
      brightness: Brightness.light,
      accentColor: Colors.blue[300],
      primaryColor: Colors.blue[300])
    );
  }

  DemoTheme getSelectedTheme(){
    DB.instance.initXML();
    int currTheme = DB.instance.getStoredThemeID();
    switch(currTheme){
      case 1: return initialTheme(); break;
      case 2: return buildSunsetTheme(); break;
      case 3: return buildDuskTheme(); break;
      case 4: return buildSunnyTheme(); break;
      case 5: return buildOceanTheme(); break;
    }
  }
}


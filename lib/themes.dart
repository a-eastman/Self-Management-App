import 'package:flutter/material.dart';
import 'package:rxdart/rxdart.dart';
import 'dart:async';

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

  DemoTheme buildBubbleTheme() {
    return DemoTheme(
      'Bubble',
      ThemeData(
        brightness: Brightness.light,
        buttonColor: Colors.blue,
        accentColor: Colors.blue,
        primaryColor: Colors.blue,
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

  DemoTheme buildOceanTheme(){
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
}


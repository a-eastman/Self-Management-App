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
}

///Launches the settings screen
///@author Matt Rubin
///created the screen and added functionality to access theme and font selection
///@date April 16, 2019
///
///@author FOR EDIT ONLY Martin Price
///editted to integrate with the Database to store and retrive settings
///@date April 17, 2019

import 'package:flutter/material.dart';
import 'bubbles.dart';
import 'themeSelection.dart';
import 'themes.dart';
import 'fontSelection.dart';

// ignore: must_be_immutable
class SettingsScreen extends StatefulWidget {
  BubblesList _bubList;
  BubbleTheme _theme;

  SettingsScreen(BubblesList list, BubbleTheme theme) {
    this._bubList = list; //needs the bubble list for the theme selection
    this._theme = theme;
  }

  SettingsScreenState createState() => SettingsScreenState(_bubList, _theme);
}

class SettingsScreenState extends State<SettingsScreen> {
  BubblesList _bubList;
  BubbleTheme _theme;

  SettingsScreenState(BubblesList list, BubbleTheme theme) {
    this._bubList = list;
    this._theme = theme;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Settings'),
      ),
      body: _buildSelection(),
    );
  }

  Widget _buildSelection(){
    return ListView(children: <Widget>[
      _buildThemeButton(),
      _buildFontSelection(),
      _buildTutorialButton(),
    ],);
  }

  Widget _buildRow(String s) {
    return ListTile(
      title: Text(
        s,
      ),
    );
  }

  Widget _buildThemeButton() {
    return ListTile(
        title: Text(
          'Themes',
        ),
        onTap: () {
          Navigator.of(context).push(MaterialPageRoute(
            builder: (context) =>
                ThemeSelectorPage(theme: _theme, bublist: _bubList),
          ));
        }
    );
  }

  Widget _buildFontSelection() {
    //TODO: make font selection update font size on settings screen
    return ListTile(
        title: Text(
          'Font Size',
        ),
        onTap: () {
          Navigator.of(context).push(MaterialPageRoute(
            builder: (context) =>
                FontSelectorPage(theme: _theme, bublist: _bubList),
          ));
        }
    );
  }

  Widget _buildTutorialButton() {
    //TODO: make interactive and work once tutorial is in place
    return ListTile(
        title: Text(
          'Replay Tutorial',
        )
    );
  }
}
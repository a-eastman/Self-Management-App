import 'package:flutter/material.dart';
import 'bubbles.dart';
import 'themeSelection.dart';
import 'themes.dart';

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
  final Map<String, double> _sizeMap = { //maps strings to font sizes
    'small' : 10.0,
    'medium' : 14.0,
    'large' : 18.0,
  };
  String _sizeString = 'medium';

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
        style: new TextStyle(fontSize: getFontSize()),
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
        style: new TextStyle(fontSize: getFontSize()),
      ),
      onTap: () {
        switch (_sizeString) {//test toggle
          case 'small':
            _sizeString = 'medium';
            break;
          case 'medium' :
            _sizeString = 'large';
            break;
          case 'large' :
            _sizeString = 'small';
            break;
          default:
            _sizeString = 'medium';
            break;
        }
      }
    );
  }

  Widget _buildTutorialButton() {
    //TODO: make interactive and work once tutorial is in place
    return ListTile(
      title: Text(
        'Replay Tutorial',
        style: new TextStyle(fontSize: getFontSize()),
      )
    );
  }

  //sets the font size using 'small', 'medium', or 'large'
  //returns true if the value was successfully set
  bool setFontSize(String s) {
    if (_sizeMap.containsKey(s.toLowerCase())) {
      _sizeString = s.toLowerCase();
      return true;
    } else {
      return false;
    }
  }

  //returns the current font size
  double getFontSize() {
    return _sizeMap[_sizeString];
  }

  //returns the current font size as a String containing 'small', 'medium', or 'large'
  String getFontSizeString() {
    return _sizeString;
  }
}
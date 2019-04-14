import 'package:flutter/material.dart';
import 'bubbles.dart';
import 'themeSelection.dart';
import 'themes.dart';

//currently an extremely basic prototype, no actual functionality
// ignore: must_be_immutable
class SettingsScreen extends StatefulWidget {
  List<String> _settingNames = ['Theme', 'Font Size', 'Replay Tutorial'];//for testing
  BubblesList _bubList;
  BubbleTheme _theme;

  SettingsScreen(BubblesList list, BubbleTheme theme) {
    this._bubList = list; //needs the bubble list for the theme selection
    this._theme = theme;
  }

  SettingsScreenState createState() => SettingsScreenState(_settingNames);
  //SettingsScreenState createState() => SettingsScreenState(_bubList, _theme);
}

class SettingsScreenState extends State<SettingsScreen> {
  List<String> _settingsNames;//for testing
  BubblesList _bubList;
  BubbleTheme _theme;

  SettingsScreenState(List<String> settingsNames) {//for testing
    this._settingsNames = settingsNames;
  }
  /*
  SettingsScreenState(BubblesList list, BubbleTheme theme) {
    this._bubList = list;
    this._theme = theme;
  }
  */
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
    return ListView.builder(
        padding: const EdgeInsets.all(16.0),
        itemCount: _settingsNames.length * 2 - 1,
        itemBuilder: /*1*/ (context, i) {//i is the row iterator, begins at 0 and increments twice when the function is called
          if (i.isOdd) return Divider(); /*2*///adds a 1 pixel divider object between rows

          final index = i ~/ 2; /*3*///divide i by 2 and return truncated integer result
          return _buildRow(_settingsNames[index]);
        });
  }

  Widget _buildRow(String s) {
    return ListTile(
      title: Text(
        s,
      ),
    );
  }

  //use onTap on a ListTile to call the theme menu
  Widget _buildThemeButton() { //getting an error page when opening the theme menu, not sure why
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
    return null;
  }

  Widget _buildTutorialButton() {
    return null;
  }
}
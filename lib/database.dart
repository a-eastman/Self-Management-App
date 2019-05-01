/// Runs the SQLite database behind flutter
/// version 3.1: settings now integrated into a XML doc
/// author Martin Price
/// written April 2019

import 'package:path_provider/path_provider.dart';
import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
import 'package:xml/xml.dart' as xml;
import 'package:path/path.dart';
import 'dart:async';
import 'dart:io';

///Database class
class DB{
  //Final instance variables
  static final _dbName = 'bubl.db';
  static Directory dict;
  static final _dbVersion = 2;
  static Database _database;    //The only reference to the Database

  //Table and columns for bubble
  static final String _bubble = 'bubble';
  static final String _bID = 'bID';
  static final String _title = 'title';
  static final String _description = 'description';
  static final String _color_red = 'color_red';
  static final String _color_green = 'color_green';
  static final String _color_blue = 'color_blue';
  static final String _opacity = 'opacity';
  static final String _size = 'size';
  static final String _posX = 'posX';
  static final String _posY = 'posY';
  static final String _time_created = 'time_created';
  static final String _time_deleted = 'time_deleted';
  static final String _frequency = 'frequency';
  static final String _days_to_repeat = 'days_to_repeat';
  static final String _times_popped = 'times_popped';

  static final String _not_deleted = 'ALIVE';

  //Table and columns for pop_record
  static final String _pop = 'pop_record';
  static final String _pID = 'pID';
  static final String _time_of_pop = 'time_of_pop';
  static final String _action = 'action';

  static final String _popped = 'POPPED';
  static final String _unpopped = 'UNPOPPED';

  //Table and Columns for app_state
  static final String _app_state = 'app_state';
  static final String _loginID = 'loginID';
  static final String _last_opened = 'last_opened';

  //Table and columns for color themes
  static final String _color_themes = 'color_themes';
  static final String _colorID = 'colorID';
  static final String _color_name = 'color_name';
  static final String _theme_name = 'theme_name';
  static final String _theme_pair = 'theme_pair';

  //XML Fields
  static final String _xmlVersion = '''version="1.0"''';
  static final String _settings = 'settings';
  static final String _font_size = 'font_size';
  static final String _current_theme = 'current_theme';
  static final String _filename = 'state.txt';
  static File _xmlFile;
  static xml.XmlDocument _settingsXML;

  //Makes this a singleton class, allows only one Class per program
  DB._privateContructor();
  static final DB instance = DB._privateContructor();

  /// Gets the database for use
  /// Calls the initDB() for first time use
  /// Along side DB, also establishes the XML script
  Future<Database> get database async{
    initXML();
    dict = await getApplicationDocumentsDirectory();
    if(_database !=null)
      return _database;
    _database = await _initDatabase();
    return _database;
  }

  /// Opens DB, or creates if not found
  _initDatabase() async{
    String path =join(dict.path, _dbName);
    print('path is $path');
    return await openDatabase(path, version:_dbVersion, onCreate: _onCreate);
  }

  /// Creates the database and corresponding tables
  Future _onCreate(Database db, int version) async{
    print('Creating');
    await db.execute("""CREATE TABLE $_bubble ($_bID INTEGER PRIMARY KEY AUTOINCREMENT, 
                        $_title TEXT NOT NULL, $_description TEXT NOT NULL, 
                        $_color_red INTEGER NOT NULL, $_color_green INTEGER NOT NULL, 
                        $_color_blue NOT NULL, $_opacity REAL NOT NULL, $_size INTEGER, 
                        $_posX REAL, $_posY REAL, $_time_created TEXT NOT NULL, 
                        $_time_deleted TEXT, $_frequency INTEGER, $_days_to_repeat TEXT, 
                        $_times_popped INTEGER)""");
    print('created bubble');
    await db.execute("""CREATE TABLE $_pop ($_pID INTEGER PRIMARY KEY AUTOINCREMENT, 
                        $_bID INTEGER NOT NULL, $_time_of_pop TEXT NOT NULL, $_action TEXT, 
                        FOREIGN KEY ($_bID) REFERENCES bubble($_bID))""");
    print('created pop');
    await db.execute("""CREATE TABLE $_app_state ($_loginID INTEGER PRIMARY KEY AUTOINCREMENT, 
                        $_last_opened TEXT)""");
    print('created app');
    await db.execute("""CREATE TABLE $_color_themes ($_colorID INTEGER PRIMARY KEY AUTOINCREMENT,
                        $_color_name TEXT, $_color_red INTEGER, $_color_green, $_color_blue INTEGER, 
                        $_opacity REAL, $_theme_name TEXT, $_theme_pair TEXT)""");
    print('created colors');
    //await populateColorThemes();
    print('finished');
  }

///
///BUBBLE TABLE
///
  /// inserts value used to make a new bubble into the bubble db
  /// successfully updated db returns 1, unsuccessful will return 0
  Future<int> insertBubble(String entry, String description, int colorRed,
      int colorGreen, int colorBlue, double opacity, int size, double posX,
      double posY, int frequency, String days) async{
    Database db = await instance.database;
    Map<String, dynamic> row = {'$_title':entry, '$_description':description,
                                '$_color_red':colorRed, '$_color_green':colorGreen,
                                '$_color_blue':colorBlue, '$_opacity':opacity,
                                '$_size':size, '$_posX':posX, '$_posY':posY,
                                '$_time_created': new DateTime.now().toString(),
                                '$_time_deleted':_not_deleted,'$_frequency': frequency,
                                '$_days_to_repeat': days, '$_times_popped':0};
    try{ return await db.insert(_bubble, row); }
    catch (e) { print(e); return 0; }
  }

  ///returns all Bubbles in a list
  Future<List<Map<String, dynamic>>> queryBubble() async{
    Database db = await instance.database;
    try{ return await db.query(_bubble); }
    catch (e) { return null; }
  }

  ///returns a specific bubble, all columns - queries by the given bubbleID (bID)
  Future<Map<String, dynamic>> queryFullBubbleByID(int bID) async{
    Database db = await instance.database;
    try{ return (await db.query(_bubble, where: '$_bID = ?', whereArgs: [bID])).first;}
    catch(e) {print(e); return null; }
  }

  ///returns a specific bubble, given columns - queries by the given bubbleID(bID)
  Future<Map<String, dynamic>> queryBubbleByID(int bID, List<String> col) async{
    Database db = await instance.database;
    try{ return (await db.query(_bubble, columns: col, where: '$_bID = ?', whereArgs: [bID])).first; }
    catch (e) { print(e); return null; }
  }

  ///returns a list of bubbles for re-population when app is opened
  ///looks for only bubbles that have a 'ALIVE' for 'time_deleted'
  Future<List<Map<String, dynamic>>> queryBubblesForRePop() async{
    Database db = await instance.database;
    try{ 
      final result =  await db.query(_bubble, where: '$_time_deleted = ?', whereArgs: [_not_deleted]); 
      //result.forEach((y) => {print(y)});
      return result;
    }
    catch (e) {print(e); return null; }
  }

  ///finds the last bubble created and returns it's bubbleID
  Future<int> queryLastCreatedBubbleID() async{
    Database db = await instance.database;
    try{ 
      final results = await db.query(_bubble, columns: ['$_bID'], orderBy: '$_bID DESC');
      int id = results.first['$_bID'];
      return id; 
    }
    catch (e) {print(e); return 0; }
  }

  ///returns the fields for the given bubbles color
  Future<Map<String, dynamic>> queryBubbleColor(int bID) async{
    Database db = await instance.database;
    try{ return (await db.query(_bubble, columns: ['$_color_red', '$_color_green', '$_color_blue', '$_opacity'], 
                                where: '$bID = ?', whereArgs: [bID])).first; }
    catch (e) { print(e); return null; }
  }

  ///Updates a given bubble by the values and columns to updated given in row
  Future<int> updateBubbleByID(int bID, Map<String, dynamic> row) async{
    Database db = await instance.database;
    try{ return await db.update(_bubble, row, where: '$_bID = ?', whereArgs: [bID]); }
    catch (e) { print(e); return 1; }
  }

  ///Updates the color of a a specific bubble
  ///New colors is brought in as a map of the RGBO attributes
  Future<int> updateBubbleColor(int bID, Map<String, dynamic> row) async{
    Database db = await instance.database;
    try{ return await db.update(_bubble, row, where: '$_bID = ?', whereArgs: [bID]); }
    catch(e) {print(e); return 0;}
  }
  
  ///increments the time_popped column of a specific bubble by 1
  Future<int> incrementBubbleTimesPopped(int bID) async{
    Database db = await instance.database;
    int currPop;
    try { currPop = (await db.query(_bubble, columns: ['$_times_popped'], where: '$_bID = ?', whereArgs: [bID])).first['$_times_popped']; }
    catch(e) {print(e); return 0; }
    try { return await db.update(_bubble, {'$_times_popped': currPop+1}, where: '$_bID = ?', whereArgs: [bID]); }
    catch(e) {print(e); return 0; }
  }

  ///decrements the time_popped column of a specific bubble by 1
  Future<int> decrementBubbleTimesPopped(int bID) async{
    Database db = await instance.database;
    int currPop;
    try { currPop = (await db.query(_bubble, columns: ['$_times_popped'], where: '$_bID = ?', whereArgs: [bID])).first['$_times_popped']; }
    catch(e) {print(e); return 0; }
    try { return await db.update(_bubble, {'$_times_popped': currPop-1}, where: '$_bID = ?', whereArgs: [bID]); }
    catch(e) {print(e); return 0; }
  }

  ///queries a specific bubble to see if it repeats today
  Future<bool> bubbleRepeatsToday(int bID) async{
    Database db = await instance.database;
    String currDay = dayToString(new DateTime.now().weekday);   //Monday = 1, Sunday = 7
    String days;
    try{
      final result = (await db.query(_bubble, columns: ['$_bID, $_frequency, $_days_to_repeat'], 
                where: '$_bID = ?', whereArgs: [bID])).first;
      int freq = await result['$_frequency'];
      if(freq == 0){
        final subResult = await queryValidPopsByBubble(bID);
        if(subResult.isEmpty) 
          return true;                 //Bubble does not repeat but has never been popped
        return false;                  //Bubble does not repeat but has been popped
      }
      days = await result['$_days_to_repeat']; 
    }
    catch(e) { print('Unable to query $_days_to_repeat'); return false; }
    
    for(String day in days.split('|')){  
      if(day == currDay){
        print('Bubble does repeat every $day');
        return true;
      }
    }
    print('Bubble does not repeat on $currDay');
    return false;
  }
  
  ///returns a string of the day, determined in a switch
  String dayToString(int currDay){
    switch(currDay){
      case 1: { return 'Mon'; } break;
      case 2: { return 'Tue'; } break;
      case 3: { return 'Wed'; } break;
      case 4: { return 'Thu'; } break;
      case 5: { return 'Fri'; } break;
      case 6: { return 'Sat'; } break;
      case 7: { return 'Sun'; } break;
    }
  }

  ///Updates a time_deleted value into a specifc bubble
  Future<int> insertDelete(int bID) async{
    Database db = await instance.database;
    String time = new DateTime.now().toString();
    try {return await db.update(_bubble, {'$_time_deleted' : time}, 
          where: '$_bID = ?', whereArgs: [bID]); }
    catch(e) { return 0; }
  }

  ///updates a specific deleted bubble to alive status
  Future<int> reverseDelete(int bID) async{
    Database db = await instance.database;
    try{ return await db.update(_bubble, {'$_time_deleted' : _not_deleted},
          where: '$_bID = ?', whereArgs: [bID]); }
    catch(e) { return 0; }
  }

///
///POP RECORD TABLE
///
  ///returns all the pop records values in a list
  Future<List<Map<String, dynamic>>> queryPop() async{
    Database db = await instance.database;
    try{ return await db.query(_pop); }
    catch (e) { print(e); return null; }
  }
  
  ///returns all the pop records of a specific bubble in order of
  ///most recent pop (by date) to oldest
  Future<List<Map<String, dynamic>>> queryPopByBubble(int bID) async{
    Database db = await instance.database;
    try{ return await db.query(_pop, where: '$_bID = ?', whereArgs: [bID], 
                              orderBy: '$_time_of_pop DESC'); }
    catch (e) {print(e); return []; }
  }

  ///returns all VALID pop records for a specific bubble,
  ///a valid pop has 'POPPED' as a value for action, an invalid bubble was unpopped
  ///and has 'UNPOPPED' as an action value
  Future<List<Map<String, dynamic>>> queryValidPopsByBubble(int bID) async{
    Database db = await instance.database;
    try{ return await db.query(_pop, where: '$_bID = ? AND $_action = ?', whereArgs: [bID, _popped], 
                              orderBy: '$_time_of_pop DESC'); }
    catch (e) {print(e); return []; }
  }

  /// Inserts a new value into the pop_bubble for a specific bubble
  Future<int> insertPop(int bID) async{
    Database db = await instance.database;
    Map<String, dynamic> row = {'$_bID':bID, '$_time_of_pop':new DateTime.now().toString(),
      '$_action':'$_popped'};
    try { return await db.insert(_pop, row); }
    catch (e) { print(e); return 0; }
  }

  ///finds and changes the last pop made by a specific bubble and make the pop invalid
  ///an invalid pop will have 'UNPOPPED' as a value for the action field
  Future<int> undoPop(int bID) async{
    Database db = await instance.database;
    try{
      final pid = (await queryPopByBubble(bID)).first['$_pID'];
      return await db.update(_pop, {'$_action': '$_unpopped'}, where: '$_pID = ?', whereArgs: [pid]);
    }
    catch(e) {return 0;}

  }

  /// Queries a specifc bubble that have been popped today,
  /// only checks for the last pop made per bubble to save on time
  /// @param bID : specifc bubble to grab
  /// @return true : if the specific bubble has been popped today
  Future<bool> queryPopForRecent(int bID) async{
    var currTime = new DateTime.now();
    final results = await queryValidPopsByBubble(bID);
    try{
      var lastPopped = DateTime.parse(results.first['$_time_of_pop']);
      var diff = currTime.difference(lastPopped);
      return diff.inDays > 0;
    }
    catch(e) {return true;}
  }

 ///
 ///APP STATE TABLE
 /// 
  
  /// Enters in the latest login id
  /// @return 1 : success
  /// @return 0 : error thrown
  Future<int> enterLogin(String time) async{
    Database db = await instance.database;
    try { return await db.insert(_app_state, {'$_last_opened': time} ); }
    catch (e) {print(e); return 0;}
  }

  ///@return : Gets the latest login time
  Future<String> latestLoginTime() async{
    Database db = await instance.database;
    try{ 
      String s = (await db.query(_app_state, orderBy: '$_last_opened DESC')).first['$_last_opened'];
      print('Last login time was $s');
      return s;
    }
    catch (e) {print(e); return "";}
  }

  ///Compares the time to that of the latest login time
  ///@return true : new day has 
  ///@ return false : same day as last login time
  Future<bool> login() async{
    String lastTime = await latestLoginTime();
    if(lastTime == "") {enterLogin(new DateTime.now().toString()); return true; } // first time login
    var prevTime = DateTime.parse(lastTime);
    var currTime = new DateTime.now();
    var diff = currTime.difference(prevTime);
    enterLogin(currTime.toString());
    return diff.inDays > 0;
  }

  ///@return list of logins ordered by most recent
  Future<List<Map<String, dynamic>>> queryAppState() async{
    Database db = await instance.database;
    try {return db.query(_app_state, orderBy: '$_last_opened DESC');}
    catch(e) {print(e); return null; }
  }

///
///COLOR THEME TABLE
///
  ///@return a query of the color table
  Future<List<Map<String, dynamic>>> queryColors() async{
    Database db = await instance.database;
    try{ return await db.query(_color_themes); }
    catch(e) { return []; }
  }

  ///@return a specifc color 
  Future<Map<String, dynamic>> queryColorsByID(int cID) async{
    Database db = await instance.database;
    try{ return (await db.query(_color_themes, where: 
          '$_colorID = ?', whereArgs: [cID])).first; }
    catch (e) { return {}; }
  }

  /// Populates the color_theme table with pre deetermined patterns
  /// typically only used on initital startup 
  void populateColorThemes() async{
    Database db = await instance.database;
    Color c = Colors.blue;        //Bubble Theme
    try{
      await db.insert(_color_themes, {_color_name: 'blue', 
        _color_red: c.red, _color_green: c.green, _color_blue: c.blue, _opacity: c.opacity,
        _theme_name: 'Bubble'});
    }
    catch(e) {print(e); print('Unable to populate blue');}
    
    try{
      c = Colors.deepOrange[200];   //Sunset Theme
      await db.insert(_color_themes, {_color_name: 'deepOrange', 
        _color_red: c.red, _color_green: c.green, _color_blue: c.blue, _opacity: c.opacity,
        _theme_name: 'Sunset'});
    }
    catch(e) {print(e); print('Unable to populate deepOrange');}

    try{
      c = Colors.purple[200];       //Dusk Theme
      await db.insert(_color_themes, {_color_name: 'purple', 
        _color_red: c.red, _color_green: c.green, _color_blue: c.blue, _opacity: c.opacity,
        _theme_name: 'Dusk'});
    }
    catch(e) {print(e); print('Unable to populate purple');}

    try{
      c = Colors.yellow[200];       //Sunny Theme
      await db.insert(_color_themes, {_color_name: 'yellow', 
        _color_red: c.red, _color_green: c.green, _color_blue: c.blue, _opacity: c.opacity,
        _theme_name: 'Sunny'});
    } 
    catch(e) {print(e); print('Unable to populate yellow');}
    
    try{
      c = Colors.blue[100];          //Ocean Theme
      await db.insert(_color_themes, {_color_name: 'ocean', 
        _color_red: c.red, _color_green: c.green, _color_blue: c.blue, _opacity: c.opacity,
        _theme_name: 'Ocean'});
    }
    catch(e) {print(e); print('Unable to populate Ocean');}
  }

///
///FOR DEV USE ONLY
///
  ///refreshes the DB, drops and recreates tables
  void refreshDB() async{
    Database db = await instance.database;
    db.execute("DROP TABLE $_bubble;");
    db.execute("DROP TABLE $_pop;");
    db.execute("DROP TABLE $_app_state");
    db.execute("DROP TABLE $_color_themes");
    print('Tables dropped');
    createDB();

  }
  void createDB() async{
    Database db = await instance.database;
    print('Refreshing');
    await db.execute("""CREATE TABLE $_bubble ($_bID INTEGER PRIMARY KEY AUTOINCREMENT, 
                        $_title TEXT NOT NULL, $_description TEXT NOT NULL, 
                        $_color_red INTEGER NOT NULL, $_color_green INTEGER NOT NULL, 
                        $_color_blue NOT NULL, $_opacity REAL NOT NULL, $_size INTEGER, 
                        $_posX REAL, $_posY REAL, $_time_created TEXT NOT NULL, 
                        $_time_deleted TEXT, $_frequency INTEGER, $_days_to_repeat TEXT, 
                        $_times_popped INTEGER)""");
    await db.execute("""CREATE TABLE $_pop ($_pID INTEGER PRIMARY KEY AUTOINCREMENT, 
                        $_bID INTEGER NOT NULL, $_time_of_pop TEXT NOT NULL, $_action TEXT, 
                        FOREIGN KEY ($_bID) REFERENCES bubble($_bID))""");
    await db.execute("""CREATE TABLE $_app_state ($_loginID INTEGER PRIMARY KEY AUTOINCREMENT, 
                        $_last_opened TEXT)""");
    await db.execute("""CREATE TABLE $_color_themes ($_colorID INTEGER PRIMARY KEY AUTOINCREMENT,
                        $_color_name TEXT, $_color_red INTEGER, $_color_green, $_color_blue INTEGER, 
                        $_opacity REAL, $_theme_name TEXT, $_theme_pair TEXT)""");
    print('Created colors');
    await populateColorThemes();
    print('Populating colors');
    initXML();
  }

  ///initializes the XML
  Future<bool> initXML() async{
    dict = await getApplicationDocumentsDirectory();
    _xmlFile = openXMLScript();
    _settingsXML = await createXML();
    return true;
  }

  ///opens and initializes the XML script page
  ///@return file : xml script page
  File openXMLScript(){
    print('opening xml');
    if(_xmlFile != null)
      return _xmlFile;
    return new File(join(dict.path, _filename));
  }
  
  ///Creates the XML page for first time creation
  ///Creates a textfile to hold the xml script 
  Future<xml.XmlDocument> createXML() async{
    try{
      String xmlString = await _xmlFile.readAsString();
      print('String text $xmlString is ${xmlString.length}');
      if(xmlString.isNotEmpty)
        return xml.parse(xmlString);
    }
    catch(e){ print(e); } 
    print('Error thrown: Generating xml from new');
    var builder = new xml.XmlBuilder();
    builder.processing('xml', _xmlVersion);
    builder.element(_settings, nest: () {
      builder.element(_font_size, nest: 14.0);
      builder.element(_current_theme, nest: 1);
    });
    xml.XmlDocument x = builder.build();
    await _xmlFile.writeAsString(x.toString());
    return x;
  }

  ///Recreates the XML page to update the info
  
  Future<xml.XmlDocument> recreateXML(double font, int currTheme) async{
    var builder = new xml.XmlBuilder();
    builder.processing('xml', '$_xmlVersion');
    builder.element('$_settings', nest: () {
      builder.element('$_font_size', nest: font);
      builder.element(_current_theme, nest : currTheme);
    });
    xml.XmlDocument x = builder.build();
    await _xmlFile.writeAsString(x.toString());
    return x;
  }

  ///Prints out the XML page in tabbed format
  void printXML(){
    try{ print(_settingsXML.toXmlString(pretty: true, indent: '\t')); }
    catch(e) { print(e); }
  }

  ///returns stored font_size
  double getStoredFontSize(){
    var settings = _settingsXML.findElements(_settings)
      .map((node) => node.findElements(_font_size).single.text.toString())
      .reduce((a,b) => a+b);
    return double.parse(settings);
  }

  ///returns stored theme id
  int getStoredThemeID(){
    var theme = _settingsXML.findElements(_settings)
      .map((node) => node.findElements(_current_theme).single.text.toString())
      .reduce((a,b) => a+b);
    return int.parse(theme);
  }

  ///Sets the new font_size
  ///keeps the same theme id
  void enterFontSize(double font) async{
    int currTheme = getStoredThemeID();
    _settingsXML = await recreateXML(font, currTheme);
  }

  ///Sets the new current theme id
  ///keeps same font size
  void enterThemeID(int currTheme) async{
    double font = getStoredFontSize();
    _settingsXML = await recreateXML(font, currTheme);
  }

  ///Refreshed the XML back to initial state for testing
  void refreshXML() async {
     await _xmlFile.writeAsString("");
    print('Generating XML');     
     _settingsXML = await createXML();
    print('Generated XML');
  }

  ///Gathers the settigns and returns them for initialziation
  ///sreturn a map of the collection of the settings
  Future<Map<String, Map<dynamic, dynamic>>> getSettings() async{
    await initXML();
    Map font = {_font_size: getStoredFontSize()};
    Map theme = {_current_theme: getStoredThemeID()};
    return {'font':font,'theme':theme};
  }
}

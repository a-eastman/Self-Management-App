import 'package:path_provider/path_provider.dart';
import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'dart:async';
import 'dart:io';

/// Runs the SQLite database behind flutter
/// @version 2.0: tables for bubbles, pop, state, and color
/// @author Martin Price
/// @date April
class DB
{
  //Final instance variables
  static final _dbName = 'bubl.db';

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

  static final _dbVersion = 2;
  static Database _database;    //The only reference to the Database

  //Makes this a singleton class, allows only one Class per program
  DB._privateContructor();
  static final DB instance = DB._privateContructor();

  /// Gets the database for use
  /// Calls the initDB() for first time use
  Future<Database> get database async
  {
    if(_database !=null)
      return _database;
    _database = await _initDatabase();
    return _database;
  }

  /// Opens DB, or creates if not found
  _initDatabase() async
  {
    Directory d = await getApplicationDocumentsDirectory();
    String path =join(d.path, _dbName);
    return await openDatabase(path, version:_dbVersion, onCreate: _onCreate);
  }

  /// Creates the database and corresponding tables
  Future _onCreate(Database db, int version) async
  {
    print('before creating tables');
    await db.execute("""CREATE TABLE $_bubble ($_bID INTEGER PRIMARY KEY AUTOINCREMENT, 
                        $_title TEXT NOT NULL, $_description TEXT NOT NULL, 
                        $_color_red INTEGER NOT NULL, $_color_green INTEGER NOT NULL, 
                        $_color_blue NOT NULL, $_opacity REAL NOT NULL, $_size INTEGER, 
                        $_posX REAL, $_posY REAL, $_time_created TEXT NOT NULL, 
                        $_time_deleted TEXT, $_frequency INTEGER, $_days_to_repeat TEXT, 
                        $_times_popped INTEGER)""");
    print('Created bubble');
    await db.execute("""CREATE TABLE $_pop ($_pID INTEGER PRIMARY KEY AUTOINCREMENT, 
                        $_bID INTEGER NOT NULL, $_time_of_pop TEXT NOT NULL, $_action TEXT, 
                        FOREIGN KEY ($_bID) REFERENCES bubble($_bID))""");
    print('Created pop');
    await db.execute("""CREATE TABLE $_app_state ($_loginID INTEGER PRIMARY KEY AUTOINCREMENT, 
                        $_last_opened TEXT)""");
    print('Created app state');
    await db.execute("""CREATE TABLE $_color_themes ($_colorID INTEGER PRIMARY KEY AUTOINCREMENT,
                        $_color_name TEXT, $_color_red INTEGER, $_color_green, $_color_blue INTEGER, 
                        $_opacity REAL, $_theme_name TEXT, $_theme_pair TEXT)""");
    print('Created colors');
    //await populateColorThemes();
  }

///
///BUBBLE TABLE
///
  /// inserts value used to make a new bubble into the bubble db
  /// @return 1: successfully updated db
  /// @return 0: error thrown
  Future<int> insertBubble(String entry, String description, int colorRed,
      int colorGreen, int colorBlue, double opacity, int size, double posX,
      double posY, int frequency, String days) async
  {
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

  ///@return all Bubbles
  Future<List<Map<String, dynamic>>> queryBubble() async
  {
    Database db = await instance.database;
    try{ return await db.query(_bubble); }
    catch (e) { return null; }
  }

  ///@return the bubble with matching bID
  Future<Map<String, dynamic>> queryBubbleByID(int bID, List<String> col) async
  {
    Database db = await instance.database;
    try{ return (await db.query(_bubble, columns: col, where: '$_bID = ?', whereArgs: [bID])).first; }
    catch (e) { print(e); return null; }
  }

  ///@return bubbles for re-population when app is opened
  /// looks for only bubbles that have a 0 for 'deleted'
  Future<List<Map<String, dynamic>>> queryBubblesForRePop() async
  {
    Database db = await instance.database;
    try{ 
      final result =  await db.query(_bubble, where: '$_time_deleted = ?', whereArgs: [_not_deleted]); 
      //result.forEach((y) => {print(y)});
      return result;
    }
    catch (e) {print(e); return null; }
  }

  /// finds the last bubble created
  /// @return bID : the latest bubble id
  Future<int> queryLastCreatedBubbleID() async
  {
    Database db = await instance.database;
    try{ 
      final results = await db.query(_bubble, columns: ['$_bID'], orderBy: '$_bID DESC');
      int id = results.first['$_bID'];
      return id; 
    }
    catch (e) {print(e); return 0; }
  }

  ///@param bID : the specific bubbles id
  ///@return the fields for the bubbles color
  Future<Map<String, dynamic>> queryBubbleColor(int bID) async
  {
    Database db = await instance.database;
    try{ return (await db.query(_bubble, columns: ['$_color_red', '$_color_green', '$_color_blue', '$_opacity'], 
                                where: '$bID = ?', whereArgs: [bID])).first; }
    catch (e) { print(e); return null; }
  }

  ///Updates a bubble row
  ///@param bID : bubble to update
  ///@param row : row to update has the column and new value
  Future<int> updateBubbleByID(int bID, Map<String, dynamic> row) async
  {
    Database db = await instance.database;
    try{ return await db.update(_bubble, row, where: '$_bID = ?', whereArgs: [bID]); }
    catch (e) { print(e); return 1; }
  }

  ///Updates the color of a bubble
  ///@param bID : bubble to update
  ///@param row : color v
  ///@return 1 : successful update
  ///@return 0 : error thrown
  Future<int> updateBubbleColor(int bID, Map<String, dynamic> row) async
  {
    Database db = await instance.database;
    try{ return await db.update(_bubble, row, where: '$_bID = ?', whereArgs: [bID]); }
    catch(e) {print(e); return 0;}
  }
  
  ///increments the time_popped column by 1
  ///@param bID : bubble just popped
  ///@return 1 : successful update
  ///@return 0 : error thrown
  Future<int> updateBubbleTimesPopped(int bID) async
  {
    Database db = await instance.database;
    int currPop;
    try { currPop = (await db.query(_bubble, columns: ['$_times_popped'], where: '$_bID = ?', whereArgs: [bID])).first['$_times_popped']; }
    catch(e) {print(e); return 0; }
    try { return await db.update(_bubble, {'$_times_popped': currPop+1}, where: '$_bID = ?', whereArgs: [bID]); }
    catch(e) {print(e); return 0; }
  }

  ///Queries Bubble to see if the Bubble repeats on this day
  ///@param bID : bubble ID
  ///@return true : repeats on this day
  ///@return false : does not repeat
  Future<bool> bubbleRepeatsToday(int bID) async
  {
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
  
  ///@return string of day determined in a switch
  String dayToString(int currDay)
  {
    switch(currDay)
    {
      case 1: { return 'Mon'; } break;
      case 2: { return 'Tue'; } break;
      case 3: { return 'Wed'; } break;
      case 4: { return 'Thu'; } break;
      case 5: { return 'Fri'; } break;
      case 6: { return 'Sat'; } break;
      case 7: { return 'Sun'; } break;
    }
  }

  ///Inserts a time_deleted value into a bubble
  ///@param bID : bubble ID
  ///@return 1 : successfully update
  ///@return 0 : error thrown
  Future<int> insertDelete(int bID) async
  {
    Database db = await instance.database;
    String time = new DateTime.now().toString();
    try {return await db.update(_bubble, {'$_time_deleted' : time}, 
          where: '$_bID = ?', whereArgs: [bID]); }
    catch(e) { return 0; }
  }

  ///Returns a deleted bubble to alive
  ///@param bID : bubble ID
  ///@return 1 : successfully update
  ///@return 0 : error thrown
  Future<int> reverseDelete(int bID) async
  {
    Database db = await instance.database;
    try{ return await db.update(_bubble, {'$_time_deleted' : _not_deleted},
          where: '$_bID = ?', whereArgs: [bID]); }
    catch(e) { return 0; }
  }

///
///POP RECORD TABLE
///
  ///@return all the pop records
  Future<List<Map<String, dynamic>>> queryPop() async
  {
    Database db = await instance.database;
    try{ return await db.query(_pop); }
    catch (e) { print(e); return null; }
  }

  ///@return all pop records for a specific bubble,
  ///@returns in order of most frequent pop down
  Future<List<Map<String, dynamic>>> queryPopByBubble(int bID) async
  {
    Database db = await instance.database;
    try{ return await db.query(_pop, where: '$_bID = ?', whereArgs: [bID], 
                              orderBy: '$_time_of_pop DESC'); }
    catch (e) {print(e); return []; }
  }

  ///@return all VALID pop records for a specific bubble
  Future<List<Map<String, dynamic>>> queryValidPopsByBubble(int bID) async
  {
    Database db = await instance.database;
    try{ return await db.query(_pop, where: '$_bID = ? AND $_action = ?', whereArgs: [bID, _popped], 
                              orderBy: '$_time_of_pop DESC'); }
    catch (e) {print(e); return []; }
  }

  /// Inserts value into the pop_bubble
  /// @param bID : bubble ID that was popped
  /// @return 1: suceessfully updated db
  /// @return 0: error thrown
  Future<int> insertPop(int bID) async
  {
    Database db = await instance.database;
    Map<String, dynamic> row = {'$_bID':bID, '$_time_of_pop':new DateTime.now().toString(),
      '$_action':'$_popped'};
    try { return await db.insert(_pop, row); }
    catch (e) { print(e); return 0; }
  }

  ///Changes tyhe action of the latest pop of a bubble to UNPOPPED
  ///@param bID : bubble id to be reverted
  ///@return 1: successfully updated db
  ///@return 0: error thrown
  Future<int> undoPop(int bID) async
  {
    Database db = await instance.database;
    try
    {
      final pid = (await queryPopByBubble(bID)).first['$_pID'];
      return await db.update(_pop, {'$_action': '$_unpopped'}, where: '$_pID = ?', whereArgs: [pid]);
    }
    catch(e) {return 0;}

  }

  /// Queries a specifc bubble that have been popped today,
  /// only checks for the last pop made per bubble to save on time
  /// @param bID : specifc bubble to grab
  /// @return true : if the specific bubble has been popped today
  Future<bool> queryPopForRecent(int bID) async
  {
    var currTime = new DateTime.now();
    final results = await queryValidPopsByBubble(bID);
    try
    {
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
  Future<int> enterLogin(String time) async
  {
    Database db = await instance.database;
    try { return await db.insert(_app_state, {'$_last_opened': time} ); }
    catch (e) {print(e); return 0;}
  }

  ///@return : Gets the latest login time
  Future<String> latestLoginTime() async
  {
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
  Future<bool> login() async
  {
    String lastTime = await latestLoginTime();
    if(lastTime == "") {enterLogin(new DateTime.now().toString()); return true; } // first time login
    var prevTime = DateTime.parse(lastTime);
    var currTime = new DateTime.now();
    var diff = currTime.difference(prevTime);
    enterLogin(currTime.toString());
    return diff.inDays > 0;
  }

  ///@return list of logins ordered by most recent
  Future<List<Map<String, dynamic>>> queryAppState() async
  {
    Database db = await instance.database;
    try {return db.query(_app_state, orderBy: '$_last_opened DESC');}
    catch(e) {print(e); return null; }
  }

///
///COLOR THEME TABLE
///
  ///@return a query of the color table
  Future<List<Map<String, dynamic>>> queryColors() async
  {
    Database db = await instance.database;
    try{ return await db.query(_color_themes); }
    catch(e) { return []; }
  }

  ///@return a specifc color 
  Future<Map<String, dynamic>> queryColorsByID(int cID) async
  {
    Database db = await instance.database;
    try{ return (await db.query(_color_themes, where: 
          '$_colorID = ?', whereArgs: [cID])).first; }
    catch (e) { return {}; }
  }

  /// Populates the color_theme table with pre deetermined patterns
  /// typically only used on initital startup 
  void populateColorThemes() async
  {
    Database db = await instance.database;
    Color c = Colors.blue;        //Bubble Theme
    await db.insert(_color_themes, {_color_name: 'blue', 
      _color_red: c.red, _color_green: c.green, _color_blue: c.blue, _opacity: c.opacity,
      _theme_name: 'Bubble'});
    
    c = Colors.deepOrange[200];   //Sunset Theme
    await db.insert(_color_themes, {_color_name: 'deepOrange', 
      _color_red: c.red, _color_green: c.green, _color_blue: c.blue, _opacity: c.opacity,
      _theme_name: 'Sunset'});
    
    c = Colors.purple[200];       //Dusk Theme
    await db.insert(_color_themes, {_color_name: 'purple', 
      _color_red: c.red, _color_green: c.green, _color_blue: c.blue, _opacity: c.opacity,
      _theme_name: 'Dusk'});

    c = Colors.yellow[200];       //Sunny Theme
    await db.insert(_color_themes, {_color_name: 'yellow', 
      _color_red: c.red, _color_green: c.green, _color_blue: c.blue, _opacity: c.opacity,
      _theme_name: 'Sunny'});

    c = Colors.blue[100];          //Ocean Theme
    await db.insert(_color_themes, {_color_name: 'blue', 
      _color_red: c.red, _color_green: c.green, _color_blue: c.blue, _opacity: c.opacity,
      _theme_name: 'Ocean'});
  }

///
///FOR DEV USE ONLY
///
  ///refreshes the DB, drops and recreates tables
  void refreshDB() async
  {
    print('Here');
    Database db = await instance.database;
    print('Here 2');
    db.execute("DROP TABLE $_bubble;");
    db.execute("DROP TABLE $_pop;");
    db.execute("DROP TABLE $_app_state");
    db.execute("DROP TABLE $_color_themes");
    createDB();
  }
  void createDB() async
  {
    Database db = await instance.database;
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
    await populateColorThemes();
  }
}

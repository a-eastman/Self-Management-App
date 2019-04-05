import 'package:path_provider/path_provider.dart';
import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
import 'package:sprintf/sprintf.dart';
import 'package:path/path.dart';
import 'dart:async';
import 'dart:io';

/// Runs the SQLite database behind flutter
/// @version 2.0: tables for bubbles, pop, state, and color
/// @author Martin Price
/// @date March 2019
class DB
{
  //Final instance variables
  static final _dbName = "bubl.db";
  static final _bubble = "bubble";
  static final _pop = "pop_record";
  static final _app_state = "app_state";
  static final _color_themes = "color_themes";
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
    await db.execute("""CREATE TABLE bubble (bID INTEGER PRIMARY KEY AUTOINCREMENT, 
                        title TEXT NOT NULL, description TEXT NOT NULL, 
                        color_red INTEGER NOT NULL, color_green INTEGER NOT NULL, 
                        color_blue NOT NULL, opacity REAL NOT NULL, size INTEGER, 
                        posX REAL, posY REAL, time_created TEXT, 
                        deleted INTEGER, frequency INTEGER, days_to_repeat TEXT, 
                        times_popped INTEGER)""");
    await db.execute("""CREATE TABLE pop_record (pID INTEGER PRIMARY KEY AUTOINCREMENT, 
                        bID INTEGER NOT NULL, time_popped TEXT NOT NULL, action TEXT, 
                        FOREIGN KEY (bID) REFERENCES bubble(bID))""");
    await db.execute("""CREATE TABLE $_app_state (last_opened TEXT)""");
    await db.execute("""CREATE TABLE $_color_themes (colorID INTEGER PRIMARY KEY AUTOINCREMENT,
                        color_red INTEGER, color_green, color_blue INTEGER, color_opacity REAL""");
  }

///
///BUBBLE TABLE
///
  /// inserts value used to make a new bubble into the bubble db
  /// @return 1: successfully updated db
  /// @return 0: error thrown
  Future<int> insertBubble(String _entry, String _description, int _colorRed,
      int _colorGreen, int _colorBlue, double _opacity, int _size, double _posX,
      double _posY) async
  {
    Database db = await instance.database;
    Map<String, dynamic> row = {'title':_entry, 'description':_description,
                                'color_red':_colorRed, 'color_green':_colorGreen,
                                'color_blue':_colorBlue, 'opacity':_opacity,
                                'size':_size, 'posX':_posX, 'posY':_posY,
                                'time_created': new DateTime.now().toString(),
                                'deleted': 0, 'frequency':1, 'times_popped':1};
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
    try{ return (await db.query(_bubble, columns: col, where: 'bID = ?', whereArgs: [bID])).first; }
    catch (e) { print(e); return null; }
  }

  ///@return bubbles for re-population when app is opened
  /// looks for only bubbles that have a 0 for 'deleted'
  Future<List<Map<String, dynamic>>> queryBubblesForRePop() async
  {
    Database db = await instance.database;
    try{ return await db.query(_bubble, where: 'deleted = 0'); }
    catch (e) {print(e); return null; }
  }

  /// finds the last bubble created
  /// @return bID : the latest bubble id
  Future<int> queryLastCreatedBubbleID() async
  {
    Database db = await instance.database;
    try{ return (await db.query(_bubble, columns: ['bID'], orderBy: 'bID DESC')).first['bID']; }
    catch (e) {print(e); return 0; }
  }

  ///@param bID : the specific bubbles id
  ///@return the fields for the bubbles color
  Future<Map<String, dynamic>> queryBubbleColor(int bID) async
  {
    Database db = await instance.database;
    String query = sprintf("SELECT color_red, color_green, color_blue, opacity FROM bubble WHERE bID = %d", [bID]);
    try{ return (await db.rawQuery(query)).first; }
    catch (e) { print(e); return null; }
  }

  ///Updates a bubble row
  ///@param bID : bubble to update
  ///@param row : row to update has the column and new value
  Future<int> updateBubbleByID(int bID, Map<String, dynamic> row) async
  {
    Database db = await instance.database;
    try{ return await db.update(_bubble, row, where: 'bID = ?', whereArgs: [bID]); }
    catch (e) { print(e); return 1; }
  }

  ///Updates the color of a bubble
  ///@param bID : bubble to update
  ///@param row : color v
  Future<int> updateBubbleColor(int bID)
  {

  }
  
  ///increments the time_popped column by 1
  ///@param bID : bubble just popped
  Future<int> updateBubbleTimesPopped(int bID) async
  {
    Database db = await instance.database;
    int currPop;
    try { currPop = (await db.query(_bubble, columns: ['times_popped'], where: 'bID = ?', whereArgs: [bID])).first['times_popped']; }
    catch(e) {print(e); return 1; }
    try { return await db.update(_bubble, {'times_popped': currPop+1}, where: 'bID = ?', whereArgs: [bID]); }
    catch(e) {print(e); return 1; }
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
    try{ return await db.query(_pop, where: 'bID = ?', whereArgs: [bID], 
                              orderBy: 'time_popped DESC'); }
    catch (e) {print(e); return []; }
  }

  /// Inserts value into the pop_bubble
  /// @param bID : bubble ID that was popped
  /// @return 1: suceessfully updated db
  /// @return 0: error thrown
  Future<int> insertPop(int bID) async
  {
    Database db = await instance.database;
    Map<String, dynamic> row = {'bID':bID, 'time_popped':new DateTime.now().toString(),
      'action':'POPPED'};
    try { return await db.insert(_pop, row); }
    catch (e) { print(e); return 0; }
  }

  /// Queries a specifc bubble that have been popped today,
  /// only checks for the last pop made per bubble to save on time
  /// @param bID : specifc bubble to grab
  /// @return true : if the specific bubble has been popped today
  Future<bool> queryPopForRecent(int bID) async
  {
    var currTime = new DateTime.now();
    final results = await queryPopByBubble(bID);
    var lastPopped = DateTime.parse(results.first['time_popped']);
    var diff = currTime.difference(lastPopped);
    return diff.inDays == 0;
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
    try { return await db.insert(_app_state, {'last_opened': time} ); }
    catch (e) {print(e); return 0;}
  }

  ///@return : Gets the latest login time
  Future<String> latestLoginTime() async
  {
    Database db = await instance.database;
    try{ return (await db.query(_app_state, orderBy: 'last_opened DESC')).first['last_opened']; }
    catch (e) {print(e); return "";}
  }

  ///Compares the time to that of the latest login time
  ///@return true : new day has 
  ///@ return false : same day as last login time
  Future<bool> login() async
  {
    String lastTime = await latestLoginTime();
    if(lastTime == "") { enterLogin(new DateTime.now().toString()); return false; } // first time login
    
    var prevTime = DateTime.parse(lastTime);
    var currTime = new DateTime.now();
    var diff = currTime.difference(prevTime);
    enterLogin(currTime.toString());
    return diff.inDays > 0;
  }

///
///COLOR THEME TABLE
///
  /// Populates the color_theme table with pre deetermined patterns
  /// typically only used on initital startup 
  void populateColorTheme() async
  {

  }

///
///FOR DEV USE ONLY
///
  ///refreshes the DB, drops and recreates tables
  void refreshDB() async
  {
    Database db = await instance.database;
    db.execute("DROP TABLE $_bubble;");
    db.execute("DROP TABLE $_pop;");
    db.execute("DROP TABLE $_app_state");
    db.execute("DROP TABLE $_color_themes");
    createDB();
  }
  void createDB() async
  {
    Database db = await instance.database;
    await db.execute("""CREATE TABLE bubble (bID INTEGER PRIMARY KEY AUTOINCREMENT, 
                        title TEXT NOT NULL, description TEXT NOT NULL, 
                        color_red INTEGER NOT NULL, color_green INTEGER NOT NULL, 
                        color_blue NOT NULL, opacity REAL NOT NULL, size INTEGER, 
                        posX REAL, posY REAL, time_created TEXT, 
                        deleted INTEGER, frequency INTEGER, days_to_repeat TEXT, 
                        times_popped INTEGER)""");
    await db.execute("""CREATE  TABLE $_pop (pID INTEGER PRIMARY KEY AUTOINCREMENT, 
                        bID INTEGER NOT NULL, time_popped TEXT NOT NULL, action TEXT, 
                        FOREIGN KEY (bID) REFERENCES bubble(bID))""");
    await db.execute("""CREATE TABLE $_app_state (last_opened TEXT)""");
    await db.execute("""CREATE TABLE $_color_themes (colorID INTEGER PRIMARY KEY AUTOINCREMENT,
                        color_red INTEGER, color_green, color_blue INTEGER, color_opacity REAL""");
  }

}

import 'package:path_provider/path_provider.dart';
import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
import 'package:sprintf/sprintf.dart';
import 'package:path/path.dart';
import 'dart:async';
import 'dart:io';

/// Runs the SQLite database behind flutter
/// @version 1.2: initialize the database, uses hardcoded queries, no file io
/// @author Martin Price
/// @date March 2019
class DB
{
  //Final instance variables
  static final _dbName = "bubl.db";
  static final _bubble = "bubble";
  static final _pop = "pop_record";
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
                        deleted INTEGER, frequency INTEGER, times_popped INTEGER)""");
    await db.execute("""CREATE  TABLE pop_record (pID INTEGER PRIMARY KEY AUTOINCREMENT, 
                        bID INTEGER NOT NULL, time_popped TEXT NOT NULL, action TEXT, 
                        FOREIGN KEY (bID) REFERENCES bubble(bID))""");
  }

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

  ///@return all the pop records
  Future<List<Map<String, dynamic>>> queryPop() async
  {
    Database db = await instance.database;
    try{ return await db.query(_pop); }
    catch (e) { print(e); return null; }
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


  ///FOR DEV USE ONLY
  ///refreshes the DB, drops and recreates tables
  void refreshDB() async
  {
    Database db = await instance.database;
    db.execute("DROP TABLE $_bubble;");
    db.execute("DROP TABLE $_pop;");
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
                        deleted INTEGER, frequency INTEGER, times_popped INTEGER)""");
    await db.execute("""CREATE  TABLE pop_record (pID INTEGER PRIMARY KEY AUTOINCREMENT, 
                        bID INTEGER NOT NULL, time_popped TEXT NOT NULL, action TEXT, 
                        FOREIGN KEY (bID) REFERENCES bubble(bID))""");
  }

}

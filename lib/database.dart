import 'package:path_provider/path_provider.dart';
import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
import 'package:sprintf/sprintf.dart';
import 'package:path/path.dart';
import 'dart:async';
import 'dart:io';

/**
 * Runs the SQLite database behind flutter
 * @version 1.2: initialize the database, uses hardcoded queries, no file io
 * @author Martin Price
 * @date March 2019
 */
class DB
{
  //Final instance variables
  static final _dbName = "bubl.db";
  static final _dbVersion = 1;

  var _currQueryFile;  //will be assigned to txt file of current query
  Future<String> _currQuery;   //Holds the string of the query
  static Database _database; //The only reference to the Database

  //Makes this a singleton class, allows only one Class per program
  DB._privateContructor();
  static final DB instance = DB._privateContructor();

  /**
   * Gets the database for use
   * Calls the initDB() for first time use 
   */
  Future<Database> get database async
  {
    if(_database !=null)
      return _database;
    _database = await _initDatabase();
    return _database;
  }

  /**
   * Opens DB, or creates if not found
   */
  _initDatabase() async 
  {
    Directory d = await getApplicationDocumentsDirectory();
    String path =join(d.path, _dbName);
    return await openDatabase(path, version:_dbVersion, onCreate: _onCreate);
  }

  /**
   * Creates the database and corresponding tables
   */
  Future _onCreate(Database db, int version) async
  {
    await db.execute('''CREATE TABLE bubble (bID INTEGER PRIMARY KEY AUTOINCREMENT, 
                        title TEXT, description TEXT, size INTEGER, posX REAL, 
                        posY REAL, time_created TEXT, frequency INTEGER)''');
    print(db.toString());
    await db.execute('''CREATE TABLE pop_record (pID INTEGER PRIMARY KEY AUTOINCREMENT, 
                        bID INTEGER NOT NULL, time_popped TEXT NOT NULL, action TEXT, 
                        FOREIGN KEY (bID) REFERENCES bubble(bID))''');
    print(db.toString());
  }

  /**
   * inserts value used to make a new bubble into the bubble db
   * @return true: successfully updated db
   * @return false: error thrown
   */
  Future<bool> enterBubbleUpdate(String _entry, String _description, String _color, int _size, double _perX, double _perY) async
  {
    Database db = await instance.database;
    try
    {
      await db.rawInsert(sprintf('''INSERT INTO bubble (title, description, size, posX, posY, time_created, frequency) 
                                  VALUES (?, ?, ?, ?, ?, ?, ?)''', 
                                  [_entry, _description, _size, _perX, _perY, 'now', 1])); 
    }
    catch (e) { print(e); return false; }
    return true;
  }

  /**
   * Inserts value into the pop_bubble
   * @param bID : bubble ID that was popped
   * @return true: suceessfully updated db
   * @return false: error thrown
   */
  Future<bool> enterPopUpdate(int bID) async
  {
    Database db = await instance.database;
    try
    { 
      await db.rawInsert('''INSERT INTO pop_record (bID, time_popped, action)
                            VALUES (?, ?, ?)''',
                            [bID, "Now", "Popped"]); 
    }
    catch (e) { print(e); return false; }
    return true;
  }
}

/**class DB
{
  var _currQueryFile;  //will be assigned to txt file of current query
  String _currQuery;   //Holds the string of the query

  var _path;          //Path to the current database in the phone
  Database _db;       //Database variable
  //Database _bubble;   //bubble datatable
  //Database _pop;      //pop_record datatable

  /**
   * Constructor
   *  tries to open the database
   *  catches an error and creates it
   */
  DB()
  {
    getDBPath();
    print(_path);
    try{openDB(); }  
    catch (e) { createDB(); openDB(); }
  }

  /**
   * sets the path to the mobiles data base to be used throughout
   * must be held in a sperate method for async programming
   */
  void getDBPath() async { _path = await getDatabasesPath(); }

  /**
   * Opens the database
   * sets the _bubble and _pop_record table vars
   */
  void openDB() async
  {
    try{ _db = await openDatabase(join(_path, 'bubl.db')); }
    catch (e) {throw e; } //On return here, no tables for bubble or pop
  }

  /**
   * Sets the current SQL script
   */
  void setSQL(String file)
  {
    _currQueryFile = new File(file);
    _currQuery = _currQueryFile.readAsString();
    _currQueryFile.close();
  }

  /**
   * Creates the database and corresponding bubble, pop_record tables
   * Called for first time users only
  */
  void createDB() async
  {
    //reads in the text query file for creating the bubble table
    setSQL('create_bubble.txt');
    //Open up the path to the data base, curr DB = bubble
    Database db = await openDatabase(join(_path, 'bubl.db'), version: 1,
      onCreate: (Database d, int version) async { await d.execute(_currQuery); });

    //reads in the text query file for creating the pop_record table
    setSQL('create_pop_record.txt');
    Database db2 = await openDatabase(join(_path, 'bubl.db'), version: 1,
      onCreate: (Database d, int version) async { await d.execute(_currQuery); });
  }

  /**
   * inserts value used to make a new bubble into the bubble db
   * @return true: successfully updated db
   * @return false: error thrown
   */
  Future<bool> enterBubbleUpdate(String _entry, String _description, Color _color, int _size, double _perX, double _perY) async
  {
    //reads in the text query file for creating the updating the bubble table
    setSQL('update_bubble.txt');

    //tries to run the query to insert a new bubble, formats the strings based on params
    try { await _db.execute(sprintf(_currQuery, [_entry, _description, _color, _size, _perX, _perY])); }
    catch (e) { return false; }
    return true;
  }

  /**
   * Inserts value into the pop_bubble
   * @param bID : bubble ID that was popped
   * @return true: suceessfully updated db
   * @return false: error thrown
   */
  Future<bool> enterPopUpdate(int bID) async
  {
    //reads in the text query file for creating the bubble table
    setSQL('updated_pop.txt');

    try{ await _db.execute(_currQuery); }
    catch (e) { return false; }
    return true;
  }

  /**
   * Returns the bubble for querying the database
   * @param title: title of the bubble
   * @param desc: description of the bubble
   * @return results.first : first row from the query
   */
  Future<Map<String, dynamic>> getBubbleByNameQuery(String title, String desc) async
  {
    //reads in the text query file: query bubble for specific bubble
    setSQL('query_specific_bubble.txt');

    try { return (await _db.rawQuery(_currQuery)).first; } //run a raw query from the txt file
    //return the first (and hopefully only result)
    catch (e) {} //Error thrown
  }

  /**
   * Returns the bubble from queying using a specific bID
   * @param bID : bID of the bubble
   * @return results.first : first row from the query
   */
  Future<Map<String, dynamic>> getBubbleByIDQuery(int bID) async
  {
    //reads in the text query file: query bubble for specific bubble
    setSQL('query_specific_bubble.txt');

    try { return (await _db.rawQuery(_currQuery)).first; } //run a raw query from the txt file
    //return the first (and hopefully only result)
    catch (e) {} //Error thrown
  }

  /**
   * Returns the pop_record for the corresponding bubble
   * Queries for all records matching the param
   * @param bID : bubble id
   * @return results : raw query data of all matching bubbles
   *    SORTED IN DESC time order
   */
  Future<List<Map<String, dynamic>>> getPopQuery(int bID) async
  {
    //reads in the text query file: query pop_record_by_bubble
    setSQL('query_pop_record_by_bubble.txt');

    try{ return await _db.rawQuery(_currQuery); }
    catch (e) {}
  }

  /**
   * grabs all the current active bubble, that arent deleted for the repopluation
   * no order, just grabs the first few bubble rows for repopulations
   * @param limit: amount of bubbles to return
   * @return results: all results grabbed from this query
   */
  Future<List<Map<String, dynamic>>> getBubblesForRepopulationQuery(int limit) async
  {
    //reads in the text query file
    setSQL('query_all_bubbles_for_repulation');

    try{ return await _db.rawQuery(_currQuery); }
    catch (e) {}

  }

  /**
   * Queries for all the bubbles for the list view
   * Ony grabs all the non_deleted bubbles
   * DEFAULTS TO DESC order (for now)
   * @param orderBy : column to order by
   * @return results: all results grabbed from the query
   */
  Future<List<Map<String, dynamic>>> getAllBubblesByQuery(dynamic orderBy) async
  {
    //reads in the text query file: query pop_record_by_bubble
    setSQL('query_all_bubbles_by.txt');

    try { return await _db.rawQuery(_currQuery); }
    catch (e) {} 
  }

  /**
   * @return _bubble, bubble db 
   */
  Database getBubble() {return _db; }

  /**
   * @return DataBase Obj  
   */
  DB getDB() {return this; }
}
*/


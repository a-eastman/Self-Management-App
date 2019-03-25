/* *
 * Runs the SQLite database behind flutter
 * @version 1.1: initialize the database, uses file I/O to hold SQL queries
 * @author Martin Price
 * @date March 2019
 * 
 * @TODO : DART String formatting
 */

import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
//import 'package:sprintf/sprintf.dart';
import 'package:path/path.dart';
import 'dart:async';
import 'dart:io';

class DataBase
{
  var _currQueryFile;  //will be assigned to txt file of current query
  String _currQuery;   //Holds the string of the query

  var _path;          //Path to the current database in the phone
  Database _db;       //Database variable
  Database _bubble;   //bubble datatable
  Database _pop;      //pop_record datatable
  
  /* *
   * Constructor
   *  tries to open the database
   *  catches an error and creates it
   */
  DataBase()
  {
    getDBPath();
    try{openDB(); }  
    catch (e) { createDB(); openDB(); }
  }

  /* *
   * sets the path to the mobiles data base to be used throughout
   * must be held in a sperate method for async programming
   */
  void getDBPath() async { _path = await getDatabasesPath(); }

  /* *
   * Opens the database
   * sets the _bubble and _pop_record table vars
   */
  void openDB() async
  {
    try
    {
      _bubble = await openDatabase(join(_path, 'bubble.db'));
      _pop = await openDatabase(join(_path, 'pop_record.db'));
    }
    catch (e) {throw e;} //On return here, no tables for bubble or pop
  }

  /* *
   * Sets the current SQL script
   */
  void setSQL(String file)
  {
    _currQueryFile = new File(file);
    _currQuery = _currQueryFile.readAsString();
    _currQueryFile.close();
  }

  /* * 
   * Creates the database and corresponding bubble, pop_record tables
   * Called for first time users only
  */
  void createDB() async
  {
    //reads in the text query file for creating the bubble table
    setSQL('create_bubble.txt');
    //Open up the path to the data base, curr DB = bubble
    Database db = await openDatabase(join(_path, 'bubble.db'), version: 1,
      onCreate: (Database d, int version) async { await d.execute(_currQuery); });

    //reads in the text query file for creating the pop_record table
    setSQL('create_pop_record.txt');
    Database db2 = await openDatabase(join(_path, 'pop_record.db'), version: 1,
      onCreate: (Database d, int version) async { await d.execute(_currQuery); });
  }

  /* *
   * inserts value used to make a new bubble into the bubble db
   * @return true: successfully updated db
   * @return false: error thrown
   */
  Future<bool> enterBubbleUpdate(String _entry, String _description, Color _color, double _size, double _perX, double _perY) async
  {
    //reads in the text query file for creating the updating the bubble table
    setSQL('update_bubble.txt');

    //tries to run the query to insert a new bubble, formats the strings based on params
    try { await _bubble.execute(_currQuery); }
    catch (e) { return false; }
    return true;
  }

  /* *
   * Inserts value into the pop_bubble
   * @param bID : bubble ID that was popped
   * @return true: suceessfully updated db
   * @return false: error thrown
   */
  Future<bool> enterPopUpdate(int bID) async
  {
    //reads in the text query file for creating the bubble table
    setSQL('updated_pop.txt');

    try{ await _pop.execute(_currQuery); }
    catch (e) { return false; }
    return true;
  }

  /* *
   * Returns the bubble for querying the database
   * @param title: title of the bubble
   * @param desc: description of the bubble
   * @return results.first : first row from the query
   */
  Future<Map<String, dynamic>> getBubbleByNameQuery(String title, String desc) async
  {
    //reads in the text query file: query bubble for specific bubble
    setSQL('query_specific_bubble.txt');

    try { return (await _bubble.rawQuery(_currQuery)).first; } //run a raw query from the txt file 
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

    try { return (await _bubble.rawQuery(_currQuery)).first; } //run a raw query from the txt file 
    //return the first (and hopefully only result)
    catch (e) {} //Error thrown
  }

  /* *
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

    try{ return await _pop.rawQuery(_currQuery); }
    catch (e) {}
  }

  /* *
   * grabs all the current active bubble, that arent deleted for the repopluation
   * no order, just grabs the first few bubble rows for repopulations
   * @param limit: amount of bubbles to return
   * @return results: all results grabbed from this query
   */
  Future<List<Map<String, dynamic>>> getBubblesForRepopulationQuery(int limit) async
  {
    //reads in the text query file
    setSQL('query_all_bubbles_for_repulation');

    try{ return await _pop.rawQuery(_currQuery); }
    catch (e) {}

  }

  /* *
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

    try { return await _bubble.rawQuery(_currQuery); }
    catch (e) {} 
  }

  /* *
   * @return _bubble, bubble db 
   */
  Database getBubble() {return _bubble; }

  /* *
   * @return _pop, pop_record db 
   */
  Database getPop() {return _pop; }

  /* *
   * @return DataBase Obj  
   */
  DataBase getDB() {return this; }
}

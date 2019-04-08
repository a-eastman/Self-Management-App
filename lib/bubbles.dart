import 'package:flutter/material.dart';
import 'package:bubl/database.dart';

//Bubble class
class Bubble{
  String _entry; //The title of the task to be displayed
  String _description; //Description of task
  Color _color;
  double _size; //current size of the bubble (0=small, 1=medium, 2=large, 3=xl)
  int _sizeIndex; //index to access sizes list
  bool _pressed; //Keeps track if the bubble is in a pressed state
  int _numPressed; //How many times the bubble has been pressed
  double _xPos; // x screen position
  double _yPos; // y screen position
  int _numBehind; //How many bubbles are behind current bubble
  int _numInfront; //How many bubbles are in front of current bubble
  double _opacity; //current opacity of the bubble
  double _orgOpacity; //The original opacity of the bubble
  bool _shouldDelete; //If the bubble is set to delete or not
  int _bubbleID;

  //STATIC VARS
  static final String _defEntry = "Entry";
  static final String _defDesc = "Description";
  static final Color _defColor = Colors.blue;
  static final bool _defPressed = true;
  static final double _defX = 0.5;
  static final double _defY = 0.5;
  static final double _defOpacity = 1.0;
  static final double _greatestOpacity = 1.0;
  static final double _leastOpacity = 0.0;
  static final int _defNumPressed = 0;
  static final int _defBehind = 0;
  static final int _defInfront = 0;
  static final List<double> _sizes = [50.0, 100.0, 150.0, 225.0];

  static final int _newBubbleID = 0;
  //Database variable
  final db = DB.instance;

  Bubble(String _entry, String _description, Color _color, int _sizeIndex, bool _pressed, double _xPos, double _yPos, double _orgOpacity){
    this._entry = _entry;
    this._description =_description;
    this._color = _color;
    this._sizeIndex = _sizeIndex;
    this._size = _sizes[_sizeIndex];
    this._pressed = true;
    this._numPressed = _defNumPressed; //Initially 0
    this._xPos = _xPos;
    this._yPos = _yPos;
    this._numBehind = _defBehind; //This will be checked and updated every build with the widgets
    this._numInfront = _defInfront; //Will be checked and updated every build with the widgets

    //verify opacity is between 0.0 and 1.0
    if (_orgOpacity > _greatestOpacity){
      _orgOpacity = _greatestOpacity;
    }
    else if (_orgOpacity < _leastOpacity){
      _orgOpacity =_leastOpacity;
    }
    this._orgOpacity = _orgOpacity;
    this._opacity = _orgOpacity; //Will be updated based off of number of
                                 // overlapping bubbles, set to 1.0 by default
    this._shouldDelete = false;

    //when this bubble is created, inserts new values into the database
    db.insertBubble(_entry, _description, _color.red, _color.green, _color.blue,
        _opacity, _sizeIndex, _xPos, _yPos);
    setBubbleID();
  }

  //Default Bubble constructor, sets all values to default values
  Bubble.defaultBubble() {
    this._entry = _defEntry;
    this._description =_defDesc;
    this._color =_defColor;
    this._sizeIndex = 1;
    this._size =_sizes[_sizeIndex];
    this._pressed =_defPressed;
    this._numPressed =_defNumPressed;
    this._xPos = _defX;
    this._yPos = _defY;
    this._numBehind =_defBehind;
    this._numInfront =_defInfront;
    this._orgOpacity = _defOpacity;
    this._opacity =_defOpacity;
    this._shouldDelete = false;

    //when this bubble is created, inserts new values into the database
    db.insertBubble(_entry, _description, _color.red, _color.green, _color.blue,
        _opacity, _sizeIndex, _xPos, _yPos);
    setBubbleID();
  }

  ///@author Martin Price
  ///This constructor is used for reading in pre-created bubbles for
  ///re-population from the database
  ///@version 1.1
  Bubble.BubbleFromDatabase(int _bID, String _entry, String _description,
      Color _color, int _sizeIndex, double _xPos, double _yPos,
      double _orgOpacity, int times_popped)
  {
    this._bubbleID = _bID;
    this._entry = _entry;
    this._description = _description;
    this._color = _color;
    this._sizeIndex = _sizeIndex;
    this._size = _sizes[_sizeIndex];
    this._pressed = true;
    this._numPressed = times_popped; //Initially 0
    this._xPos = _xPos;
    this._yPos = _yPos;
    this._numBehind =
        _defBehind; //This will be checked and updated every build with the widgets
    this._numInfront =
        _defInfront; //Will be checked and updated every build with the widgets
    //verify opacity is between 0.0 and 1.0
    if (_orgOpacity > _greatestOpacity) {
      _orgOpacity = _greatestOpacity;
    }
    else if (_orgOpacity < _leastOpacity) {
      _orgOpacity = _leastOpacity;
    }
    this._orgOpacity = _orgOpacity;
    this._opacity =
        _orgOpacity; //Will be updated based off of number of overlapping bubbles, set to 1.0 by default
    this._shouldDelete = false;
  }

  ///calls and finds the last created bubble for its bubble id
  ///@author Martin Price
  void setBubbleID() async
  { this._bubbleID = await db.queryLastCreatedBubbleID(); }

  int getBubbleID()
  { return _bubbleID; }

  bool getPressed(){
    return !this._pressed;
  }

  ///Last Edit Martin
  ///If after changed, _pressed is false -> bubble was popped
  void changePressed(){
    _pressed = !_pressed;
    if(getPressed()){
      db.insertPop(this._bubbleID);
      db.updateBubbleTimesPopped(this._bubbleID);
      increment();
    }
    else
      db.undoPop(this._bubbleID);
    _queryDBs();
  }

  void setPopState(){
    if (getPressed()){
      _opacity = 0.0;
    }
    else{
      _opacity =_orgOpacity;
    }
  }

  int getSizeIndex(){
    return this._sizeIndex;
  }

  //Increments the value of _numPressed
  void increment(){
    _numPressed++;
  }

  // For testing purposes only!
  void testIncrement(){
    _numPressed++;
  }

  int getNumPressed(){
    return _numPressed;
  }

  String getEntry(){
    return this._entry;
  }

  String getDescription(){
    return this._description;
  }

  Color getColor(){
    return this._color;
  }

  double getSize(){
    return this._size;
  }

  double getXPos(){
    return this._xPos;
  }

  double getYPos(){
    return this._yPos;
  }

  double getOpacity(){
    return this._opacity;
  }

  double getOrgOpacity(){
    return this._orgOpacity;
  }

  bool getShouldDelete(){
    return this._shouldDelete;
  }

  void setEntry(String newEntry){
    this._entry = newEntry;
    updateTitle(_bubbleID, newEntry);
  }

  void setDescription(String nDesc){
    this._description = nDesc;
    updateDesc(_bubbleID, nDesc);
  }

  void setColor(Color nColor){
    this._color = nColor;
    updateColor(_bubbleID, nColor);
  }

  //Changes the size of the bubble
  void nextSize(){
    print("nextSize");
    this._sizeIndex++;
    print("HERE");
    if(_sizeIndex >= _sizes.length){
      this._sizeIndex = 0;
    }
    //print("INDEX" + _sizeIndex.toString());
    this._size = _sizes[_sizeIndex];
  }
  void setSize(int nIndex){
    if (nIndex >= _sizes.length){
      nIndex = _sizes.length-1;
    }
    else if (nIndex < 0){
      nIndex = 0;
    }
    this._sizeIndex = nIndex;
    this._size = _sizes[_sizeIndex];
    updateSize(_bubbleID, nIndex);
  }

  //Changes the X position
  void changeXPos(double newXPos, double screenWidth){
    if ((newXPos + this._size) > screenWidth){
      newXPos = screenWidth - this._size;
    }
    else if(newXPos < 3.0){ //TODO: update to use screen constraint
      newXPos = 3.0;
    }
    this._xPos = newXPos;
    updateXPos(_bubbleID, newXPos);
  }
  //Changes the Y position
  void changeYPos(double newYPos, double screenHeight){
    if ((newYPos + this._size) > screenHeight){
      newYPos = screenHeight - this._size;
    }
    else if(newYPos < 3.0){ //TODO: update to use screen constraint
      newYPos = 3.0;
    }
    this._yPos = newYPos;
    updateYPos(_bubbleID, newYPos);
  }

  //Changes the opacity (0.0 to 1.0)
  void changeOpacity(double newOp){
    if (newOp > _greatestOpacity){
      newOp = _greatestOpacity;
    }
    else if (newOp < _leastOpacity){
      newOp = _leastOpacity;
    }
    this._opacity = newOp;
  }

  //Methods to change number of Bubbles behind
  void incrementBehind(){
    this._numBehind++;
  }
  void decrementBehind(){
    this._numBehind--;
  }
  void changeBehind(int newNumBehind){
    this._numBehind = newNumBehind;
  }

  //Methods to change number of Bubbles in front
  void incrementInfront(){
    this._numInfront++;
  }
  void decrementInfront(){
    this._numInfront--;
  }
  void changeInfront(int newNumInfront){
    this._numInfront = newNumInfront;
  }

  void setToDelete(){
    this._shouldDelete = true;
    updateDeleted(_bubbleID, 1);
  }

  bool equals(Bubble b)
  { return b.getBubbleID() == this._bubbleID; }

///Database getters
///@author Martin Price
///@date March 2019
  ///Queries the enitre bubble data table
  ///@param bID : the bubble ID that is being looked for
  ///@param columnID : the column or attribute to return
  ///@return the attribute
  Future<dynamic> queryBubble(int bID, List<String> columnID) async
  {
    Map<String, dynamic> result = await db.queryBubbleByID(bID, columnID);
    return result[columnID[0]];
  }
  dynamic queryTitle(int bID)
  { return queryBubble(bID, ['title']); }
  dynamic queryDesc(int bID)
  { return queryBubble(bID, ["description"]); }
  dynamic querySize(int bID)
  { return queryBubble(bID, ["size"]); }
  dynamic queryXPos(int bID)
  { return queryBubble(bID, ["posX"]); }
  dynamic queryYPos(int bID)
  { return queryBubble(bID, ["posY"]); }
  dynamic queryTimeCreated(int bID)
  { return queryBubble(bID, ["time_created"]); }
  bool queryDeleted(int bID)
  // ignore: unrelated_type_equality_checks
  { return queryBubble(bID, ["deleted"]) == 0; }
  dynamic queryFrequency(int bID)
  { return queryBubble(bID, ["frequency"]); }
  Future<Color> queryColor(int bID) async
  {
    final colors = await db.queryBubbleByID(bID, ["color_red", "color_green",
    "color_blue", "opacity"]);
    return new Color.fromRGBO(colors["color_red"],colors["color_green"],
        colors["color_blue"], colors["opacity"]);
  }

  ///Queries pop_record
  ///@param bID: bubble to grab
  Future<dynamic> queryPop(int bID, List<String> columns) async
  {
    return db.queryPop();
  }

///Database Setters
///@author Martin Price
///@date March 2019
  ///Updates the bubble table
  ///@param bID: bubble to update
  ///@param columnID : bubble attribute to update
  ///@param value: new value
  Future<int> updateBubble(int bID, Map<String, dynamic> row) async
  { return await db.updateBubbleByID(bID, row); }

  void updateTitle(int bID, String value)
  { updateBubble(bID, {"title":value}); }
  void updateDesc(int bID, String value)
  { updateBubble(bID, {"description":value}); }
  void updateSize(int bID, int value)
  { updateBubble(bID, {'size':value}); }
  void updateXPos(int bID, double value)
  { updateBubble(bID, {"posX":value}); }
  void updateYPos(int bID, double value)
  { updateBubble(bID, {"posY":value}); }
  void updateDeleted(int bID, int value)
  { updateBubble(bID, {"deleted":value}); }
  updateFrequency(int bID, int value)
  { updateBubble(bID, {"frequency":value});}
  updateColor(int bID, Color value)
  { updateBubble(bID, { "color_red": value.red,
    "color_green": value.green,
    "color_blue": value.blue,
    "opacity": value.opacity });
  }

  String toString()
  { return "$_bubbleID $_entry $_description"; }

  ///DEV Testing Only
  ///Used by Martin for DB testing
  void _queryDBs() async
  {
    print('Printing out bubl table:');
    final bubl = await db.queryBubble();
    try{ bubl.forEach((row) => print(row)); }
    catch(e) {print(e); }

    print('Printing out pop_record table:');
    final pop = await db.queryPop();
    try{ pop.forEach((row) => print(row)); }
    catch(e) {print(e); }
  }
}

//A BubblesList class, used to wrap the Bubbles in so that
// pass by reference can be simulated
class BubblesList {
  final db = DB.instance;
  List<Bubble> _myList; //List of bubbles
  int _numBubbles; //Number of bubbles in list

  BubblesList.newEmptyBubbleList() {
    _myList = []; //Sets an empty list
    this._numBubbles = 0; //Initial size is 0
  }

  ///Default Contrustor that calls the database for populating bubbles
  ///@author Martin Price
  BubblesList()
  {
    try{ populateBubbles();}
    catch(e) {BubblesList.newEmptyBubbleList();}
  }

  ///Queries the database for bubbles to be repopulated
  ///@return bubbles : a populated list of bubbles
  ///@return [] : error or no bubbles
  ///@author Martin Price
  Future<List<Bubble>> populateBubbles() async
  {
    this._numBubbles = 0;
    this._myList = [];
    final results = await db.queryBubblesForRePop();
    results.forEach((y) => {
      addBubble(new Bubble.BubbleFromDatabase(y['bID'],y['title'],y['description'],
          new Color.fromRGBO(y['color_red'],y['color_green'],
              y['color_blue'],y['opacity']),
          y['size'], y['posX'], y['posX'], y['opacity'], y['times_popped'])),
      });
    print('# of bubbles on Start-up $_numBubbles');
  }

  ///Contructor used to gather bubbles that have not been popped yet today
  BubblesList.unpoppedBubbles()
  {
    try{ unpoppedBubbles(); }
    catch (e) {BubblesList.newEmptyBubbleList(); }
  }

  ///Queries the database for bubbles that have not been popped today
  ///@return bubbles : a populated list of bubbles that have NOT been popped
  ///@author Martin Price 
  Future<List<Bubble>> unpoppedBubbles() async
  {
    this._numBubbles = 0;
    this._myList = [];
    final results = await db.queryBubblesForRePop();
    for(var y in results)
    {
      bool valid = await db.queryPopForRecent(y['bID']);
      if(valid)
      {
        addBubble(new Bubble.BubbleFromDatabase(y['bID'],y['title'],y['description'],
          new Color.fromRGBO(y['color_red'],y['color_green'], y['color_blue'],y['opacity']),
          y['size'], y['posX'], y['posX'], y['opacity'], y['times_popped']));
      }
      else
      {
        addBubble(new Bubble.BubbleFromDatabase(y['bID'],y['title'],y['description'],
          new Color.fromRGBO(y['color_red'],y['color_green'], y['color_blue'],y['opacity']),
          y['size'], y['posX'], y['posX'], y['opacity'], y['times_popped']));
        _myList[_numBubbles-1].changePressed();
      }
    }
  }

  List<Bubble> getList() {
    return _myList;
  }

  int getSize() {
    return _numBubbles;
  }

  Bubble getBubbleAt(int i) {
    return _myList[i];
  }

  //Adds a bubble to the end of _myList

  void addBubble(Bubble b) {
    _myList.add(b);
    _numBubbles++;
    // _myList.add(b);
  }

  //Deletes a bubble at index i

  void removeBubbleAt(int i) {
    _myList.removeAt(i);

    _numBubbles--;
  }

  //Changes the Pressed State of bubble at index i in _myList

  void changeElementPressed(int i) {
    _myList[i].changePressed();
  }

  //Sets the current list to the settings of another BubblesList

  void setTo(BubblesList nList) {
    _myList = nList.getList();

    _numBubbles = nList.getSize();
  }

  //Returns a list of filled coordinates (XPerc, YPerc)

  List<List<double>> getFilledPos() {
    List<List<double>> fillers;

    List<double> currPos;

    for (int i = 0; i < _numBubbles; i++) {
      currPos = [_myList[i].getXPos(), _myList[i].getYPos()];

      fillers.add(currPos);
    }

    return fillers;
  }

  //Sorts with the largest size first
  void orderBubbles(){
    _myList.sort((a, b) => b.getSize().compareTo(a.getSize()));
  }

  ///Removes the bubble that was popped
  ///First finds the bubbles position in the list
  ///then calls removeBubbleAt
  void removePoppedBubble(Bubble b)
  {
    for(int i = 0; i < _numBubbles; i++) {
      if (getBubbleAt(i).equals(b)) {
        removeBubbleAt(i);
        return;
      }
    }
  }

  ///Prints out the bubbles list
  void toString2()
  {
    for(int i = 0; i < _numBubbles; i++)
      print(getBubbleAt(i).toString());
  }
}

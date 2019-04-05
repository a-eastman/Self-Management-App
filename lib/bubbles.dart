import 'package:flutter/material.dart';

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

  bool repeat;
  bool repeatMonday;
  bool repeatTuesday;
  bool repeatWednesday;
  bool repeatThursday;
  bool repeatFriday;
  bool repeatSaturday;
  bool repeatSunday;

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

  Bubble(String _entry, String _description, Color _color, int _sizeIndex,
      bool _pressed, double _xPos, double _yPos, double _orgOpacity){
    this._entry = _entry;
    this._description =_description;
    this._color = _color;

    this._sizeIndex = _sizeIndex;
    this._size = _sizes[_sizeIndex];
    this._pressed = _pressed;
    this._numPressed = _defNumPressed; //Initially 0

    this._xPos = _xPos;
    this._yPos = _yPos;

    this._numBehind = _defBehind; //This will be checked and updated every
                                  // build with the widgets
    this._numInfront = _defInfront; //Will be checked and updated every
                                    // build with the widgets

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

    repeat = false;
    repeatMonday = false;
    repeatTuesday =false;
    repeatWednesday =false;
    repeatThursday =false;
    repeatFriday =false;
    repeatSaturday =false;
    repeatSunday =false;
  }

  //Default Bubble constructor, sets all values to default values
  Bubble.defaultBubble(){
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
    repeat = false;
    repeatMonday = false;
    repeatTuesday =false;
    repeatWednesday =false;
    repeatThursday =false;
    repeatFriday =false;
    repeatSaturday =false;
    repeatSunday =false;
  }


  bool getRepeat(){
    return repeat;
  }

  void changeRepeat(){
    repeat = !repeat;
  }

  void setRepeat(bool r){
    repeat = r;
  }

  bool getRepeatDay(String day){
    bool result = true;
    switch(day) {
      case "Mon": {result = repeatMonday;}
      break;
      case "Tue": {result = repeatTuesday;}
      break;
      case "Wed": {result = repeatWednesday;}
      break;
      case "Thu": {result = repeatThursday;}
      break;
      case "Fri": {result = repeatFriday;}
      break;
      case "Sat": {result = repeatSaturday;}
      break;
      case "Sun": {result = repeatSunday;}
      break;
    }
    return result;
  }

  void changeRepeatDay(String day){
    switch(day) {
      case "Mon": {repeatMonday = !repeatMonday;}
      break;
      case "Tue": {repeatTuesday = !repeatTuesday;}
      break;
      case "Wed": {repeatWednesday = !repeatWednesday;}
      break;
      case "Thu": {repeatThursday = !repeatThursday;}
      break;
      case "Fri": {repeatFriday = !repeatFriday;}
      break;
      case "Sat": {repeatSaturday = !repeatSaturday;}
      break;
      case "Sun": {repeatSunday = !repeatSunday;}
      break;
    }
  }

  void setRepeatDay(String day, bool repeat){
    switch(day) {
      case "Mon": {repeatMonday = repeat;}
      break;
      case "Tue": {repeatTuesday = repeat;}
      break;
      case "Wed": {repeatWednesday = repeat;}
      break;
      case "Thu": {repeatThursday = repeat;}
      break;
      case "Fri": {repeatFriday = repeat;}
      break;
      case "Sat": {repeatSaturday = repeat;}
      break;
      case "Sun": {repeatSunday = repeat;}
      break;
    }
  }

  bool getPressed(){
    return this._pressed;
  }
  void changePressed(){
    _pressed = !_pressed;
    increment();
  }

  void setPopState(){
    if (!_pressed){
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
    if(_pressed == false){
      _numPressed++;
    }
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
  }

  void setDescription(String nDesc){
    this._description = nDesc;
  }

  void setColor(Color nColor){
    this._color = nColor;
  }

  //Changes the size of the bubble
  void nextSize(){
    print("nextSize");
    this._sizeIndex++;
    print("HERE");
    if(_sizeIndex >= _sizes.length){
      this._sizeIndex = 0;
    }
    print("INDEX" + _sizeIndex.toString());
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
  }
}

//A BubblesList class, used to wrap the Bubbles in so that
// pass by reference can be simulated
class BubblesList {
  List<Bubble> _myList; //List of bubbles

  int _numBubbles; //Number of bubbles in list

  BubblesList() {
    _myList = []; //Sets an empty list

    this._numBubbles = 0; //Initial size is 0
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
}

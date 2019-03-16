import 'package:flutter/material.dart';

//Bubble class
class Bubble{
  String _entry; //The title of the task to be displayed
  String _description; //Description of task
  Color _color;
  double _size; //Priority/size of the bubble (0.0 to 1.0)
  bool _pressed; //Keeps track if the bubble is in a pressed state
  int _numPressed; //How many times the bubble has been pressed
  double _xPos; // x screen position
  double _yPos; // y screen position
  int _numBehind; //How many bubbles are behind current bubble
  int _numInfront; //How many bubbles are in front of current bubble
  double _opacity; //current opacity of the bubble
  double _orgOpacity; //The original opacity of the bubble

  //STATIC VARS
  static final String _defEntry = "Entry";
  static final String _defDesc = "Description";
  static final Color _defColor = Colors.blue;
  static final bool _defPressed = true;
  static final double _defX = 0.5;
  static final double _defY = 0.5;
  static final double _perXConstraintMax = 0.9; //TODO: Update Value
  static final double _perYConstraintMax = 0.9; //TODO: Update Value
  static final double _perXConstraintMin = 0.1; //TODO: Update Value
  static final double _perYConstraintMin = 0.05; //TODO: Update Value
  static final double _sizeConstraintMax = 200.0; //TODO: UPDATE VALUE
  static final double _sizeConstraintMin = 30.0; //TODO: UPDATE VALUE
  static final double _defSize = (_sizeConstraintMax + _sizeConstraintMin) / 2.0;
  static final double _defOpacity = 1.0;
  static final double _greatestOpacity = 1.0;
  static final double _leastOpacity = 0.0;
  static final int _defNumPressed = 0;
  static final int _defBehind = 0;
  static final int _defInfront = 0;

  Bubble(String _entry, String _description, Color _color, double _size, bool _pressed, double _xPos, double _yPos, double _opacity){
    this._entry = _entry;
    this._description =_description;
    this._color = _color;
    
    //sets the size constraint
    if (_size > _sizeConstraintMax){
      _size = _sizeConstraintMax;
    }
    else if (_size < _sizeConstraintMin){
      _size = _sizeConstraintMin;
    }
    this._size = _size;
    this._pressed = _pressed;
    this._numPressed = _defNumPressed; //Initially 0

    this._xPos = _xPos;
    this._yPos = _yPos;

    this._numBehind = _defBehind; //This will be checked and updated every build with the widgets
    this._numInfront = _defInfront; //Will be checked and updated every build with the widgets

    //verify opacity is between 0.0 and 1.0
    if (_opacity > _greatestOpacity){
      _opacity = _greatestOpacity;
    }
    else if (_opacity < _leastOpacity){
      _opacity =_leastOpacity;
    }
    this._opacity = _opacity; //Will be updated based off of number of overlapping bubbles, set to 1.0 by default
  }

  //Default Bubble constructor, sets all values to default values
  Bubble.defaultBubble(){
    this._entry = _defEntry;
    this._description =_defDesc;
    this._color =_defColor;
    this._size =_defSize;
    this._pressed =_defPressed;
    this._numPressed =_defNumPressed;
    this._xPos = _defX;
    this._yPos = _defY;
    this._numBehind =_defBehind;
    this._numInfront =_defInfront;
    this._opacity =_defOpacity;
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
  void setSize(double newSize){
    this._size = newSize;
  }

  //Changes the X position
  void changeXPos(double newXPos){
    this._xPos = newXPos;
  }
  //Changes the Y position
  void changeYPos(double newYPos){
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
}

//A BubblesList class, used to wrap the Bubbles in so that pass by reference can be simulated 
class BubblesList{
  List<Bubble> _myList; //List of bubbles
  int _numBubbles; //Number of bubbles in list

  BubblesList(){
    _myList = []; //Sets an empty list
    this._numBubbles = 0; //Initial size is 0
  }

  List<Bubble> getList(){
    return _myList;
  }

  int getSize(){
    return _numBubbles;
  }

  Bubble getBubbleAt(int i){
    return _myList[i];
  }

  //Adds a bubble to the end of _myList
  void addBubble(Bubble b){
    _myList.add(b);
    _numBubbles++;
  }

  //Deletes a bubble at index i
  void removeBubbleAt(int i){
    _myList.removeAt(i);
    _numBubbles--;
  }

  //Changes the Pressed State of bubble at index i in _myList
  void changeElementPressed(int i){
    _myList[i].changePressed();
  }

  //Sets the current list to the settings of another BubblesList
  void setTo(BubblesList nList){
    _myList = nList.getList();
    _numBubbles = nList.getSize();
  }

  //Returns a list of filled coordinates (XPerc, YPerc)
  List<List<double>> getFilledPos(){
    List<List<double>> fillers;
    List<double> currPos;
    for (int i = 0; i < _numBubbles; i++){
      currPos = [_myList[i].getXPos(), _myList[i].getYPos()];
      fillers.add(currPos);
    }
    return fillers;
  }

  
}


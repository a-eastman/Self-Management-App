import 'package:flutter/material.dart';

//Bubble class
class Bubble{
  String _entry; //The task to be displayed
  double _priority; //Priority/size of the bubble (0.0 to 1.0)
  bool _pressed; //Keeps track if the bubble is in a pressed state
  int _numPressed; //How many times the bubble has been pressed
  int _colPos; //Which column the bubble is in
  int _rowPos; //Which row the bubble is in

  Bubble(String _entry, double _priority, bool _pressed, int _rowPos, int _colPos){
    this._entry = _entry;
    this._priority = _priority;
    if (this._priority >= 1.0){
      this._priority = 0.99;
    }
    else if (this._priority <= 0.05){
      this._priority = 0.05;
    }
    this._pressed = _pressed;
    this._numPressed = 0; //Initially
    this._rowPos =_rowPos;
    this._colPos = _colPos;
  }

  bool getPressed(){
    return this._pressed;
  }
  void changePressed(){
    _pressed = !_pressed;
    increment();
  }

  //Increments the value of _numPressed
  void increment(){
    if(_pressed == false){
     _numPressed++;
    }
  }

  int getNumPressed(){
    return _numPressed;
  }

  String getEntry(){
    return this._entry;
  }

  double getPriority(){
    return this._priority;
  }

  int getRow(){
    return this._rowPos;
  }

  int getCol(){
    return this._colPos;
  }
  
  //Changes the priority of the bubble (affects size)
  void setPriority(double newPri){
    this._priority = newPri;
  }

  //Changes the row position
  void changeRow(int r){
    this._rowPos = r;
  }
  //Changes the column position
  void changeCol(int c){
    this._colPos = c;
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

  //Returns a list of filled positions (row, col)
  List<List<int>> getFilledPos(){
    List<List<int>> fillers;
    List<int> currPos;
    for (int i = 0; i < _numBubbles; i++){
      currPos = [_myList[i].getRow(), _myList[i].getCol()];
      fillers.add(currPos);
    }
    return fillers;
  }
}
///Bubble class
///@author Caeleb Nasoff, Chris Malitsky, Martin Price, Abigail Eastman
///
///
///LAST EDIT : April 29, 2019

import 'package:flutter/material.dart';
import 'database.dart';

//Bubble class
class Bubble {
  String _entry; //The title of the task to be displayed
  String _description; //Description of task
  Color _color; //The color of the bubble.
  double _size; //current size of the bubble (0=small, 1=medium, 2=large, 3=xl)
  int _sizeIndex; //index to access sizes list
  bool _pressed; //Keeps track if the bubble is in a pressed state
  int _numPressed; //How many times the bubble has been pressed
  double _xPos; // x screen position
  double _yPos; // y screen position
  int _numBehind; //How many bubbles are behind current bubble (NOT CURRENTLY ACTUALLY USED)
  int _numInfront; //How many bubbles are in front of current bubble (NOT CURRENTLY ACTUALLY USED)
  double _opacity; //current opacity of the bubble
  double _orgOpacity; //The original opacity of the bubble
  int _bubbleID; // bID of the bubble from the DB

  bool _shouldDelete; //If the bubble is set to delete or not
  bool _dotAppear = false;
  bool _lastActionGrabbed = true;
  int _globalIndex = 0;
  int _frequency; //If the bubble repeats during the week for the DB.

  bool _repeat; //If the bubble repeats during the week.
  bool _repeatMonday; //If the bubble repeats on Monday.
  bool _repeatTuesday; //If the bubble repeats on Tuesday.
  bool _repeatWednesday; //If the bubble repeats on Wednesday.
  bool _repeatThursday; //If the bubble repeats on Thursday.
  bool _repeatFriday; //If the bubble repeats on Friday.
  bool _repeatSaturday; //If the bubble repeats on Saturday.
  bool _repeatSunday; //If the bubble repeats on Sunday.

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
  static final List<double> _sizes = [0.15, 0.2, 0.25, 0.35];

  static int _globalBubbleIndex = 0;

  //Database variable
  final db = DB.instance;

  Bubble(
      String _entry,
      String _description,
      Color _color,
      int _sizeIndex,
      bool _pressed,
      double _xPos,
      double _yPos,
      double _orgOpacity,
      int _frequency,
      bool _repeat,
      bool _repeatMonday,
      bool _repeatTuesday,
      bool _repeatWednesday,
      bool _repeatThursday,
      bool _repeatFriday,
      bool _repeatSaturday,
      bool _repeatSunday) {
    this._entry = _entry;
    this._description = _description;
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
    if (_orgOpacity > _greatestOpacity) {
      _orgOpacity = _greatestOpacity;
    } else if (_orgOpacity < _leastOpacity) {
      _orgOpacity = _leastOpacity;
    }
    this._orgOpacity = _orgOpacity;
    this._opacity = _orgOpacity; //Will be updated based off of number of
    // overlapping bubbles, set to 1.0 by default
    this._shouldDelete = false;

    this._frequency = _frequency;

    this._repeat = _repeat;
    this._repeatMonday = _repeatMonday;
    this._repeatTuesday = _repeatTuesday;
    this._repeatWednesday = _repeatWednesday;
    this._repeatThursday = _repeatThursday;
    this._repeatFriday = _repeatFriday;
    this._repeatSaturday = _repeatSaturday;
    this._repeatSunday = _repeatSunday;
    insertBubble();
  }

  //Default Bubble constructor, sets all values to default values
  Bubble.defaultBubble() {
    this._entry = _defEntry;
    this._description = _defDesc;
    this._color = _defColor;
    this._sizeIndex = 1;
    this._size = _sizes[_sizeIndex];
    this._pressed = _defPressed;
    this._numPressed = _defNumPressed;
    this._xPos = _defX;
    this._yPos = _defY;
    this._numBehind = _defBehind;
    this._numInfront = _defInfront;
    this._orgOpacity = _defOpacity;
    this._opacity = _defOpacity;
    this._shouldDelete = false;
    this._frequency = 0;
    this._repeat = false;
    this._repeatMonday = false;
    this._repeatTuesday = false;
    this._repeatWednesday = false;
    this._repeatThursday = false;
    this._repeatFriday = false;
    this._repeatSaturday = false;
    this._repeatSunday = false;

    //when this bubble is created, inserts new values into the database
    //insertBubble();
  }

  ///@author Martin Price
  ///This constructor is used for reading in pre-created bubbles for
  ///re-population from the database
  ///@version 1.1
  Bubble.BubbleFromDatabase(
      int _bID,
      String _entry,
      String _description,
      Color _color,
      int _sizeIndex,
      double _xPos,
      double _yPos,
      double _orgOpacity,
      int times_popped,
      int frequency,
      bool _repeat,
      String days) {
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
    this._numBehind = _defBehind;
    this._numInfront = _defInfront;
    //verify opacity is between 0.0 and 1.0
    if (_orgOpacity > _greatestOpacity) {
      _orgOpacity = _greatestOpacity;
    } else if (_orgOpacity < _leastOpacity) {
      _orgOpacity = _leastOpacity;
    }
    this._orgOpacity = _orgOpacity;
    this._opacity = _orgOpacity;
    this._shouldDelete = false;
    this._frequency = frequency;
    if (frequency == 1) {
      this._repeat = true;
    } else {
      this._repeat = false;
    }
    repeatFromString(days);
  }

  ///when this bubble is created, inserts new values into the database
  void insertBubble() async {
    int r = 0;
    if (this._repeat) r = 1;
    await db.insertBubble(_entry, _description, _color.red, _color.green,
        _color.blue, _opacity, _sizeIndex, _xPos, _yPos, r, repeatToString());
    await setBubbleID();
  }

  ///calls and finds the last created bubble for its bubble id
  ///@author Martin Price
  void setBubbleID() async {
    this._bubbleID = await db.queryLastCreatedBubbleID();
  }

  /// Returns the bubble's id.
  int getBubbleID() {
    return _bubbleID;
  }

  int globalIndex() => _bubbleID;

  //Empty bubble constructor marked for deletion
  Bubble.deleteBubble() {
    _globalIndex = _globalBubbleIndex++;
    _shouldDelete = true;
  }

  bool getDotAppear() => _dotAppear;

  void setDotAppear(bool dotAppear) {
    this._dotAppear = dotAppear;
  }

  bool lastActionGrabbed() => _lastActionGrabbed;

  void setLastActiongrabbed(bool lastActionGrabbed) {
    this._lastActionGrabbed = lastActionGrabbed;
  }

  /// Returns if the bubble repeats or not.
  bool getRepeat() {
    return _repeat;
  }

  ///Last update Martin Price
  ///When repeat is updated, app updates the DB.
  void changeRepeat() {
    _repeat = !_repeat;
    int value = 0;
    if (_repeat) value++;
    updateFrequency(_bubbleID, value);
    print('Updating Frequecy to $value');
  }

  ///Sets the value of the repeat variable and updates the database.
  void setRepeat(bool r) {
    _repeat = r;
    int value = 0;
    if (_repeat) value++;
    updateFrequency(_bubbleID, value);
    print('Updating Frequecy to $value');
  }

  ///Determines if the bubble repeats on the [day] entered.
  bool getRepeatDay(String day) {
    bool result = true;
    switch (day) {
      case "Mon":
        {
          result = _repeatMonday;
        }
        break;
      case "Tue":
        {
          result = _repeatTuesday;
        }
        break;
      case "Wed":
        {
          result = _repeatWednesday;
        }
        break;
      case "Thu":
        {
          result = _repeatThursday;
        }
        break;
      case "Fri":
        {
          result = _repeatFriday;
        }
        break;
      case "Sat":
        {
          result = _repeatSaturday;
        }
        break;
      case "Sun":
        {
          result = _repeatSunday;
        }
        break;
    }
    return result;
  }

  /// Changes the repeat value on the [day] entered.
  void changeRepeatDay(String day) {
    switch (day) {
      case "Mon":
        {
          _repeatMonday = !_repeatMonday;
        }
        break;
      case "Tue":
        {
          _repeatTuesday = !_repeatTuesday;
        }
        break;
      case "Wed":
        {
          _repeatWednesday = !_repeatWednesday;
        }
        break;
      case "Thu":
        {
          _repeatThursday = !_repeatThursday;
        }
        break;
      case "Fri":
        {
          _repeatFriday = !_repeatFriday;
        }
        break;
      case "Sat":
        {
          _repeatSaturday = !_repeatSaturday;
        }
        break;
      case "Sun":
        {
          _repeatSunday = !_repeatSunday;
        }
        break;
    }
    String days = repeatToString();
    updateDaysToRepeat(_bubbleID, days);
  }

  /// Sets the value of repeatability to [_repeat] on [day]
  void setRepeatDay(String day, bool _repeat) {
    switch (day) {
      case "Mon":
        {
          _repeatMonday = _repeat;
        }
        break;
      case "Tue":
        {
          _repeatTuesday = _repeat;
        }
        break;
      case "Wed":
        {
          _repeatWednesday = _repeat;
        }
        break;
      case "Thu":
        {
          _repeatThursday = _repeat;
        }
        break;
      case "Fri":
        {
          _repeatFriday = _repeat;
        }
        break;
      case "Sat":
        {
          _repeatSaturday = _repeat;
        }
        break;
      case "Sun":
        {
          _repeatSunday = _repeat;
        }
        break;
    }
    String days = repeatToString();
    updateDaysToRepeat(_bubbleID, days);
  }

  ///@return a formatted string of all Days to Repeat, stored in DB
  ///@author Martin Price
  String repeatToString() {
    String days = '';
    if (_repeatMonday) days += 'Mon|';
    if (_repeatTuesday) days += 'Tue|';
    if (_repeatWednesday) days += 'Wed|';
    if (_repeatThursday) days += 'Thu|';
    if (_repeatFriday) days += 'Fri|';
    if (_repeatSaturday) days += 'Sat|';
    if (_repeatSunday) days += 'Sun|';
    return days;
  }

  ///Determines if the bubble repeats today.
  ///If bubble is non repeating, defaults to true.
  bool repeatesToday() {
    if (!this._repeat) return true;
    int day = new DateTime.now().weekday;
    switch (day) {
      case 1:
        return this._repeatMonday;
        break;
      case 2:
        return this._repeatTuesday;
        break;
      case 3:
        return this._repeatWednesday;
        break;
      case 4:
        return this._repeatThursday;
        break;
      case 5:
        return this._repeatFriday;
        break;
      case 6:
        return this._repeatSaturday;
        break;
      case 7:
        return this._repeatSunday;
        break;
    }
  }

  ///Sets all the repeat varaibles based on the string from the DB.
  void repeatFromString(String days) {
    try {
      List<String> day = days.split("|");
      if (day.contains("Mon")) {
        _repeatMonday = true;
      } else {
        _repeatMonday = false;
      }
      if (day.contains("Tue")) {
        _repeatTuesday = true;
      } else {
        _repeatTuesday = false;
      }
      if (day.contains("Wed")) {
        _repeatWednesday = true;
      } else {
        _repeatWednesday = false;
      }
      if (day.contains("Thu")) {
        _repeatThursday = true;
      } else {
        _repeatThursday = false;
      }
      if (day.contains("Fri")) {
        _repeatFriday = true;
      } else {
        _repeatFriday = false;
      }
      if (day.contains("Sat")) {
        _repeatSaturday = true;
      } else {
        _repeatSaturday = false;
      }
      if (day.contains("Sun")) {
        _repeatSunday = true;
      } else {
        _repeatSunday = false;
      }
    } catch (e) {
      print('No days to repeat');
      _repeatMonday = false;
      _repeatTuesday = false;
      _repeatWednesday = false;
      _repeatThursday = false;
      _repeatFriday = false;
      _repeatSaturday = false;
      _repeatSunday = false;
    }
  }

  ///Determines if the bubble is pressed.
  bool getPressed() {
    return this._pressed;
  }

  ///Flips the value of the [_pressed] variable.
  void changePressed() {
    _pressed = !_pressed;
    if (!_pressed) {
      db.insertPop(this._bubbleID).then((onValue) {
        print('Successful pop');
      });
      print('Bubble $_bubbleID Popped');
      db.incrementBubbleTimesPopped(this._bubbleID).then((onValue) {
        print('Successful increment');
      });
    } else {
      db.undoPop(this._bubbleID).then((onValue) {
        print('Successful unpop');
      });
      print('Bubble $_bubbleID Unpopped');
      db.decrementBubbleTimesPopped(this._bubbleID).then((onValue) {
        print('Successful decrement');
      });
    }
    //increment();
  }

  ///Performs the same action as changePressed without updating DB
  ///@author Martin Price
  void silentPop() {
    _pressed = false;
    setPopState();
  }

  /// Determines the opacity of the bubble.
  void setPopState() {
    if (!_pressed) {
      _opacity = 0.0;
    } else {
      _opacity = _orgOpacity;
    }
  }

  ///Returns the size index of the bubble.
  int getSizeIndex() {
    return this._sizeIndex;
  }

  ///Increments the value of _numPressed.
  void increment() {
    if (_pressed == false) {
      _numPressed++;
    }
    print("PRESSED: " + _numPressed.toString());
  }

  ///Tests to see if the _numPressed increments correctly.
  void testIncrement() {
    _numPressed++;
  }

  ///Returns the number of times the bubble has been popped.
  int getNumPressed() {
    return _numPressed;
  }

  ///Returns the entry for the bubble.
  String getEntry() {
    return this._entry;
  }

  ///Returns the description.
  String getDescription() {
    return this._description;
  }

  ///Returns the color.
  Color getColor() {
    return this._color;
  }

  ///Returns the pixel size of the bubble.
  double getSize() {
    return this._size;
  }

  ///Returns the XPos of the bubble on the bubble view.
  double getXPos() {
    return _xPos > 2.0 ? .5 : _xPos;
  }

  ///Returns the YPos of the bubble on the bubble view.
  double getYPos() {
    return _yPos > 2.0 ? .5 : _yPos;
  }

  ///Returns the opacity of the bubble.
  double getOpacity() {
    return this._opacity;
  }

  ///Returns the original opacity of the bubble.
  double getOrgOpacity() {
    return this._orgOpacity;
  }

  ///Determines if the bubble should be deleted from view.
  bool getShouldDelete() {
    return this._shouldDelete;
  }

  ///Updates the entry for the bubble to [newEntry].
  void setEntry(String newEntry) {
    this._entry = newEntry;
    updateTitle(_bubbleID, newEntry);
    print('Updating Name to $newEntry');
  }

  ///Updates the description of the bubble to [nDesc].
  void setDescription(String nDesc) {
    this._description = nDesc;
    updateDesc(_bubbleID, nDesc);
    print('Updating Desc to $nDesc');
  }

  ///Updates the color of the bubble to [nColor].
  void setColor(Color nColor) {
    this._color = nColor;
    updateColor(_bubbleID, nColor);
    print('Updating Color to $nColor');
  }

  ///Changes the size of the bubble to the next in the array.
  void nextSize() {
    this._sizeIndex++;
    if (_sizeIndex >= _sizes.length) {
      this._sizeIndex = 0;
    }
    this._size = _sizes[_sizeIndex];
    updateSize(_bubbleID, _sizeIndex);
    print('Updating Size to $_sizeIndex');
  }

  ///Updates the size of the bubble to size found in array at index [nIndex].
  void setSize(int nIndex) {
    if (nIndex >= _sizes.length) {
      nIndex = _sizes.length - 1;
    } else if (nIndex < 0) {
      nIndex = 0;
    }
    this._sizeIndex = nIndex;
    this._size = _sizes[_sizeIndex];
    updateSize(_bubbleID, _sizeIndex);
    print('Updating Size to $_sizeIndex');
  }

  /// Changes the X position.
  void changeXPos(double newXPos, double actualSize, double screenWidth) {
    if ((newXPos + actualSize) > screenWidth) {
      newXPos = screenWidth - actualSize;
    } else if (newXPos < 3.0) {
      newXPos = 3.0; //A constraint that is towards the beginning of the screen on the X axis
    }

    this._xPos = (newXPos + (actualSize / 2.0)) / screenWidth;
    print("X POS: " + this._xPos.toString());
    updateXPos(_bubbleID, this._xPos);
    print('Updating X Pos to $newXPos');
    
  }

  /// Changes the Y position.
  void changeYPos(double newYPos, double actualSize, double screenHeight) {
    if ((newYPos + actualSize) > screenHeight) {
      newYPos = screenHeight - actualSize;
    } else if (newYPos < 3.0) {
      newYPos = 3.0; //A constraint that is towards the beginning of the screen on the Y axis
    }

    this._yPos = (newYPos + (actualSize / 2.0) - 80) /
        screenHeight; // App bar height is 70
    
    print("Y POS: " + this._yPos.toString());
    updateYPos(_bubbleID, this._yPos);
    print('Updating Y Pos to $newYPos');
  }

  /// Changes the opacity of a bubble
  void changeOpacity(double newOp) {
    if (newOp > _greatestOpacity) {
      newOp = _greatestOpacity;
    } else if (newOp < _leastOpacity) {
      newOp = _leastOpacity;
    }
    this._opacity = newOp;
  }

  /// Increment the number of bubbles behind.
  void incrementBehind() {
    this._numBehind++;
  }

  /// Decrement the number of bubbles behind.
  void decrementBehind() {
    this._numBehind--;
  }

  /// Change the number of bubbles behind this bubble.
  void changeBehind(int newNumBehind) {
    this._numBehind = newNumBehind;
  }

  /// Increment the number of bubbles in front of this bubble.
  void incrementInfront() {
    this._numInfront++;
  }

  /// Decrement the number of bubbles in front of this bubble.
  void decrementInfront() {
    this._numInfront--;
  }

  /// Change the number of bubbles in front of this bubble.
  void changeInfront(int newNumInfront) {
    this._numInfront = newNumInfront;
  }

  /// Mark that this bubble should be deleted.
  void setToDelete() {
    this._shouldDelete = true;
    db.insertDelete(_bubbleID);
  }

  /// Check to see if another bubble matches this bubble's id.
  bool equals(Bubble b) {
    return b.getBubbleID() == this._bubbleID;
  }

  ///Database getters
  ///@author Martin Price
  ///@date March 2019
  ///Queries the enitre bubble data table
  ///@param bID : the bubble ID that is being looked for
  ///@param columnID : the column or attribute to return
  ///@return the attribute
  Future<dynamic> queryBubble(int bID, List<String> columnID) async {
    Map<String, dynamic> result = await db.queryBubbleByID(bID, columnID);
    return result[columnID[0]];
  }

  dynamic queryTitle(int bID) {
    return queryBubble(bID, ['title']);
  }

  dynamic queryDesc(int bID) {
    return queryBubble(bID, ["description"]);
  }

  dynamic querySize(int bID) {
    return queryBubble(bID, ["size"]);
  }

  dynamic queryXPos(int bID) {
    return queryBubble(bID, ["posX"]);
  }

  dynamic queryYPos(int bID) {
    return queryBubble(bID, ["posY"]);
  }

  dynamic queryTimeCreated(int bID) {
    return queryBubble(bID, ["time_created"]);
  }

  bool queryDeleted(int bID)
  // ignore: unrelated_type_equality_checks
  {
    return queryBubble(bID, ["deleted"]) == 0;
  }

  dynamic queryFrequency(int bID) {
    return queryBubble(bID, ["frequency"]);
  }

  Future<Color> queryColor(int bID) async {
    final colors = await db.queryBubbleByID(
        bID, ["color_red", "color_green", "color_blue", "opacity"]);
    return new Color.fromRGBO(colors["color_red"], colors["color_green"],
        colors["color_blue"], colors["opacity"]);
  }

  ///Queries pop_record
  ///@param bID: bubble to grab
  Future<dynamic> queryPop(int bID, List<String> columns) async {
    return db.queryPop();
  }

  ///Database Setters
  ///@author Martin Price
  ///@date March 2019
  ///Updates the bubble table
  ///@param bID: bubble to update
  ///@param columnID : bubble attribute to update
  ///@param value: new value
  void updateBubble(int bID, Map<String, dynamic> row) async {
    await db.updateBubbleByID(bID, row);
  }

  void updateTitle(int bID, String value) {
    updateBubble(bID, {"title": value});
  }

  void updateDesc(int bID, String value) {
    updateBubble(bID, {"description": value});
  }

  void updateSize(int bID, int value) {
    updateBubble(bID, {'size': value});
  }

  void updateXPos(int bID, double value) {
    print("XPOS IN DB: " + value.toString());
    updateBubble(bID, {"posX": value});
  }

  void updateYPos(int bID, double value) {
    print("YPOS IN DB: " + value.toString());
    updateBubble(bID, {"posY": value});
  }

  void updateDeleted(int bID, int value) {
    updateBubble(bID, {"deleted": value});
  }

  void updateFrequency(int bID, int value) {
    updateBubble(bID, {"frequency": value});
  }

  void updateColor(int bID, Color value) {
    updateBubble(bID, {
      "color_red": value.red,
      "color_green": value.green,
      "color_blue": value.blue,
      "opacity": value.opacity
    });
  }

  void updateDaysToRepeat(int bID, String value) {
    updateBubble(bID, {"days_to_repeat": value});
  }

  String toString() {
    return "$_bubbleID $_entry $_description $_xPos $_yPos";
  }
}

///A BubblesList class, used to store the Bubbles with additional methods
///not limited to normal Lists
class BubblesList {
  final db = DB.instance; //Instance of the database.
  List<Bubble> _myList; //List of bubbles
  int _numBubbles; //Number of bubbles in list

  BubblesList.newEmptyBubbleList() {
    _myList = []; //Sets an empty list
    this._numBubbles = 0; //Initial size is 0
  }

  Future<bool> populateBubblesForWidget() async {
    bool newDay = await db.login();
    print('Logged in!');
    if (newDay) {
      print('New Day!');
      return await populateBubbles();
    }
    else{
      print('Same Day');
      await unpoppedBubbles();
      toString2();
      return true;
    }
  }

  ///Default Contrustor that calls the database for populating bubbles
  ///@author Martin Price
  BubblesList() {
    try {
      populateBubbles();
    } catch (e) {
      BubblesList.newEmptyBubbleList();
    }
  }

  ///Queries the database for bubbles to be repopulated
  ///@return bubbles : a populated list of bubbles
  ///@return [] : error or no bubbles
  ///@author Martin Price
  Future<bool> populateBubbles() async {
    this._numBubbles = 0;
    this._myList = [];
    final results = await db.queryBubblesForRePop();
    for (var y in results) {
      bool valid = await db.bubbleRepeatsToday(y['bID']);
      if (valid) {
        addBubble(new Bubble.BubbleFromDatabase(
            y['bID'],
            y['title'],
            y['description'],
            new Color.fromRGBO(y['color_red'], y['color_green'],
                y['color_blue'], y['opacity']),
            y['size'],
            y['posX'],
            y['posY'],
            y['opacity'],
            y['times_popped'],
            y['frequency'],
            y['repeat'],
            y['days_to_repeat']));
      }
    }
    print('finished bubbles for today');
  }

  ///Contructor used to gather bubbles that have not been popped yet today
  BubblesList.unpoppedBubbles() {
    try {
      unpoppedBubbles();
    } catch (e) {
      BubblesList.newEmptyBubbleList();
    }
  }

  ///Queries the database for bubbles that have not been popped today
  ///@return bubbles : a populated list of bubbles that have NOT been popped
  ///@author Martin Price
  Future<bool> unpoppedBubbles() async {
    this._numBubbles = 0;
    this._myList = [];
    final results = await db.queryBubblesForRePop();
    for (var y in results) {
      bool popped = await db.queryPopForRecent(y['bID']);
      bool correctDay = await db.bubbleRepeatsToday(y['bID']);
      if (correctDay) {
        addBubble(new Bubble.BubbleFromDatabase(
            y['bID'],
            y['title'],
            y['description'],
            new Color.fromRGBO(y['color_red'], y['color_green'],
                y['color_blue'], y['opacity']),
            y['size'],
            y['posX'],
            y['posY'],
            y['opacity'],
            y['times_popped'],
            y['frequency'],
            y['repeat'],
            y['days_to_repeat']));
        if (!popped) {
          _myList[_numBubbles - 1].silentPop();
          print(
              'Silent popping bubble ${_myList[_numBubbles - 1].getBubbleID()}');
        }
      }
    }
    print('Finished unpopped bubbles');
  }

  ///Returns the list of bubbles.
  List<Bubble> getList() {
    return _myList;
  }

  ///Returns the number of bubbles in the list.
  int getSize() {
    return _numBubbles;
  }

  ///Returns a bubble at the index [i] in the list.
  Bubble getBubbleAt(int i) {
    return _myList[i];
  }

  ///Adds a bubble to the end of _myList.
  void addBubble(Bubble b) {
    _myList.add(b);
    _numBubbles++;
    // _myList.add(b);
  }

  ///Deletes a bubble at index [i].
  void removeBubbleAt(int i) {
    _myList.removeAt(i);

    _numBubbles--;
  }

  ///Changes the Pressed State of bubble at index [i] in _myList.
  void changeElementPressed(int i) {
    _myList[i].changePressed();
  }

  ///Moves the bubble to the front of the list.
  void moveToFront(Bubble bubble) {
    _myList.remove(bubble);
    _myList.add(bubble);
  }

  getIndex(Bubble bubble) => _myList.indexOf(bubble);

  ///Sets the current list to the settings of another BubblesList.
  void setTo(BubblesList nList) {
    _myList = nList.getList();
    _numBubbles = nList.getSize();
  }

  ///Returns a list of filled coordinates (XPerc, YPerc).
  List<List<double>> getFilledPos() {
    List<List<double>> fillers;
    List<double> currPos;
    for (int i = 0; i < _numBubbles; i++) {
      currPos = [_myList[i].getXPos(), _myList[i].getYPos()];
      fillers.add(currPos);
    }
    return fillers;
  }

  /// Sorts with the largest size first
  void orderBubbles() {
    _myList.sort((a, b) => b.getSize().compareTo(a.getSize()));
  }

  ///Removes the bubble that was popped
  ///First finds the bubbles position in the list
  ///then calls removeBubbleAt
  void removePoppedBubble(Bubble b) {
    for (int i = 0; i < _numBubbles; i++) {
      if (getBubbleAt(i).equals(b)) {
        removeBubbleAt(i);
        return;
      }
    }
  }

  ///Prints out the bubbles list
  void toString2() {
    for (int i = 0; i < _numBubbles; i++) print(getBubbleAt(i).toString());
  }
}

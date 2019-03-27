import 'package:flutter/material.dart';
import 'themeSelection.dart';
import 'iamthebubble.dart';
import 'themes.dart';
import 'bubbles.dart';

// ignore: must_be_immutable
class ListWidget extends StatefulWidget {
  BubblesList myList; //List of bubbles
  List<BubbleWidget> widList; //List of bubble widgets
  BubbleTheme _theme;

  //ListWidget({Key key, this.myList}) : super(key : key);
  ListWidget(BubblesList myList, List<BubbleWidget> widList, BubbleTheme _theme)
  {
    this.myList = myList;
    this.widList = widList;
    this._theme =_theme;
  }

  ListWidgetState createState() =>
      ListWidgetState(this.myList, this.widList, this._theme);
}

class ListWidgetState extends State<ListWidget> {
  static final TextStyle _bubbleFont = const TextStyle
    (fontWeight: FontWeight.bold,
      fontSize: 15.0,
      fontFamily: 'SoulMarker');
  BubblesList _myList;
  BubblesList _curList;
  List<BubbleWidget> _widList;
  BubbleTheme _theme;
  //int dropdownValue;

  ListWidgetState(BubblesList myList, List<BubbleWidget> widList,
      BubbleTheme _theme) {
    this._myList = myList;
    this._widList = widList;
    this._theme = _theme;
    //this.dropdownValue = 0;
  }

  //Creates the list view with dividers based on number of bubbles
  Widget _buildTasks() {
    return new ListView.builder(
        padding: const EdgeInsets.all(16.0),
        itemCount: _curList.getSize() * 2 - 1,
        itemBuilder: (BuildContext _context, int i) {
          // Add a one-pixel-high divider widget before each row
          // in the ListView.
          if (i.isOdd) {
            return new Divider();
          }
          final int index = i ~/ 2;
          return _buildRow(_curList.getBubbleAt(index));
        });
  }

  @override
  Widget build(BuildContext context) {
    // _myList.orderBubbles();
    _curList = new BubblesList();
    for(int i = 0; i < _myList.getSize(); i++){
      if(!_myList.getBubbleAt(i).getShouldDelete()){
        _curList.addBubble(_myList.getBubbleAt(i));
      }
    }
    //_curList.orderBubbles();
    return Scaffold(
      appBar: AppBar(
        title: Text("BUBL List View"),
        actions: <Widget>[
          new IconButton(
            icon: Icon(Icons.brush),
            onPressed: (){
              Navigator.of(context).push(MaterialPageRoute(
                builder: (context) =>
                    ThemeSelectorPage(theme: _theme, bublist: _curList),
              ));
            },
          ),
          new IconButton(
            icon: Icon(Icons.add_circle_outline),
            onPressed: (){
              setState(() {
                _pushNewBubble();
              });
            },
          ),
        ],
      ),
      body: _buildTasks(),
    );
  }

  //Creates a list tile for a bubble
  Widget _buildRow(Bubble bubble) {
    final bool alreadyCompleted = !(bubble.getPressed());
    return new ListTile(
      title: new Text(
        bubble.getEntry(),
      ),
      trailing: new Icon(
        alreadyCompleted ? Icons.check_box : Icons.check_box_outline_blank,
        color: alreadyCompleted ? bubble.getColor() : Colors.black,
      ),
      subtitle: new Text(bubble.getDescription()),
      onTap: () {
        setState(() {
          bubble.changePressed();
        });
      },
      onLongPress: () {
        _pushDetail(bubble);
      },
    );
  }

  void _pushDetail(Bubble _bubble){
    final TextStyle _biggerFont = const TextStyle(fontSize: 18.0);
    Navigator.of(context).push(
      new MaterialPageRoute<void>(
        builder: (BuildContext context){
          return new Scaffold(
            appBar: new AppBar(
              title: Text("Bubble: " + _bubble.getEntry()),
              actions: <Widget>[
                new IconButton(
                    icon: const Icon(Icons.edit),
                    onPressed: (){
                      _pushEditBubble(_bubble);
                    }),
              ],
            ),
            body: new Center(
              child: new Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    fakeBubble(_bubble),
                    Text("Title: " + _bubble.getEntry(),
                      style: _biggerFont,
                      textAlign: TextAlign.center,
                      overflow: TextOverflow.ellipsis,),
                    Text("Description: " + _bubble.getDescription(),
                      style:_biggerFont,
                      textAlign: TextAlign.center,
                      overflow: TextOverflow.clip,),
                    Text("Size: " + _bubble.getSize().toInt().toString(),
                      style:_biggerFont,
                      textAlign: TextAlign.center,
                      overflow: TextOverflow.ellipsis,),
                    Text("Completed: " + _bubble.getNumPressed().toString(),
                      style:_biggerFont,
                      textAlign: TextAlign.center,
                      overflow: TextOverflow.ellipsis,),
                    RaisedButton(
                      color: Colors.red[100],
                      onPressed: (){
                        _bubble.setToDelete();
                      },
                      child: Text("DELETE"),
                    )
                  ]
              ),
            ),
          );
        },
      ),
    );
  }

  Widget fakeBubble(Bubble _bubble){
    return new Container(
      width: _bubble.getSize(),
      height:_bubble.getSize(),
      child: new Container(
        decoration: new BoxDecoration(
          color: _bubble.getColor(),
          shape:BoxShape.circle,
        ),
        child: new Center(
          child: Text(_bubble.getEntry(), style:_bubbleFont),
        ),
      ),
    );
  }

  // Creates a new bubble
  Bubble _pushNewBubble() {
    final myController = TextEditingController();
    final myController2 = TextEditingController();
    final myController3 = TextEditingController();
    //int dropdownValue = 0;
    Bubble newBubble = new Bubble.defaultBubble();
    FocusNode fn;
    FocusNode fn2;
    fn = FocusNode();
    fn2 = FocusNode();

    void initState() {
      super.initState();
      //setState((){});
    }

    void dispose(){
      fn.dispose();
      fn2.dispose();
      myController.dispose();
      myController2.dispose();
      myController3.dispose();
      //myController4.dispose();
      super.dispose();
    }

    void _editBubble() {
      newBubble.setEntry(myController.text);
      newBubble.setDescription(myController2.text);
      newBubble.setSize(int.parse(myController3.text));
      //newBubble.setSize(dropdownValue);
    }

    /**void _onDropDownChanged(int val) {
      setState(() {
        dropdownValue = val;
      });
    }*/

    Navigator.of(context).push(
      new MaterialPageRoute<void>(
        builder: (BuildContext context) {
          //initState();
          return new Scaffold(
            appBar: new AppBar(
              title: const Text('Create New Bubble'),
            ),
            body: new Center(
                child: new Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      TextFormField(
                        autofocus: true,
                        //focusNode: fn2,
                        controller: myController,
                        decoration: const InputDecoration(
                          labelText: 'Task Name',
                        ),
                      ),
                      TextFormField(
                        autofocus: false,
                        focusNode: fn,
                        controller: myController2,
                        decoration: const InputDecoration(
                          labelText: 'Description',
                        ),
                      ),
                      TextFormField(
                        autofocus: false,
                        focusNode: fn2,
                        controller: myController3,
                        decoration: const InputDecoration(
                          labelText: 'Priority (0 to 3)',
                        ),
                      ),
                      /**DropdownButton<int>(
                        value: dropdownValue,
                        isExpanded: true,
                        isDense: false,
                        hint: new Text("Bubble Size"),
                        onChanged: (int newValue){
                          setState((){
                            dropdownValue = newValue;
                          });
                        },
                        items: <int>[0, 1, 2, 3].map<DropdownMenuItem<int>>((int value) {
                        return DropdownMenuItem<int>(
                        value: value,
                        child: Text(value.toString()),
                        );}).toList(),
                      ),*/
                      /**DropdownButtonFormField<int>(
                        //hint: new Text("Bubble Size"),
                        decoration: const InputDecoration(
                          labelText: 'Size',
                        ),
                        onChanged: (value){
                          print("changed - value: " + value.toString()
                              + " dropdownValue: " + dropdownValue.toString());
                          _onDropDownChanged(value);
                          print("changed - value: " + value.toString()
                              + " dropdownValue: " + dropdownValue.toString());
                        },
                        value: dropdownValue,
                        items: <int>[0, 1, 2, 3].map<DropdownMenuItem<int>>((int value) {
                          return DropdownMenuItem<int>(
                            value: value,
                            child: Text(value.toString()),
                          );}).toList(),
                      ),*/
                      RaisedButton(
                        onPressed: () {
                          _editBubble();
                          _myList.addBubble(newBubble);
                          _widList.add(BubbleWidget(_curList, _theme));
                          newBubble.setColor(
                              _myList.getBubbleAt(0).getColor());
                          Navigator.pop(context);
                        },
                        child: const Text('Save Bubble'),
                      ),
                    ]
                )
            ),
          );
        },
      ),
    );
    return newBubble;
  }

  // Edit bubble
  void _pushEditBubble(Bubble bubble) {
    final myController =
      TextEditingController(text: bubble.getEntry());
    final myController2 =
      TextEditingController(text: bubble.getDescription());
    final myController3 =
      TextEditingController(text: bubble.getSize().toString());

    FocusNode fn;
    FocusNode fn2;
    fn = FocusNode();
    fn2 = FocusNode();

    void initState() {
      super.initState();
      //setState((){});

    }

    void dispose(){
      fn.dispose();
      fn2.dispose();
      myController.dispose();
      myController2.dispose();
      myController3.dispose();
      //myController4.dispose();
      super.dispose();
    }

    void _editBubble() {
      bubble.setEntry(myController.text);
      bubble.setDescription(myController2.text);
      bubble.setSize(int.parse(myController3.text));
      //newBubble.setSize(dropdownValue);
    }

    Navigator.of(context).push(
      new MaterialPageRoute<void>(
        builder: (BuildContext context) {
          //initState();
          return new Scaffold(
            appBar: new AppBar(
              title: const Text('Edit Bubble'),
            ),
            body: new Center(
                child: new Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      TextFormField(
                        autofocus: true,
                        controller: myController,
                        decoration: const InputDecoration(
                          labelText: 'Task Name',
                        ),
                      ),
                      TextFormField(
                        autofocus: false,
                        //initialValue: bubble.getDescription(),
                        focusNode: fn,
                        controller: myController2,
                        decoration: const InputDecoration(
                          labelText: 'Description',
                        ),
                      ),
                      TextFormField(
                        autofocus: false,
                        focusNode: fn2,
                        controller: myController3,
                        decoration: const InputDecoration(
                          labelText: 'Priority (0 to 3)',
                        ),
                      ),
                      RaisedButton(
                        onPressed: () {
                          _editBubble();
                          Navigator.pop(context);
                        },
                        child: const Text('Edit Bubble'),
                      ),
                    ]
                )
            ),
          );
        },
      ),
    );
  }
}
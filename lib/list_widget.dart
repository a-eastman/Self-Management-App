import 'package:flutter/material.dart';
<<<<<<< HEAD
import 'iamthebubble.dart';
import 'themes.dart';
=======
import 'bubble_widget.dart';
>>>>>>> 85eaf95df3ad23ae04a9302e3a0ca2d4badc787c
import 'bubbles.dart';

// ignore: must_be_immutable
class ListWidget extends StatefulWidget {
<<<<<<< HEAD
  BubblesList myList; //List of bubbles
  List<BubbleWidget> widList; //List of bubble widgets
  BubbleTheme _theme;

  //ListWidget({Key key, this.myList}) : super(key : key);
  ListWidget(BubblesList myList, List<BubbleWidget> widList, BubbleTheme _theme) {
    this.myList = myList;
    this.widList = widList;
    this._theme =_theme;
  }

  ListWidgetState createState() => ListWidgetState(this.myList, this.widList, this._theme);
}

class ListWidgetState extends State<ListWidget> {
  static final TextStyle _bubbleFont = const TextStyle(fontWeight: FontWeight.bold,
      fontSize: 15.0,
      fontFamily: 'SoulMarker');
  BubblesList _myList;
  BubblesList _curList;
  List<BubbleWidget> _widList;
  BubbleTheme _theme;

  ListWidgetState(BubblesList myList, List<BubbleWidget> widList, BubbleTheme _theme) {
    this._myList = myList;
    this._widList = widList;
    this._theme = _theme;
  }

  //Creates the list view with dividers based on number of bubbles
  Widget _buildTasks() {
    return new ListView.builder(
        padding: const EdgeInsets.all(16.0),
        itemCount: _curList.getSize() * 2 - 1,
=======
  BubblesList myList;
  List<BubbleWidget> widList;

  //ListWidget({Key key, this.myList}) : super(key : key);
  ListWidget(BubblesList myList, List<BubbleWidget> widList) {
    this.myList = myList;
    this.widList = widList;
  }

  ListWidgetState createState() => ListWidgetState(this.myList, this.widList);
}

class ListWidgetState extends State<ListWidget> {
  BubblesList _myList;
  List<BubbleWidget> _widList;

  ListWidgetState(BubblesList myList, List<BubbleWidget> widList) {
    this._myList = myList;
    this._widList = widList;
  }

  Widget _buildTasks() {

    return new ListView.builder(
        padding: const EdgeInsets.all(16.0),
        itemCount: _myList.getSize() * 2 - 1,
>>>>>>> 85eaf95df3ad23ae04a9302e3a0ca2d4badc787c
        itemBuilder: (BuildContext _context, int i) {
          // Add a one-pixel-high divider widget before each row
          // in the ListView.
          if (i.isOdd) {
            return new Divider();
          }
          final int index = i ~/ 2;
<<<<<<< HEAD
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
    // _curList.orderBubbles();
    return Scaffold(
      appBar: AppBar(
        title: Text("BUBL List View"),
        actions: <Widget>[
          new IconButton(
            icon: Icon(Icons.add_circle_outline),
            onPressed: (){
              setState(() {
                _pushNewBubble();
              });
            },
          )
        ],
      ),
      body: _buildTasks(),
      // floatingActionButton: FloatingActionButton(
      //   onPressed: () {
      //     setState(() {
      //       _pushNewBubble();
      //     });
      //   },
      //   tooltip: 'Add Bubble',
      //   child: Icon(Icons.add),
      // ),
    );
  }

  //Creates a list tile for a bubble
=======
          return _buildRow(_myList.getBubbleAt(index));
          // return _buildRow(_widList[index].getBubble());
        });
  }

  // void makeWidgets(){
  //   _widList = new List();
  //   for (int i = 0; i < _myList.getSize(); i++){
  //     if (!_myList.getBubbleAt(i).getShouldDelete()){ //if the bubble is not 'deleted'
  //       _widList.add(BubbleWidget(bubble: _myList.getBubbleAt(i))); //add to widget list
  //     }
  //     else{} //if bubble is 'deleted' do nothing
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    _myList.orderBubbles();
    return Scaffold(
      appBar: AppBar(
        title: Text("BUBL List View"),
      ),
      body: _buildTasks(),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          setState(() {
            _pushNewBubble();
          });
        },
        tooltip: 'Add Task',
        child: Icon(Icons.add),
      ),
    );
  }

  void setWidList(List<BubbleWidget> nList){
    this._widList = nList;
  }
  void setBubbleList(BubblesList nList){
    this._myList = nList;
  }

>>>>>>> 85eaf95df3ad23ae04a9302e3a0ca2d4badc787c
  Widget _buildRow(Bubble bubble) {
    final bool alreadyCompleted = bubble.getPressed();

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

<<<<<<< HEAD
  void _pushDetail(Bubble _bubble){
    final TextStyle _biggerFont = const TextStyle(fontSize: 18.0);
    Navigator.of(context).push(
      new MaterialPageRoute<void>(
        builder: (BuildContext context){
          return new Scaffold(
            appBar: new AppBar(
              title: Text("Bubble: " + _bubble.getEntry()),
=======
  void _pushDetail(Bubble bubble) {
    final TextStyle _biggerFont = const TextStyle(fontSize: 18.0);
    Navigator.of(context).push(
      new MaterialPageRoute<void>(
        builder: (BuildContext context) {
          return new Scaffold(
            appBar: new AppBar(
              title: const Text('Task Details'),
>>>>>>> 85eaf95df3ad23ae04a9302e3a0ca2d4badc787c
              actions: <Widget>[
                new IconButton(icon: const Icon(Icons.edit), onPressed: null),
              ],
            ),
            body: new Center(
              child: new Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
<<<<<<< HEAD
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
=======
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text("Title: " + bubble.getEntry(), style: _biggerFont),
                    Text("Description: " + bubble.getDescription(),
                        style: _biggerFont),
                    Text("Size: " + bubble.getSize().toString(),
                        style: _biggerFont),
                    Text("Completed: " + bubble.getPressed().toString(),
                        style: _biggerFont),
                  ]),
>>>>>>> 85eaf95df3ad23ae04a9302e3a0ca2d4badc787c
            ),
          );
        },
      ),
    );
  }

<<<<<<< HEAD
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
=======
>>>>>>> 85eaf95df3ad23ae04a9302e3a0ca2d4badc787c
  Bubble _pushNewBubble() {
    final myController = TextEditingController();
    final myController2 = TextEditingController();
    final myController3 = TextEditingController();
    Bubble newBubble = new Bubble.defaultBubble();
    FocusNode fn;
    FocusNode fn2;
    fn = FocusNode();
    fn2 = FocusNode();

    void initState() {
      super.initState();
    }

    void dispose(){
      fn.dispose();
      fn2.dispose();
      myController.dispose();
      myController2.dispose();
      myController3.dispose();
      super.dispose();
    }

    void _editBubble() {
      newBubble.setEntry(myController.text);
      newBubble.setDescription(myController2.text);
      newBubble.setSize(int.parse(myController3.text));
<<<<<<< HEAD
=======
      // newBubble.changePressed();
>>>>>>> 85eaf95df3ad23ae04a9302e3a0ca2d4badc787c
    }

    Navigator.of(context).push(
      new MaterialPageRoute<void>(
        builder: (BuildContext context) {
          //initState();
          return new Scaffold(
            appBar: new AppBar(
<<<<<<< HEAD
              title: const Text('Create New Bubble'),
=======
              title: const Text('Create New Task'),
>>>>>>> 85eaf95df3ad23ae04a9302e3a0ca2d4badc787c
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
<<<<<<< HEAD
                      labelText: 'Priority (0 to 3)',
=======
                      labelText: 'Priority ',
>>>>>>> 85eaf95df3ad23ae04a9302e3a0ca2d4badc787c
                    ),
                  ),
                  FlatButton(
                    onPressed: () {
                      _editBubble();
                      _myList.addBubble(newBubble);
<<<<<<< HEAD
                      _widList.add(BubbleWidget(_curList, _theme));
                      newBubble.setColor(_curList.getBubbleAt(0).getColor());
=======
                      _widList.add(BubbleWidget(bubble: newBubble));
>>>>>>> 85eaf95df3ad23ae04a9302e3a0ca2d4badc787c
                      Navigator.pop(context);
                    },
                    child: const Text('Save Bubble'),
                  ),
                ])),
          );
        },
      ),
    );

    return newBubble;
  }
<<<<<<< HEAD
}
=======
}
>>>>>>> 85eaf95df3ad23ae04a9302e3a0ca2d4badc787c

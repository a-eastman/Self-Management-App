import 'package:flutter/material.dart';
import 'bubble_widget.dart';
import 'bubbles.dart';

// ignore: must_be_immutable
class ListWidget extends StatefulWidget {
  BubblesList myList; //List of bubbles
  List<BubbleWidget> widList; //List of bubble widgets

  //ListWidget({Key key, this.myList}) : super(key : key);
  ListWidget(BubblesList myList, List<BubbleWidget> widList) {
    this.myList = myList;
    this.widList = widList;
  }

  ListWidgetState createState() => ListWidgetState(this.myList, this.widList);
}

class ListWidgetState extends State<ListWidget> {
  static final TextStyle _bubbleFont = const TextStyle(fontWeight: FontWeight.bold,
      fontSize: 15.0,
      fontFamily: 'SoulMarker');
  BubblesList _myList;
  BubblesList _curList;
  List<BubbleWidget> _widList;

  ListWidgetState(BubblesList myList, List<BubbleWidget> widList) {
    this._myList = myList;
    this._widList = widList;
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
    _myList.orderBubbles();
    _curList = new BubblesList();
    for(int i = 0; i < _myList.getSize(); i++){
      if(!_myList.getBubbleAt(i).getShouldDelete()){
        _curList.addBubble(_myList.getBubbleAt(i));
      }
    }
    _curList.orderBubbles();
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
      /**floatingActionButton: FloatingActionButton(
        onPressed: () {
          setState(() {
            _pushNewBubble();
          });
        },
        tooltip: 'Add Bubble',
        child: Icon(Icons.add),
      ),*/
    );
  }

  //Creates a list tile for a bubble
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

  void _pushDetail(Bubble _bubble){
    final TextStyle _biggerFont = const TextStyle(fontSize: 18.0);
    Navigator.of(context).push(
      new MaterialPageRoute<void>(
        builder: (BuildContext context){
          return new Scaffold(
            appBar: new AppBar(
              title: Text("Bubble: " + _bubble.getEntry()),
              actions: <Widget>[
                new IconButton(icon: const Icon(Icons.edit), onPressed: null),
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
    }

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
                  FlatButton(
                    onPressed: () {
                      _editBubble();
                      _myList.addBubble(newBubble);
                      _widList.add(BubbleWidget(bubble: newBubble));
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
}

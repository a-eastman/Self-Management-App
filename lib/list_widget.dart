import 'package:flutter/material.dart';
import 'bubble_widget.dart';
import 'bubbles.dart';

// ignore: must_be_immutable
class ListWidget extends StatefulWidget {
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
        itemBuilder: (BuildContext _context, int i) {
          // Add a one-pixel-high divider widget before each row
          // in the ListView.
          if (i.isOdd) {
            return new Divider();
          }
          final int index = i ~/ 2;
          return _buildRow(_myList.getBubbleAt(index));
        });
  }

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

  void _pushDetail(Bubble bubble) {
    final TextStyle _biggerFont = const TextStyle(fontSize: 18.0);
    Navigator.of(context).push(
      new MaterialPageRoute<void>(
        builder: (BuildContext context) {
          return new Scaffold(
            appBar: new AppBar(
              title: const Text('Task Details'),
              actions: <Widget>[
                new IconButton(icon: const Icon(Icons.edit), onPressed: null),
              ],
            ),
            body: new Center(
              child: new Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
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
            ),
          );
        },
      ),
    );
  }

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
      newBubble.setSize(double.parse(myController3.text));
    }

    Navigator.of(context).push(
      new MaterialPageRoute<void>(
        builder: (BuildContext context) {
          //initState();
          return new Scaffold(
            appBar: new AppBar(
              title: const Text('Create New Task'),
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
                      labelText: 'Priority ',
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

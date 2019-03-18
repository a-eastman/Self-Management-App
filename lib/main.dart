import 'package:flutter/material.dart';
import 'bubble_widget.dart';
import 'list_widget.dart';
import 'bubbles.dart';

void main() => runApp(BubbleView());


class BubbleApp extends StatefulWidget{
  @override
  BubbleAppState createState() => BubbleAppState();
}

class BubbleAppState extends State<BubbleApp>{
  List<BubbleWidget> _myList;
  ListWidget list;
  BubblesList myList;
  Bubble b0;
  Bubble b1;
  Bubble b2;

  @override
  void initState(){
    super.initState();
    _myList = new List();
    myList = new BubblesList();
    b0 = new Bubble("Caeleb", "Nasoff", Colors.purple, 150.0, true, 50.0, 50.0, 0.8);
    b1 = new Bubble.defaultBubble();
    b2 = new Bubble("DOUG DIMMADOME",
        "OWNER OF THE DIMSDALE DIMMADOME",
        Colors.red,
        200.0,
        true,
        0.2,
        0.2,
        1.0
    );
    _myList.add(BubbleWidget(bubble: b1));
    _myList.add(BubbleWidget(bubble: b0));
    _myList.add(BubbleWidget(bubble: b2));
    myList.addBubble(b1);
    myList.addBubble(b0);
    myList.addBubble(b2);
  }

  Widget build(BuildContext context){
    return _buildPages();  
  }

  Widget _buildListView(){
    return list = new ListWidget(myList, _myList);
  }

  Widget _buildBubbleView(){
    return Scaffold(
        appBar: AppBar(
          title: Text('BUBL'),
          actions: <Widget>[
            new IconButton(
              icon: Icon(Icons.add_circle_outline),
              onPressed: (){
                setState(() {
                  _addNewBubble();
                });
              },
            )
          ],
        ),
        
        body: new Stack(
          children: _myList,
        )
    );
  }

  

  Widget _buildPages(){
    return PageView(
      children: <Widget>[
      _buildBubbleView(),
      _buildListView(),
      ],
      pageSnapping: true,
    );
  }

  _addNewBubble(){
    final myController = TextEditingController();
    final myController2 = TextEditingController();
    final myController3 = TextEditingController();
    Bubble newBubble = new Bubble.defaultBubble();
    newBubble.changePressed();
    //final TextStyle _biggerFont = const TextStyle(fontSize: 18.0);
    FocusNode fn;
    FocusNode fn2;
    fn = FocusNode();

    void initState() {
      super.initState();
    }

    void dispose(){
      fn.dispose();
      fn2.dispose();
      myController.dispose();
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
                    //enabled: fn.hasFocus,
                    controller: myController3,
                    decoration: const InputDecoration(
                      labelText: 'Priority ',
                    ),
                  ),
                  FlatButton(
                    onPressed: () {
                      _editBubble();
                      myList.addBubble(newBubble);
                      _myList.add(BubbleWidget(bubble: newBubble)); 
                      Navigator.pop(context);
                    },
                    child: const Text('Save Bubble'),
                  ),
                ])),
          );
        },
      ),
    );

    //return newBubble;
  }
  
}

class BubbleView extends StatelessWidget {
  @override
  Widget build(BuildContext context){
    return MaterialApp(
      title:'App3',
      home: BubbleApp(),
    );
  }
}


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
  //List<BubbleWidget> _myList;
  ListWidget list;
  BubblesList myList;
  Bubble b0;
  Bubble b1;
  Bubble b2;

  @override
  void initState(){
    super.initState();
    //_myList = new List();
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
    //_myList.add(BubbleWidget(bubble: b1));
    //_myList.add(BubbleWidget(bubble: b0));
    //_myList.add(BubbleWidget(bubble: b2));
    myList.addBubble(b1);
    myList.addBubble(b0);
    myList.addBubble(b2);
  }

  Widget build(BuildContext context){

    return list = new ListWidget(myList);

    /**
    return Scaffold(
        appBar: AppBar(
          title: Text('BUBL'),
        ),
        body: new Stack(
          children: _myList,
        )
    );*/
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
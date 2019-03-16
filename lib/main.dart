import 'package:flutter/material.dart';
import 'bubble_widget.dart';
import 'bubbles.dart';

void main() => runApp(BubbleView());


class BubbleApp extends StatefulWidget{
  @override
  BubbleAppState createState() => BubbleAppState();
}

class BubbleAppState extends State<BubbleApp>{
  Bubble b1 = new Bubble.defaultBubble();
  Bubble b2 = new Bubble("DOUG DIMMADOME", 
                        "OWNER OF THE DIMSDALE DIMMADOME",
                        Colors.red,
                        200.0,
                        true,
                        0.2,
                        0.2,
                        1.0
);
  //Implement move bubble here

  Widget build(BuildContext context){
    return Scaffold(
      appBar: AppBar(
        title: Text('BUBL'),
      ),
      body: new Stack(
        children: [BubbleWidget(bubble: b1),
                  BubbleWidget(bubble: b2)],
      )
    );
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

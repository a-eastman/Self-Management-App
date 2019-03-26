import 'package:flutter/material.dart';
import 'bubble_widget.dart';
import 'database.dart';
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
    // Test the database
    final db = DB.instance;
  //Implement move bubble here

  Widget build(BuildContext context){
    return Scaffold(
      appBar: AppBar(
        title: Text('BUBL'),
      ),
      body: new Stack(
        children: [BubbleWidget(bubble: b1),
                  BubbleWidget(bubble: b2), 
                  //RaisedButton(child: Text("Query DB for Bubls", style: TextStyle(fontSize: 20),),
                  //onPressed: () {_searchDB();},),
                  RaisedButton(child: Text("Update Bubl DB", style: TextStyle(fontSize: 20),),
                  onPressed: () {_updateDB();},)],
      )
    );
  }

  /**
   * Heleper methods used by Martin to quickly test the DB
   */
  void _searchDB() async
  {

  }
  void _updateDB() async
  {
    await db.enterBubbleUpdate('Hello World', 'Test to See the DB', "blue", 5, 0.75, 0.25);
  }


}

class BubbleView extends StatelessWidget {
    @override
  Widget build(BuildContext context){
    return MaterialApp(
      title:'App4 with DB',
      home: BubbleApp(), 
    );
  }
}
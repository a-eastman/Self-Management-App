
import 'package:flutter/material.dart';
import 'database.dart';
import 'bubbles.dart';


void main() => runApp(DBview());
  final db = DB.instance;

class DBview extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'SQFlite Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatelessWidget{
  @override
  Widget build(BuildContext context){
    return Scaffold(
      appBar: AppBar(
        title: Text('BUBL Test DB'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            RaisedButton(
              child: Text('insert values', style: TextStyle(fontSize: 20),),
              onPressed: () { _insert(); },
            ),
            RaisedButton(
              child: Text('Refresh', style: TextStyle(fontSize: 20),),
              onPressed: () { _refresh(); },
            ),
            RaisedButton(
              child: Text('Test Attribute', style: TextStyle(fontSize: 20),),
              onPressed: () { _testColor(); },
            ),
            RaisedButton(
              child: Text('login', style: TextStyle(fontSize: 20),),
              onPressed: () { _login(); },
            ),
            //BubbleWidget(bubble: new Bubble.defaultBubble()),
          ],
        ),
      ),
      //body:
      //new Stack(
      //children: [BubbleWidget(bubble: b1),
      //BubbleWidget(bubble: b2)
    );
  }

  //Helper methods used by Martin to quickly test the DB
  void _queryBub() async
  {
    final allBubbles = await db.queryBubble();
    print("Printing Bubbles");
    try{ allBubbles.forEach((row) => print(row)); }
    catch (e) { print("No bubs"); }

  }
  void _queryPop() async
  {
    final allPop = await db.queryBubblesForRePop();
    print("Printing popped");
    try{ allPop.forEach((row) => print(row)); }
    catch (e) { print("No pops"); }
  }
  void _insert() async
  {
    //print("Testing the bubble table");
    //print(await db.insertBubble('Hello World 2', 'Test to See the DB 2', 100, 200, 100, 0.50, 5, 0.75, 0.25));
    //print("Testing the pop table");
    //print(await(db.insertPop()));

    print("Creating a new bubble");
    await db.insertBubble("Hello", "There", 120, 140, 160, 0.50, 2, 0.75, 0.25);
    int x = await db.queryLastCreatedBubbleID();
    Map<String, dynamic> y = await db.queryBubbleByID(x, []);
    Bubble b2 = new Bubble.BubbleFromDatabase(x,y['title'],y['description'],
                  new Color.fromRGBO(y['color_red'],y['color_green'],
                                     y['color_blue'],y['opacity']),
                  y['size'], y['xPos'], y['yPos'], y['opacity'], y['times_popped']);
    print("Bubble created from DB");
    print(b2.getBubbleID());
    print(b2.getDescription());
    print(b2.getSize());

  }
  void _testDB() async
  {
    print('Printing out bubl table:');
    final bubl = await db.queryBubble();
    try{ bubl.forEach((row) => print(row)); }
    catch(e) {print(e); }

    print('Printing out pop_record table:');
    final pop = await db.queryPop();
    try{ pop.forEach((row) => print(row)); }
    catch(e) {print(e); }
  }
  void _refresh() async
  {
    print("Refreshing Bubl.db");
    await db.refreshDB();
  }

  void _testBubble() async
  {
    print("Testing a Bubble");
    //print(b1.getBubbleID());
  }

  void _login() async
  {
    print('Logging in now');
    final newDay = await db.login();
    if(newDay) print('Logged in to a new day'); 
    else print('Welcome back!');
    final logins = await db.queryAppState();
    try{logins.forEach((row) => print(row)); }
    catch(e) {print(e); print('No logins found'); }
  }

  void _testColor()
  {

  }
}

/*class BubbleApp extends StatefulWidget{
  @override
  BubbleAppState createState() => BubbleAppState();
}

class BubbleAppState extends State<BubbleApp>{
  Bubble b1 = new Bubble.defaultBubble();
  Bubble b2 = new Bubble("DOUG DIMMADOME",
      "OWNER OF THE DIMSDALE DIMMADOME",
      Colors.red,
      200,
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
          BubbleWidget(bubble: b2),],
        )
    );
  }
}*/
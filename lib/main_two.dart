
import 'package:flutter/material.dart';
import 'database.dart';


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
              onPressed: () { _testDB(); },
            ),
            RaisedButton(
              child: Text('Refresh', style: TextStyle(fontSize: 20),),
              onPressed: () { _refresh(); },
            ),
            RaisedButton(
              child: Text('Test Attribute', style: TextStyle(fontSize: 20),),
              onPressed: () { _queryPop(); },
            ),
            RaisedButton(
              child: Text('login', style: TextStyle(fontSize: 20),),
              onPressed: () { _login(); },
            ),
          ],
        ),
      ),
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
    final allPop = await db.queryPop();
    print("Printing popped");
    try{ allPop.forEach((row) => print(row)); }
    catch (e) { print("No pops"); }
  }
  void _insert() async
  {
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


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
              child: Text('Refresh', style: TextStyle(fontSize: 20),),
              onPressed: () { _refresh(); },
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
  void _refresh() async
  {
    print("Refreshing Bubl.db");
    await db.refreshDB();
    print('DB refreshed');
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
}

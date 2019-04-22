import 'package:flutter/material.dart';
import 'database.dart';

final db = DB.instance;
final xml = DB.instance;
void main() => runApp(DBview());
class DBview extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'SQFlite Demo',
      debugShowCheckedModeBanner: false,
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
    xml.initXML();
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
              child: Text('XML', style: TextStyle(fontSize: 20),),
              onPressed: () { _printXML(); },
            ),
          ],
        ),
      ),
    );
  }
  void _refresh() async{
    print("Refreshing Bubl.db");
    await db.refreshDB();
    print('DB refreshed');
    print('Refreshing XML');
    await db.refreshXML();
    print('XML refreshed');
  }

  void _printXML(){
    print('Printing XML');
    xml.printXML();
    print('Font Size ${xml.getStoredFontSize()}');
    print('Increasing font by 1');
    xml.enterFontSize(xml.getStoredFontSize()+1);
    print('Font Size ${xml.getStoredFontSize()}');
  }
}
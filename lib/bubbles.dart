import 'package:flutter/material.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget{
  @override
  Widget build(BuildContext context){
    return MaterialApp(
      title:'App3',
      home: EntryPage(),
    );
  }
}

class MyGrid extends State<EntryPage>{
  int _widthTiles;
  int _heightTiles;
  List<Widget> _myList;
  BubblesList _bList;

  MyGrid(int _widthTiles, int _heightTiles){
    this._widthTiles = _widthTiles;
    this._heightTiles = _heightTiles;
    this._myList = genBubbles(_widthTiles);
    this._bList = new BubblesList(5);
  }

  int getHeightTiles(){
    return this._heightTiles;
  }

  int getWidthTiles(){
    return this._widthTiles;
  }



  Widget buildGrid(int crossCount, double padding, double spacing){
    List<Widget> _list = genBubbles(crossCount);
    return new GridView.count(
      primary: false,
      padding: EdgeInsets.all(padding),
      crossAxisSpacing: spacing,
      crossAxisCount: crossCount,
      children: _list,
    );
  }

  List<Widget> genBubbles(int size){
    List<Widget> _list = List<Widget>(size);
    for (int i = 0; i < size; i++){
      _list[i] = makeBubble(new Bubble(i.toString(), (i+1)*10.0, true));
    }
    return _list;
  }

  Widget makeBubbles(double padding, double spacing, int crossCount){
    List<Widget> wList = [];
    for (int i = 0; i < this._bList.getBubbleList().length; i++) {
      wList.add(new Container(width: 200.0,
        height: 200.0,
        child: Center(
            child: Container(
                width: _bList.getElement(i).getPriority(),
                height: _bList.getElement(i).getPriority(),
                child: Opacity(
                    opacity: _bList.getElement(i).getPressed() ? 1.0 : 0.0,
                    child: FloatingActionButton(
                        backgroundColor: Colors.blueAccent[300],
                        child: Text(_bList.getElement(i).getEntry()),
                        onPressed: () {
                          setState(() {
                            print(_bList.getElement(i).getPressed().toString());
                            _bList.changeElementPressed(i);
                            print(_bList.getElement(i).getPressed().toString());
                          });
                        }
                    )
                )
            )
        ),
      ));
    }
    return new GridView.count(
      primary: false,
      padding: EdgeInsets.all(padding),
      crossAxisSpacing: spacing,
      crossAxisCount: crossCount,
      children: wList,
    );


  }

  Widget makeBubble(Bubble b) {
    print('Visibility' + b.getPressed().toString());
    return Container(
      width: 200.0,
      height: 200.0,
      child: Center(
          child: Container(
              width: b.getPriority(),
              height: b.getPriority(),
              child: Opacity(
                  opacity: b.getPressed() ? 1.0 : 0.0,
                  child: FloatingActionButton(
                      backgroundColor: Colors.blueAccent[300],
                      child: Text(b.getEntry()),
                      onPressed: () {
                        setState(() {
                          print(b.getPressed().toString());
                          b.changePressed();
                          print(b.getPressed().toString());
                        });
                      }
                  )
              )
          )
      ),
    );
  }
  Bubble b1 = new Bubble('Pop!', 300, true);

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('BUBL'),
      ),
      body: makeBubbles(5.0, 5.0, 5),
    );
  }
}

class Bubble{
  String _entry;
  double _priority;
  bool _pressed;

  Bubble(String _entry, double _priority, bool _pressed){
    this._entry = _entry;
    this._priority = _priority;
    this._pressed = _pressed;
  }

  bool getPressed(){
    return this._pressed;
  }
  void changePressed(){
    _pressed = !_pressed;
  }

  String getEntry(){
    return this._entry;
  }

  double getPriority(){
    return this._priority;
  }
  void setPriority(double newPri){
    this._priority = newPri;
  }
}

class BubblesList{
  List<Bubble> _myList;
  int _initSize;
  BubblesList(int _initSize){
    _myList = [];
    this._initSize = _initSize;
    for (int i = 0; i < this._initSize; i++){
      _myList.add(new Bubble(i.toString(), (i+1)*20.0, true));
    }
  }

  void changeElementPressed(int i){
    _myList[i].changePressed();
  }

  int getInitSize(){
    return this._initSize;
  }

  Bubble getElement(int i){
    return _myList[i];
  }

  void deleteElement(int i){
    _myList.removeAt(i);
  }

  List<Bubble> getBubbleList(){
    return _myList;
  }

  void changeList(List<Bubble> nList){
    _myList = nList;
  }
}
class EntryPage extends StatefulWidget{
  MyGrid createState() => MyGrid(5, 5);
}
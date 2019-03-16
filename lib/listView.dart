import 'package:flutter/material.dart';
import 'bubbles.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'List View Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'BUBL ListView Demo'),
    );
  }
}


class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  BubblesList _myList;
  Bubble b0;
  Bubble b1;
  Bubble b2;

  _MyHomePageState(){

    this._myList = new BubblesList();
    genList();
  }


  void genList(){
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
    _myList.addBubble(b1);
    _myList.addBubble(b0);
    _myList.addBubble(b2);
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
        }
    );
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),

      ),
      body: _buildTasks(),
      floatingActionButton: FloatingActionButton(
        onPressed: (){
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
      onTap: () {
        setState(() {
          bubble.changePressed();
        });
      },
      onLongPress: (){
        _pushDetail(bubble);
      },
    );
  }

  void _pushDetail(Bubble bubble){
    final TextStyle _biggerFont = const TextStyle(fontSize: 18.0);
    Navigator.of(context).push(
      new MaterialPageRoute<void>(   // Add 20 lines from here...
        builder: (BuildContext context) {
          return new Scaffold(         // Add 6 lines from here...
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
                    Text("Description: " + bubble.getDescription(),  style: _biggerFont),
                    Text("Size: " + bubble.getSize().toString(),  style: _biggerFont),
                    Text("Completed: " + bubble.getPressed().toString(),  style: _biggerFont),
                  ]
              ),
            ),
          );
        },
      ),
    );
  }


}


/**
class Task {
  String _name;
  String _description;
  double _priority;
  bool _completed;


  Task(String _name, String _description, double _priority, bool _completed){
    this._name = _name;
    this._priority = _priority;
    this._completed = _completed;
    this._description = _description;
  }

  String getName(){
    return _name;
  }

  String getDescription(){
    return _description;
  }

  double getPriority(){
    return _priority;
  }

  bool getCompleted(){
    return _completed;
  }

  void setName(String _name){
    this._name = _name;
  }

  void setDescription(String _description){
    this._description = _description;
  }

  void changeCompleted(){
    _completed = !_completed;
  }

  void setPriority(double _priority){
    this._priority = _priority;
  }

}

class TaskList{
  List<Task> _myList;
  int _initSize;
  int _length;

  TaskList(int _initSize){
    _myList = [];
    this._initSize = _initSize;
    this._length = _initSize;
  }

  void addElement(Task task){
    _myList.add(task);

  }

  int getLength(){
    return _length;
  }

  void changeElementCompleted(int i){
    _myList[i].changeCompleted();
  }

  int getInitSize(){
    return this._initSize;
  }

  Task getElement(int i){
    return _myList[i];
  }

  void deleteElement(int i){
    _myList.removeAt(i);

  }

  List<Task> getTaskList(){
    return _myList;
  }

  void changeList(List<Task> nList){
    _myList = nList;
  }
    }
    */

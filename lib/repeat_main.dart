import 'package:flutter/material.dart';
import 'bubbles.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'Repeat Test Application'),
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
  BubblesList bubbles;

  _MyHomePageState() {
    Bubble test1 = new Bubble(
        "Test1", "Description1", Colors.blue, 1, false, 0.5, 0.5, 1.0);
    bubbles = new BubblesList();
    bubbles.addBubble(test1);
  }

  final myController = TextEditingController();
  final myController2 = TextEditingController();
  final myController3 = TextEditingController();

  //int dropdownValue = 0;
  Bubble newBubble = new Bubble.defaultBubble();
  FocusNode fn = FocusNode();
  FocusNode fn2 = FocusNode();

  void initState() {
    super.initState();
    //setState((){});
  }

  void dispose() {
    fn.dispose();
    fn2.dispose();
    myController.dispose();
    myController2.dispose();
    myController3.dispose();
    super.dispose();
  }

  void _editBubble() {
    newBubble.setEntry(myController.text);
    newBubble.setDescription(myController2.text);
    newBubble.setSize(int.parse(myController3.text));
  }

  Widget _buildRepeat() {
    final bool repeat = newBubble.getRepeat();
    return new ListTile(
      title: new Text("Repeat"),
      trailing: new Icon(
        repeat ? Icons.check_box : Icons.check_box_outline_blank,
        color: repeat ? Colors.blue : Colors.black,
      ),
      onTap: () {
        setState(() {
          newBubble.changeRepeat();
        });
      },
    );
  }

  Widget _buildDay(String day) {
    final bool repeat = newBubble.getRepeatDay(day);
    return new Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          new Container(
            width: 55,
            //title: new Text("Repeat"),
            child: new FlatButton(
                child: new Icon(
                  repeat ? Icons.check_box : Icons.check_box_outline_blank,
                  color: repeat ? Colors.blue : Colors.black,
                ),
                onPressed: () {
                  setState(() {
                    newBubble.changeRepeatDay(day);
                  });
                }),
          ),
          new Text(day),
        ]);
  }

  Widget _buildWeek() {
    if (newBubble.getRepeat()) {
      return new Row(mainAxisSize: MainAxisSize.min, children: <Widget>[
        _buildDay("Sun"),
        _buildDay("Mon"),
        _buildDay("Tue"),
        _buildDay("Wed"),
        _buildDay("Thu"),
        _buildDay("Fri"),
        _buildDay("Sat"),
      ]);
    } else {
      return new Row();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(widget.title),
        ),
        body: ListView(children: <Widget>[

          Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              TextFormField(
                autofocus: true,
                //focusNode: fn2,
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
                controller: myController3,
                decoration: const InputDecoration(
                  labelText: 'Priority (0 to 3)',
                ),
              ),
              _buildRepeat(),
              _buildWeek(),
              Container(
                  height: 20
              ),
              RaisedButton(
                color: Colors.blue,
                onPressed: () {
                  _editBubble();
                  bubbles.addBubble(newBubble);
                  //_myList.addBubble(newBubble);
                  //_widList.add(BubbleWidget(_curList, _theme));
                  //newBubble.setColor(
                  //    _myList.getBubbleAt(0).getColor());
                  //Navigator.pop(context);
                },
                child: const Text('ADD'),
              ),
            ],
          ),
        ]));
  }
}

import 'package:flutter/material.dart';
import 'bubble_widget.dart';
import 'list_widget.dart';
import 'bubbles.dart';
import 'themeSelection.dart';
import 'themes.dart';

void main() => runApp(BubbleView());


class BubbleApp extends StatefulWidget{
  final BubbleTheme theme;

  BubbleApp({Key key, this.theme});
  @override
  BubbleAppState createState() => BubbleAppState(theme);
}

class BubbleAppState extends State<BubbleApp>{
  BubbleTheme theme;
  BubbleAppState(this.theme);
  List<BubbleWidget> _myList;
  // ListWidget _listWidget;
  BubblesList _bList;
  Bubble b0;
  Bubble b1;
  Bubble b2;

  @override
  void initState(){
    super.initState();
    //ThemeBloc themeBloc = new ThemeBloc();
    _myList = new List();
    _bList = new BubblesList();
    b0 = new Bubble("Caeleb", "Nasoff", Colors.purple, 2, true, 50.0, 50.0, 0.8);
    b1 = new Bubble.defaultBubble();
    b2 = new Bubble("DOUG DIMMADOME",
        "OWNER OF THE DIMSDALE DIMMADOME",
        Colors.red,
        3,
        true,
        0.2,
        0.2,
        1.0
    );
    // _myList.add(BubbleWidget(bubble: b1));
    // _myList.add(BubbleWidget(bubble: b0));
    // _myList.add(BubbleWidget(bubble: b2));
    _bList.addBubble(b1);
    _bList.addBubble(b0);
    _bList.addBubble(b2);
  }

  void makeWidgets(){
    _myList = new List();
    for (int i = 0; i < _bList.getSize(); i++){
      if (!_bList.getBubbleAt(i).getShouldDelete()){ //if the bubble is not 'deleted'
        _myList.add(BubbleWidget(bubble: _bList.getBubbleAt(i))); //add to widget list
      }
      else{} //if bubble is 'deleted' do nothing
    }
  }

  Widget build(BuildContext context){
    return _buildPages();
  }

  ListWidget _buildListView(){
    return new ListWidget(_bList, _myList);
  }

  Widget _buildBubbleView(){
    //ThemeBloc themeBloc = new ThemeBloc();
    return Scaffold(
        appBar: AppBar(
          title: Text('BUBL'),
          actions: <Widget>[
            new IconButton(
              icon: Icon(Icons.brush),
              onPressed: (){
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => ThemeSelectorPage(theme: theme, bublist: _bList,)
                ));
              },

            ),
            new IconButton(
              icon: Icon(Icons.add_circle_outline),
              onPressed: (){
                setState(() {
                  _addNewBubble();
                });
              },
            ),

          ],
        ),

        body: new Stack(
          children: _myList,
        )
    );
  }

  Widget _buildPages(){
    makeWidgets(); //update widgetList
    return PageView(
      children: <Widget>[
        _buildBubbleView(),
        _buildListView(),
      ],
      pageSnapping: true,
    );
  }

  _addNewBubble(){
    final myController = TextEditingController();
    final myController2 = TextEditingController();
    final myController3 = TextEditingController();
    Bubble newBubble = new Bubble.defaultBubble();
    //newBubble.changePressed();
    //final TextStyle _biggerFont = const TextStyle(fontSize: 18.0);
    FocusNode fn;
    FocusNode fn2;
    fn = FocusNode();

    void initState() {
      super.initState();
    }

    void dispose(){
      fn.dispose();
      fn2.dispose();
      myController.dispose();
      super.dispose();
    }

    void _editBubble() {
      newBubble.setEntry(myController.text);
      newBubble.setDescription(myController2.text);
      newBubble.setSize(int.parse(myController3.text));
    }

    Navigator.of(context).push(
      new MaterialPageRoute<void>(
        builder: (BuildContext context) {
          //initState();
          return new Scaffold(
            appBar: new AppBar(
              title: const Text('Create New Task'),
            ),
            body: new Center(
                child: new Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      TextFormField(
                        autofocus: true,
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
                        //enabled: fn.hasFocus,
                        controller: myController3,
                        decoration: const InputDecoration(
                          labelText: 'Priority (0 to 3)',
                        ),
                      ),
                      FlatButton(
                        onPressed: () {
                          setState ((){
                            _editBubble();
                            _bList.addBubble(newBubble);
                            // _myList.add(BubbleWidget(bubble: newBubble));
                            Navigator.pop(context);
                          });
                        },
                        child: const Text('Save Bubble'),
                      ),
                    ])),
          );
        },
      ),
    );

    //return newBubble;
  }


}

class BubbleView extends StatelessWidget {

  @override
  Widget build(BuildContext context){
    final BubbleTheme theme =BubbleTheme();

    return StreamBuilder<ThemeData>(
      initialData: theme.initialTheme().data,
      stream: theme.themeDataStream,
      builder: (BuildContext context, AsyncSnapshot<ThemeData> snapshot) {
        return MaterialApp(
          title: 'App3',
          theme: snapshot.data,
          home: BubbleApp(
            theme: theme,
          ),
        );
      },
    );

  }
}
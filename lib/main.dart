import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: ToDoList(),
    );
  }
}

class ToDoList extends StatefulWidget {
  @override
  createState() => _ToDoListState();
}

class _ToDoListState extends State<ToDoList> {
  List<String> _toDoItems = [];
  List<bool> _toDoItemsBool = [];

  void _addToDoItem(String text) {
    setState(() {
      _toDoItems.add(text);
      _toDoItemsBool.add(false);
    });
  }

  Widget _buildToDoList(BuildContext context) {
    return ListView.builder(
        shrinkWrap: true,
        itemCount: _toDoItems.length,
        itemBuilder: (context, index) {
          if (index < _toDoItems.length) {
            return _buildToDoItem(_toDoItems[index], index, context);
          }
        });
  }

  Widget _buildToDoItem(String toDoText, int index, BuildContext context) {
    return Image.asset('assets/images/phillip-profile.jpg');
    // key: Key(toDoText),
    // child: ListTile(
    //   title: Text(toDoText),
    //   onTap: () =>
    //       setState(() => _toDoItemsBool[index] = !_toDoItemsBool[index]),
    //   leading: _toDoItemsBool[index]
    //       ? Icon(Icons.radio_button_checked)
    //       : Icon(Icons.radio_button_unchecked),
    // ));
  }

  void _navigateToDoEntry() {
    Navigator.of(context).push(MaterialPageRoute(builder: (context) {
      return Scaffold(
          appBar: AppBar(
            title: Text('Add a Task'),
          ),
          body: TextField(
            autofocus: true,
            onSubmitted: (enteredText) {
              _addToDoItem(enteredText);
              Navigator.pop(context);
            },
            decoration: InputDecoration(
              hintText: 'Type in a new task!',
              contentPadding: const EdgeInsets.all(16.0),
            ),
          ));
    }));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('To-do List!')),
      body: ListView(children: [
        Center(
            child: Card(
                margin: EdgeInsets.all(10.0),
                color: Color.fromRGBO(1, 2, 3, 10),
                child: Padding(
                    padding: EdgeInsets.all(16.0),
                    child: Image(
                        width: 200,
                        height: 200,
                        image:
                            AssetImage('assets/images/phillip_profile.jpg'))))),
        Center(
            child: Card(
                margin: EdgeInsets.all(10.0),
                color: Color.fromRGBO(1, 2, 3, 10),
                child: Padding(
                    padding: EdgeInsets.all(16.0),
                    child: Image(
                        width: 300,
                        height: 300,
                        image:
                            AssetImage('assets/images/phillip_profile.jpg'))))),
        Center(
            child: Card(
                margin: EdgeInsets.all(10.0),
                color: Colors.cyan,
                child: Padding(
                    padding: EdgeInsets.all(16.0),
                    child: Text("helloorfrgvdfvsfvsoo"))))
      ]),
      floatingActionButton: FloatingActionButton(
        onPressed: _navigateToDoEntry,
        tooltip: 'Add task',
        child: Icon(Icons.add),
      ),
    );
  }
}

import 'package:flutter/material.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Tutorial App',
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
    var screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: AppBar(title: Text('Tutorial App')),
      body: ListView(children: [
        Card(
            margin: EdgeInsets.fromLTRB(0.0, 20.0, 0.0, 20.0),
            color: Colors.white,
            child: Column(children: [
              Padding(
                  padding: EdgeInsets.fromLTRB(
                      0.0, (screenHeight * 0.1), 0.0, (screenHeight * 0.2)),
                  child: Image(
                      fit: BoxFit.cover,
                      width: double.infinity,
                      image: AssetImage('assets/images/phillip_profile.jpg')))
            ])),
      ]),
      floatingActionButton: FloatingActionButton(
        onPressed: _navigateToDoEntry,
        tooltip: 'Add task',
        child: Icon(Icons.add),
      ),
    );
  }
}

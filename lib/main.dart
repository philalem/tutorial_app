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
              ListTile(
                  title: Text("Profile Name"),
                  leading: IconButton(
                    icon: Icon(Icons.portrait),
                    onPressed: () {
                      print("Pressed Profile");
                    },
                  ),
                  trailing: IconButton(
                      icon: Icon(Icons.more_vert),
                      onPressed: () {
                        print("Pressed More");
                      })),
              Image(
                  fit: BoxFit.cover,
                  width: double.infinity,
                  image: AssetImage('assets/images/phillip_profile.jpg')),
              Padding(
                  padding: EdgeInsets.fromLTRB(
                      screenHeight * 0.02,
                      screenHeight * 0.02,
                      screenHeight * 0.02,
                      screenHeight * 0.02),
                  child: Text(
                      "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum."))
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

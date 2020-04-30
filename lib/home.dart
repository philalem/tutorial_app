import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:tutorial_app/video-player.dart';

class Home extends StatefulWidget {
  @override
  createState() => _HomeState();
}

class _HomeState extends State<Home> {
  var _navBarItemIndex = 1;

  void _onNavBarItemTapped(int index) {
    setState(() {
      _navBarItemIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    var screenHeight = MediaQuery.of(context).size.height;
    var listCardHeight = screenHeight * 0.02;
    SystemChrome.setEnabledSystemUIOverlays([]);

    return Scaffold(
      resizeToAvoidBottomPadding: false,
      appBar: AppBar(title: Text("Explore")),
      body: ListView.separated(
        separatorBuilder: (context, index) => Divider(
          color: Colors.blueGrey,
        ),
        itemCount: 10,
        itemBuilder: (context, index) => InkWell(
          child: ListTile(
            title: Padding(
              padding: EdgeInsets.symmetric(vertical: listCardHeight),
              child: Text(
                'Item $index',
                style: Theme.of(context).textTheme.headline,
              ),
            ),
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute(builder: (context) {
                  return VideoPlayerScreen();
                }),
              );
            },
          ),
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.lightBlue,
        type: BottomNavigationBarType.fixed,
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.view_stream),
            title: Text('Feed'),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.search),
            title: Text('Explore'),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.camera),
            title: Text('Create'),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.notifications),
            title: Text('Notifications'),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.portrait),
            title: Text('Profile'),
          ),
        ],
        currentIndex: _navBarItemIndex,
        selectedItemColor: Colors.amber[800],
        onTap: _onNavBarItemTapped,
      ),
    );
  }
}

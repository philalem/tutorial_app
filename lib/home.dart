import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:tutorial_app/camerascreen/camera_screen.dart';
import 'package:tutorial_app/create.dart';
import 'package:tutorial_app/explore.dart';

class Home extends StatefulWidget {
  @override
  createState() => _HomeState();
}

class _HomeState extends State<Home> {
  var _navBarItemIndex = 0;
  final List<Widget> _pages = [
    Explore(),
    Explore(),
    Explore(),
    Explore(),
    Create(),
  ];

  void _onNavBarItemTapped(int index) {
    if (index == 2) {
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) {
            return CameraScreen();
          },
        ),
      );
    } else {
      setState(() {
        _navBarItemIndex = index;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    var screenHeight = MediaQuery.of(context).size.height;
    var listCardHeight = screenHeight * 0.02;
    SystemChrome.setEnabledSystemUIOverlays([]);

    return Scaffold(
      resizeToAvoidBottomPadding: false,
      appBar: AppBar(
        title: Text("Creaid"),
        centerTitle: true,
      ),
      body: _pages[_navBarItemIndex],
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

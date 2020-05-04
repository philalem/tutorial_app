import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:tutorial_app/camerascreen/camera_screen.dart';
import 'package:tutorial_app/explore.dart';
import 'package:tutorial_app/notifications.dart';
import 'package:tutorial_app/profile.dart';
import 'package:tutorial_app/video-player.dart';

class Home extends StatefulWidget {
  @override
  createState() => _HomeState();
}

class _HomeState extends State<Home> {
  var _navBarItemIndex = 1;
  final List<Widget> _pages = [
    Explore(),
    Explore(),
    Explore(),
    Notifications(),
    Profile(),
  ];

  void _onNavBarItemTapped(int index) {
    if (index == 2) {
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) {
            print("opening camera");
            return CameraScreen();
          },
        ),
      );
    } else if (index == 0) {
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) {
            print("opening video stream");
            return VideoPlayerScreen();
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
    SystemChrome.setEnabledSystemUIOverlays([SystemUiOverlay.top]);
    return Scaffold(
      resizeToAvoidBottomPadding: false,
      appBar: AppBar(
        title: Container(
          height: 60,
          width: 150,
          child: Image.asset(
            "assets/images/logo.png",
            fit: BoxFit.contain,
          ),
        ),
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
            title: Text('Alerts'),
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

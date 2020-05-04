import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:tutorial_app/camerascreen/camera_screen.dart';
import 'package:tutorial_app/explore.dart';
import 'package:tutorial_app/notifications.dart';
import 'package:tutorial_app/profile.dart';
import 'package:tutorial_app/video-player.dart';
import 'package:google_fonts/google_fonts.dart';

class Home extends StatefulWidget {
  @override
  createState() => _HomeState();
}

class _HomeState extends State<Home> {
  var _navBarItemIndex = 1;
  final List<Widget> _pages = [
    VideoPlayerScreen(),
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
        title: Text(
          "Creaid",
          style: GoogleFonts.satisfy(
            fontSize: 42,
          ),
        ),
        centerTitle: true,
      ),
      body: _pages[_navBarItemIndex],
      bottomNavigationBar: BottomNavigationBar(
        showSelectedLabels: false,
        showUnselectedLabels: false,
        iconSize: 30,
        backgroundColor: Colors.lightBlue,
        type: BottomNavigationBarType.fixed,
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.view_stream),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.search),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.camera),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.notifications),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.portrait),
          ),
        ],
        currentIndex: _navBarItemIndex,
        selectedItemColor: Colors.amber[800],
        onTap: _onNavBarItemTapped,
      ),
    );
  }
}

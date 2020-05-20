import 'package:creaid/profile/dynamicProfile.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:creaid/camerascreen/camera_screen.dart';
import 'package:creaid/explore.dart';
import 'package:creaid/notifications.dart';
import 'package:creaid/video-player.dart';
import 'package:google_fonts/google_fonts.dart';

class Home extends StatefulWidget {
  @override
  createState() => _HomeState();
}

class _HomeState extends State<Home> {
  bool isSearching = false;
  var _navBarItemIndex = 1;
  final List<Widget> _pages = [
    VideoPlayerScreen(),
    Explore(),
    VideoPlayerScreen(),
    Notifications(),
    DynamicProfile()
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
        title: isSearching
            ? TextField(
                decoration: InputDecoration(
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.white),
                  ),
                  border: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.white),
                  ),
                  hintText: 'Search...',
                  hintStyle: TextStyle(
                    color: Colors.white,
                  ),
                ),
                style: TextStyle(
                  color: Colors.white,
                ),
              )
            : Text(
                "Creaid",
                style: GoogleFonts.satisfy(
                  fontSize: 34,
                ),
              ),
        actions: _navBarItemIndex == 1
            ? <Widget>[
                IconButton(
                  icon: Icon(
                    Icons.search,
                  ),
                  onPressed: () => {
                    setState(() {
                      isSearching = !isSearching;
                    })
                  },
                ),
              ]
            : [],
        centerTitle: true,
      ),
      body: _pages[_navBarItemIndex],
      bottomNavigationBar: BottomNavigationBar(
        showSelectedLabels: false,
        showUnselectedLabels: false,
        iconSize: 30,
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
        selectedItemColor: Colors.indigoAccent,
        onTap: _onNavBarItemTapped,
      ),
    );
  }
}

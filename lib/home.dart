import 'package:creaid/camerascreen/camera_screen.dart';
import 'package:creaid/explore.dart';
import 'package:creaid/notifications.dart';
import 'package:creaid/profile/dynamicProfile.dart';
import 'package:creaid/searchDisplay.dart';
import 'package:creaid/video-player.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class Home extends StatefulWidget {
  @override
  createState() => _HomeState();
}

GlobalKey<NavigatorState> _navigatorGlobalKey = GlobalKey<NavigatorState>();

class _HomeState extends State<Home> {
  var _navBarItemIndex = 1;

  final List<Widget> _pages = [
    VideoPlayerScreen(),
    Explore(navigatorKey: _navigatorGlobalKey),
    null,
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
      body: Navigator(
        key: _navigatorGlobalKey,
        onGenerateRoute: (RouteSettings settings) {
          return MaterialPageRoute(
            builder: (BuildContext context) {
              switch (settings.name) {
                case '/':
                  return _pages[_navBarItemIndex];
                case '/profile':
                  return Notifications();
                default:
                  throw UnimplementedError();
              }
            },
          );
        },
      ),
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
            icon: Icon(Icons.explore),
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

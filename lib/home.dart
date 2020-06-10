import 'package:creaid/camerascreen/camera_screen.dart';
import 'package:creaid/explore.dart';
import 'package:creaid/feed/feed.dart';
import 'package:creaid/notifications/notifications.dart';
import 'package:creaid/profile/profile.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class Home extends StatefulWidget {
  @override
  createState() => _HomeState();
}

class _HomeState extends State<Home> {
  var _navBarItemIndex = 1;

  final List<Widget> _pages = [
    Navigator(
      onGenerateRoute: (RouteSettings settings) {
        return MaterialPageRoute(
          settings: settings,
          builder: (BuildContext context) {
            switch (settings.name) {
              case '/':
                return Feed();
              default:
                throw UnimplementedError();
            }
          },
        );
      },
    ),
    Navigator(
      onGenerateRoute: (RouteSettings settings) {
        return MaterialPageRoute(
          settings: settings,
          builder: (BuildContext context) {
            switch (settings.name) {
              case '/':
                return Explore();
              default:
                throw UnimplementedError();
            }
          },
        );
      },
    ),
    Navigator(
      onGenerateRoute: (RouteSettings settings) {
        return MaterialPageRoute(
          settings: settings,
          builder: (BuildContext context) {
            switch (settings.name) {
              case '/':
                return Explore();
              default:
                throw UnimplementedError();
            }
          },
        );
      },
    ),
    Navigator(
      onGenerateRoute: (RouteSettings settings) {
        return MaterialPageRoute(
          settings: settings,
          builder: (BuildContext context) {
            switch (settings.name) {
              case '/':
                return Notifications();
              default:
                throw UnimplementedError();
            }
          },
        );
      },
    ),
    Navigator(
      onGenerateRoute: (RouteSettings settings) {
        return MaterialPageRoute(
          settings: settings,
          builder: (BuildContext context) {
            switch (settings.name) {
              case '/':
                return Profile();
              default:
                throw UnimplementedError();
            }
          },
        );
      },
    ),
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
    const IconData lightBulb = const IconData(0xf452,
        fontFamily: CupertinoIcons.iconFont,
        fontPackage: CupertinoIcons.iconFontPackage);
    const IconData globe = const IconData(0xf38c,
        fontFamily: CupertinoIcons.iconFont,
        fontPackage: CupertinoIcons.iconFontPackage);
    const IconData camera = const IconData(0xf2d3,
        fontFamily: CupertinoIcons.iconFont,
        fontPackage: CupertinoIcons.iconFontPackage);

    return Scaffold(
      resizeToAvoidBottomPadding: false,
      body: IndexedStack(
        index: _navBarItemIndex,
        children: _pages,
      ),
      bottomNavigationBar: BottomNavigationBar(
        showSelectedLabels: false,
        showUnselectedLabels: false,
        selectedIconTheme: IconThemeData(size: 34),
        iconSize: 30,
        type: BottomNavigationBarType.fixed,
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(lightBulb),
            title: Text('Feed'),
          ),
          BottomNavigationBarItem(
            icon: Icon(globe),
            title: Text('Explore'),
          ),
          BottomNavigationBarItem(
            icon: Icon(camera),
            title: Text('Create'),
          ),
          BottomNavigationBarItem(
            icon: Icon(CupertinoIcons.bell_solid),
            title: Text('Alerts'),
          ),
          BottomNavigationBarItem(
            icon: Icon(CupertinoIcons.profile_circled),
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

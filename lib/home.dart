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
        return CupertinoPageRoute(
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
        return CupertinoPageRoute(
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
        return CupertinoPageRoute(
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
        return CupertinoPageRoute(
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
        return CupertinoPageRoute(
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
        CupertinoPageRoute(
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
      resizeToAvoidBottomInset: true,
      //TODO: turn this into cupertino tab view
      body: IndexedStack(
        index: _navBarItemIndex,
        children: _pages,
      ),
      bottomNavigationBar: CupertinoTabBar(
        backgroundColor: Colors.white,
        activeColor: Colors.indigoAccent,
        inactiveColor: Colors.grey,
        iconSize: 30,
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(lightBulb),
          ),
          BottomNavigationBarItem(
            icon: Icon(globe),
          ),
          BottomNavigationBarItem(
            icon: Icon(camera),
          ),
          BottomNavigationBarItem(
            icon: Icon(CupertinoIcons.bell_solid),
          ),
          BottomNavigationBarItem(
            icon: Icon(CupertinoIcons.profile_circled),
          ),
        ],
        currentIndex: _navBarItemIndex,
        onTap: _onNavBarItemTapped,
      ),
    );
  }
}

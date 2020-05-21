import 'package:creaid/profile/dynamicProfile.dart';
import 'dart:ui';

import 'package:creaid/searchDisplay.dart';
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

GlobalKey<NavigatorState> _navigatorGlobalKey = GlobalKey<NavigatorState>();

class _HomeState extends State<Home> {
  bool _isSearching = false;
  TextEditingController _searchController = TextEditingController();
  SearchDisplay _searchDisplay = SearchDisplay();

  var _navBarItemIndex = 1;
  final List<Widget> _pages = [
    VideoPlayerScreen(),
    Explore(),
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
        _isSearching = false;
        _navBarItemIndex = index;
      });
    }
  }

  Widget _displaySearchScreen() {
    _searchDisplay.navigatorKey = _navigatorGlobalKey;
    _searchDisplay.searchTextController = _searchController;
    return _searchDisplay;
  }

  Widget _homeTabs(screenHeight, screenWidth) {
    return Stack(
      fit: StackFit.expand,
      children: <Widget>[
        AnimatedOpacity(
          opacity: _isSearching ? 0.5 : 0,
          duration: Duration(milliseconds: 200),
          child: Container(
            color: Colors.black,
            height: screenHeight,
            width: screenWidth,
          ),
        ),
        _pages[_navBarItemIndex],
        _isSearching ? _displaySearchScreen() : SizedBox(),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    var focusNode = new FocusNode();
    var screenHeight = MediaQuery.of(context).size.height;
    var screenWidth = MediaQuery.of(context).size.width;
    SystemChrome.setEnabledSystemUIOverlays([SystemUiOverlay.top]);

    return Scaffold(
      resizeToAvoidBottomPadding: false,
      appBar: AppBar(
        title: Stack(
          children: <Widget>[
            AnimatedOpacity(
                opacity: _isSearching ? 1 : 0,
                duration: Duration(milliseconds: 200),
                child: TextField(
                  controller: _searchController,
                  focusNode: focusNode,
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
                )),
            Align(
              alignment: Alignment.center,
              child: AnimatedOpacity(
                opacity: _isSearching ? 0 : 1,
                duration: Duration(milliseconds: 200),
                child: Text(
                  "Creaid",
                  style: GoogleFonts.satisfy(
                    fontSize: 34,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          ],
        ),
        actions: <Widget>[
          Stack(
            children: <Widget>[
              AnimatedOpacity(
                opacity: _navBarItemIndex == 1 ? 1 : 0,
                duration: Duration(milliseconds: 200),
                child: IconButton(
                  iconSize: 30,
                  icon: Icon(
                    Icons.search,
                  ),
                  onPressed: () {
                    focusNode.requestFocus();
                    setState(() {
                      _isSearching = !_isSearching;
                    });
                  },
                ),
              ),
              AnimatedOpacity(
                opacity: _navBarItemIndex == 1 ? 0 : 1,
                duration: Duration(milliseconds: 200),
                child: SizedBox(),
              ),
            ],
          ),
        ],
        centerTitle: true,
      ),
      body: Navigator(
          key: _navigatorGlobalKey,
          onGenerateRoute: (RouteSettings settings) {
            return MaterialPageRoute(builder: (BuildContext context) {
              switch (settings.name) {
                case '/':
                  return _homeTabs(screenHeight, screenWidth);
                case '/profile':
                  print('profile');
                  break;
                //return Profile();
                default:
                  throw UnimplementedError();
              }
            });
          }),
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

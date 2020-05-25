import 'package:creaid/searchDisplay.dart';
import 'package:creaid/video-player.dart';
import 'package:flutter/material.dart';

class Explore extends StatefulWidget {
  GlobalKey<NavigatorState> navigatorKey;
  Explore({this.navigatorKey});

  @override
  createState() => _ExploreState();
}

class _ExploreState extends State<Explore> {
  bool _isSearching = false;
  TextEditingController _searchController = TextEditingController();
  SearchDisplay _searchDisplay = SearchDisplay();
  FocusNode focusNode;

  @override
  void initState() {
    super.initState();
    focusNode = FocusNode();
  }

  @override
  void dispose() {
    _searchController.dispose();
    focusNode.dispose();
    super.dispose();
  }

  Widget _getSearchOrExplore(screenHeight, screenWidth) {
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
        ListView.separated(
          separatorBuilder: (context, index) => Divider(
            color: Colors.grey[400],
          ),
          itemCount: 20,
          itemBuilder: (context, index) => InkWell(
            child: ListTile(
              title: Padding(
                padding: EdgeInsets.all(5),
                child: Text(
                  'Item $index',
                ),
              ),
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) {
                      return VideoPlayerScreen();
                    },
                  ),
                );
              },
            ),
          ),
        ),
        _isSearching ? _displaySearchScreen() : Container(),
      ],
    );
  }

  Widget _displaySearchScreen() {
    _searchDisplay.navigatorKey = widget.navigatorKey;
    _searchDisplay.searchTextController = _searchController;
    return _searchDisplay;
  }

  @override
  Widget build(BuildContext context) {
    var screenHeight = MediaQuery.of(context).size.height;
    var screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        title: TextField(
          onTap: () {
            setState(() {
              _isSearching = true;
            });
          },
          cursorColor: Colors.white,
          showCursor: _isSearching,
          autofocus: false,
          controller: _searchController,
          focusNode: focusNode,
          decoration: InputDecoration(
            contentPadding: EdgeInsets.symmetric(
              vertical: 0,
            ),
            filled: true,
            fillColor: Colors.indigo[400],
            prefixIcon: Icon(
              Icons.search,
              color: Colors.white,
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide(
                width: 0,
                style: BorderStyle.none,
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide(
                width: 0,
                style: BorderStyle.none,
              ),
            ),
            hintText: 'Search...',
            hintStyle: TextStyle(
              color: Colors.white,
            ),
          ),
          style: TextStyle(
            color: Colors.white,
          ),
        ),
        leading: IconButton(
          iconSize: 30,
          icon: Icon((_isSearching ? Icons.close : Icons.search)),
          onPressed: () {
            focusNode.requestFocus();
            setState(() {
              _isSearching = !_isSearching;
            });
          },
        ),
        actions: <Widget>[
          IconButton(
            iconSize: 30,
            icon: Icon(Icons.message),
            onPressed: () {},
          ),
        ],
      ),
      body: _getSearchOrExplore(screenHeight, screenWidth),
    );
  }
}

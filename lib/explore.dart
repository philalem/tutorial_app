import 'package:creaid/searchDisplay.dart';
import 'package:flutter/material.dart';
import 'package:creaid/video-player.dart';
import 'package:google_fonts/google_fonts.dart';

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
        AnimatedOpacity(
          opacity: _isSearching ? 1 : 0,
          duration: Duration(milliseconds: 200),
          child: _displaySearchScreen(),
        ),
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
    var focusNode = new FocusNode();

    return Scaffold(
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
              ),
            ),
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
          IconButton(
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
        ],
        centerTitle: true,
      ),
      body: _getSearchOrExplore(screenHeight, screenWidth),
    );
  }
}

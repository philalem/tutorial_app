import 'package:algolia/algolia.dart';
import 'package:creaid/notifications.dart';
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
  FocusNode focusNode;
  var _searchResults = [];

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
    var children2 = <Widget>[
      AnimatedOpacity(
        opacity: _isSearching ? 0.5 : 0,
        duration: Duration(milliseconds: 200),
        child: Container(
          color: Colors.black,
          height: screenHeight,
          width: screenWidth,
        ),
      ),
      _displayExploreScreen(),
      _isSearching ? _displaySearchScreen() : Container(),
    ];
    return Stack(
      fit: StackFit.expand,
      children: children2,
    );
  }

  Widget _displayExploreScreen() {
    return ListView.separated(
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
    );
  }

  Widget _displaySearchScreen() {
    return ListView.builder(
      itemCount: _searchResults.length,
      itemBuilder: (context, index) {
        AlgoliaObjectSnapshot snap = _searchResults[index];

        return InkWell(
          child: Card(
            color: Colors.white,
            child: ListTile(
              title: Text(snap.data['name']),
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => Notifications(),
                  ),
                );
              },
            ),
          ),
        );
      },
    );
  }

  void _searchForUsers() async {
    Algolia algolia = Algolia.init(
      applicationId: 'JRNVNTRH9V',
      apiKey: '409b8ed6d2483d5d25b3d738bd9a48ed',
    );

    AlgoliaQuery query = algolia.instance.index('users').setHitsPerPage(5);
    query = query.search(_searchController.text);
    _searchResults = (await query.getObjects()).hits;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    var screenHeight = MediaQuery.of(context).size.height;
    var screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        title: TextField(
          onChanged: (value) => _searchForUsers(),
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
            icon: Icon(Icons.add),
            onPressed: () {},
          ),
        ],
      ),
      body: _getSearchOrExplore(screenHeight, screenWidth),
    );
  }
}

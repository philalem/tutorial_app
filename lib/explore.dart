import 'package:algolia/algolia.dart';
import 'package:creaid/profile/dynamicProfile.dart';
import 'package:creaid/utility/algoliaService.dart';
import 'package:creaid/video-player.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class Explore extends StatefulWidget {
  @override
  createState() => _ExploreState();
}

class _ExploreState extends State<Explore> {
  bool _isSearching = false;
  TextEditingController _searchController = TextEditingController();
  AlgoliaService algoliaService = AlgoliaService();
  FocusNode focusNode;
  var _searchResults = [];
  FirebaseUser userName;

  @override
  void initState() {
    focusNode = FocusNode();
    _loadCurrentUser();
    super.initState();
  }

  Future<void> _loadCurrentUser() async {
    return await FirebaseAuth.instance.currentUser().then((FirebaseUser user) {
      setState(() {
        userName = user;
      });
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    focusNode.dispose();
    super.dispose();
  }

  Widget _getSearchOrExplore(screenHeight, screenWidth) {
    var children = <Widget>[
      _displayExploreScreen(screenWidth),
      AnimatedSwitcher(
        duration: Duration(milliseconds: 200),
        child: _getSearchDisplayWithBackground(screenWidth, screenHeight),
      ),
    ];
    return Stack(
      fit: StackFit.expand,
      children: children,
    );
  }

  Widget _getSearchDisplayWithBackground(screenWidth, screenHeight) {
    if (!_isSearching) {
      return Container();
    }

    return Stack(
      fit: StackFit.expand,
      children: [
        Container(
          color: Colors.black.withOpacity(0.5),
          height: screenHeight,
          width: screenWidth,
        ),
        _displaySearchScreen(),
      ],
    );
  }

  Widget _displayExploreScreen(screenWidth) {
    return ListView(
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.only(bottom: 1.0),
          child: GestureDetector(
            onTap: () => _navigateToVideo(),
            child: Container(
              height: screenWidth,
              width: screenWidth,
              color: Colors.green,
              child: Center(
                child: Text('Main Container'),
              ),
            ),
          ),
        ),
        GridView.builder(
          physics: NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 4,
            crossAxisSpacing: 1.0,
            mainAxisSpacing: 1.0,
          ),
          itemCount: 20,
          itemBuilder: (context, index) {
            return GestureDetector(
              onTap: () => _navigateToVideo(),
              child: Container(
                color: Colors.green,
                child: Text("Index: $index"),
              ),
            );
          },
        ),
      ],
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
                    builder: (context) => DynamicProfile(
                      uid: snap.objectID,
                      name: snap.data['name'],
                      loggedInUid: userName.uid,
                    ),
                  ),
                );
              },
            ),
          ),
        );
      },
    );
  }

  _navigateToVideo() {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => VideoPlayerScreen(),
      ),
    );
  }

  void _searchForUsers() async {
    _searchResults =
        await algoliaService.searchForUsers(_searchController.text, 5);
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
          controller: _searchController,
          focusNode: focusNode,
          decoration: InputDecoration(
            contentPadding: EdgeInsets.symmetric(
              horizontal: 15,
              vertical: 0,
            ),
            filled: true,
            fillColor: Colors.indigo[400],
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

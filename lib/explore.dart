import 'package:algolia/algolia.dart';
import 'package:creaid/profile/dynamicProfile.dart';
import 'package:creaid/utility/algoliaService.dart';
import 'package:creaid/video-player.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
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
    const IconData exit = const IconData(0xf2d7,
        fontFamily: CupertinoIcons.iconFont,
        fontPackage: CupertinoIcons.iconFontPackage);

    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: CupertinoNavigationBar(
        leading: SizedBox(width: 20),
        trailing: SizedBox(width: 20),
        padding: EdgeInsetsDirectional.only(end: 0, start: 0),
        backgroundColor: Colors.indigo,
        middle: IntrinsicHeight(
          child: TextField(
            textInputAction: TextInputAction.done,
            onSubmitted: (value) {
              focusNode.unfocus();
              setState(() {
                _isSearching = false;
              });
            },
            maxLines: 1,
            minLines: 1,
            onChanged: (value) => _searchForUsers(),
            onTap: () {
              focusNode.requestFocus();
              setState(() {
                _isSearching = true;
              });
            },
            cursorColor: Colors.white,
            controller: _searchController,
            focusNode: focusNode,
            decoration: InputDecoration(
              prefixIcon: Icon(
                CupertinoIcons.search,
                color: Colors.white,
              ),
              isDense: true,
              contentPadding: EdgeInsets.symmetric(
                vertical: 6,
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
              hintText: 'Search',
              hintStyle: TextStyle(
                color: Colors.white,
              ),
            ),
            style: TextStyle(
              color: Colors.white,
            ),
          ),
        ),
      ),
      body: _getSearchOrExplore(screenHeight, screenWidth),
    );
  }
}

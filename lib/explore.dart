import 'package:algolia/algolia.dart';
import 'package:creaid/profile/dynamicProfile.dart';
import 'package:creaid/utility/algoliaService.dart';
import 'package:creaid/utility/exploreDbService.dart';
import 'package:creaid/utility/user.dart';
import 'package:creaid/video-player.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

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

  Widget _getSearchOrExplore(screenHeight, screenWidth, uid) {
    var children = <Widget>[
      _displayExploreScreen(screenWidth, uid),
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
        _displaySearchResults(),
      ],
    );
  }

  Widget _displayExploreScreen(screenWidth, uid) {
    return StreamBuilder<List<dynamic>>(
        stream: ExploreDbService(uid: uid).getExplorePosts(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return loadingExplorePosts(screenWidth);
          }

          List data = snapshot.data;

          if (data.length < 1) {
            return Center(
              child: Column(
                children: <Widget>[
                  SizedBox(height: 50),
                  Text('Nothing to see here!'),
                ],
              ),
            );
          }

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
        });
  }

  ListView loadingExplorePosts(screenWidth) {
    return ListView(
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.only(bottom: 5.0),
          child: GestureDetector(
            onTap: () => _navigateToVideo(),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(10.0),
              child: Container(
                height: screenWidth,
                width: screenWidth,
                child: Center(
                  child: Text('Main Container'),
                ),
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(10.0),
                  border: Border.all(color: Colors.grey, width: 0.2),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black54,
                      offset: Offset(-1.0, 1.0),
                      blurRadius: 5.0,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
        GridView.builder(
          physics: NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 4,
            crossAxisSpacing: 5.0,
            mainAxisSpacing: 5.0,
          ),
          itemCount: 20,
          itemBuilder: (context, index) {
            return Container(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(10.0),
                child: Container(
                  child: Center(child: Text("Index: $index")),
                  decoration: BoxDecoration(
                    color: Colors.grey[300],
                    borderRadius: BorderRadius.circular(10.0),
                    border: Border.all(color: Colors.grey, width: 0.2),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black54,
                        offset: Offset(-1.0, 1.0),
                        blurRadius: 5.0,
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ],
    );
  }

  Widget _displaySearchResults() {
    return ListView.builder(
      itemCount: _searchResults.length,
      itemBuilder: (context, index) {
        AlgoliaObjectSnapshot snap = _searchResults[index];

        return Column(
          children: <Widget>[
            Container(
              color: Colors.white,
              child: ListTile(
                leading: CircleAvatar(
                    backgroundImage:
                        AssetImage('assets/images/unknown-profile.png')),
                title: Text(snap.data['name']),
                subtitle: Text(snap.data['username']),
                onTap: () {
                  Navigator.of(context).push(
                    CupertinoPageRoute(
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
            Container(
              color: Colors.white,
              child: Row(
                children: <Widget>[
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.only(left: 70),
                      child: Container(
                        height: 1,
                        color: Color(0xFFD9D9D9),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        );
      },
    );
  }

  _navigateToVideo() {
    Navigator.of(context).push(
      CupertinoPageRoute(
        builder: (context) => VideoPlayerScreen(),
      ),
    );
  }

  void _searchForUsers() async {
    _searchResults =
        _searchController.text.trim() == '' || _searchController.text == null
            ? []
            : await algoliaService.searchForUsers(_searchController.text, 5);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    var screenHeight = MediaQuery.of(context).size.height;
    var screenWidth = MediaQuery.of(context).size.width;
    final user = Provider.of<User>(context);
    var uid = user.uid;

    return CupertinoPageScaffold(
      resizeToAvoidBottomInset: false,
      navigationBar: CupertinoNavigationBar(
        leading: SizedBox(width: 20),
        trailing: SizedBox(width: 20),
        padding: EdgeInsetsDirectional.only(end: 0, start: 0),
        backgroundColor: Colors.indigo,
        middle: IntrinsicHeight(
          child: CupertinoTextField(
            textAlignVertical: TextAlignVertical.center,
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
            prefix: Padding(
              padding: const EdgeInsets.only(left: 6),
              child: Icon(
                CupertinoIcons.search,
                color: Colors.white,
              ),
            ),
            placeholder: 'Search',
            placeholderStyle: TextStyle(color: Colors.white54),
            decoration: BoxDecoration(
              color: Colors.indigo[400],
              borderRadius: BorderRadius.all(Radius.circular(5.0)),
            ),
            style: TextStyle(
              color: Colors.white,
            ),
          ),
        ),
      ),
      child: _getSearchOrExplore(screenHeight, screenWidth, uid),
    );
  }
}

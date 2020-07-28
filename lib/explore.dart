import 'package:algolia/algolia.dart';
import 'package:creaid/feed/FeedVideoPlayer.dart';
import 'package:creaid/profile/dynamicProfile.dart';
import 'package:creaid/profile/post.dart';
import 'package:creaid/utility/UserData.dart';
import 'package:creaid/utility/algoliaService.dart';
import 'package:creaid/utility/exploreDbService.dart';
import 'package:creaid/utility/user.dart';
import 'package:creaid/utility/userDBService.dart';
import 'package:creaid/video-player.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

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
  RefreshController _refreshController =
      RefreshController(initialRefresh: false);
  UserData userData;

  @override
  void initState() {
    focusNode = FocusNode();
    focusNode.addListener(() {
      if (!focusNode.hasFocus) {
        setState(() {});
      }
    });
    _loadCurrentUser();
    super.initState();
  }

  Future<void> _loadCurrentUser() async {
    await FirebaseAuth.instance.currentUser().then((FirebaseUser user) {
      setState(() async {
        userName = user;
        userData = await UserDbService(uid: userName.uid).getUserFuture();
      });
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    focusNode.dispose();
    super.dispose();
  }

  void _onRefresh() async {
    await Future.delayed(Duration(milliseconds: 1000));
    _refreshController.refreshCompleted();
  }

  void _onLoading() async {
    setState(() {});
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
    if (!_isSearching || !focusNode.hasFocus) {
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
    return FutureBuilder<List<Post>>(
      future: ExploreDbService(uid: uid).getExplorePosts(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return loadingExplorePosts(screenWidth);
        }

        List<Post> data = snapshot.data;

        if (data.length < 1) {
          return SmartRefresher(
            enablePullDown: true,
            header: ClassicHeader(),
            controller: _refreshController,
            onRefresh: _onRefresh,
            onLoading: _onLoading,
            child: Center(
              child: Column(
                children: <Widget>[
                  SizedBox(height: 50),
                  Text('Nothing to see here!'),
                ],
              ),
            ),
          );
        }

        return SmartRefresher(
          enablePullDown: true,
          header: ClassicHeader(),
          controller: _refreshController,
          onRefresh: _onRefresh,
          onLoading: _onLoading,
          child: ListView(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.only(bottom: 1.0),
                child: GestureDetector(
                  onTap: () => _navigateToVideo(data[0].videos),
                  child: Container(
                    height: screenWidth,
                    width: screenWidth,
                    color: Colors.grey[300],
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(10.0),
                      child: Image.network(
                        data[0].thumbnail,
                        fit: BoxFit.cover,
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
                  crossAxisSpacing: 1.0,
                  mainAxisSpacing: 1.0,
                ),
                itemCount: data.length - 1,
                itemBuilder: (context, index) {
                  return GestureDetector(
                    onTap: () => _navigateToVideo(data[index + 1].videos),
                    child: Container(
                      color: Colors.grey[300],
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(10.0),
                        child: Image.network(
                          data[index + 1].thumbnail,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  );
                },
              ),
            ],
          ),
        );
      },
    );
  }

  ListView loadingExplorePosts(screenWidth) {
    return ListView(
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.only(bottom: 5.0),
          child: GestureDetector(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(10.0),
              child: Container(
                height: screenWidth,
                width: screenWidth,
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(10.0),
                  border: Border.all(color: Colors.grey, width: 0.2),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black54,
                      offset: Offset(-1.0, 1.0),
                      blurRadius: 1.0,
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

  _navigateToVideo(videos) {
    Navigator.of(context).push(
      CupertinoPageRoute(
        builder: (context) => FeedVideoPlayer(
          videos: videos,
          feedId: userName.uid,
          userData: userData,
        ),
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
      resizeToAvoidBottomInset: true,
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

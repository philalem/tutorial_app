import 'dart:io';

import 'package:creaid/feed/FeedVideoPlayer.dart';
import 'package:creaid/feed/VideoFeedObject.dart';
import 'package:creaid/profile/DisplayFollow.dart';
import 'package:creaid/profile/editProfile.dart';
import 'package:creaid/profile/profilePostsService.dart';
import 'package:creaid/utility/UserData.dart';
import 'package:creaid/utility/firebaseAuth.dart';
import 'package:creaid/utility/user.dart';
import 'package:creaid/utility/userDBService.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sticky_headers/sticky_headers.dart';

class Profile extends StatefulWidget {
  final String uid;
  final String username;

  Profile({this.uid, this.username});

  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  FirebaseUser userName;
  String photoUrl;
  UserData userData;

  @override
  void initState() {
    _loadCurrentUser();
    super.initState();
  }

  Future<void> _loadCurrentUser() async {
    await FirebaseAuth.instance.currentUser().then((FirebaseUser user) {
      this.userName = user;
    });
    userData = await UserDbService(uid: userName.uid).getUserFuture();
    setState(() {});
  }

  String _getLoadedName() {
    if (userName != null) {
      if (userName.uid != null) {
        return userName.displayName;
      }
    }
    setState(() {
      _loadCurrentUser();
    });
    return '';
  }

  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    double height = size.height;
    double width = size.width;
    final user = Provider.of<User>(context);
    var uid = user.uid;
    const IconData threeDots = const IconData(0xf46a,
        fontFamily: CupertinoIcons.iconFont,
        fontPackage: CupertinoIcons.iconFontPackage);

    return CupertinoPageScaffold(
      backgroundColor: Colors.white,
      navigationBar: CupertinoNavigationBar(
        backgroundColor: Colors.indigo,
        middle: Text(
          _getLoadedName(),
          style: TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.normal,
          ),
        ),
        trailing: CupertinoButton(
          padding: EdgeInsets.zero,
          child: Icon(
            threeDots,
            size: 35,
            color: Colors.white,
          ),
          onPressed: () => _showLogoutPopUp(context),
        ),
      ),
      child: StreamBuilder<UserData>(
        stream: UserDbService(uid: uid).getNames(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Align(
                alignment: Alignment.center,
                child: CupertinoActivityIndicator());
          }
          UserData data = snapshot.data;
          return ListView(
            children: <Widget>[
              Container(
                color: Colors.grey[200],
                width: width,
                child: Padding(
                  padding: EdgeInsets.only(left: 20.0, right: 20.0, top: 15),
                  child: Column(
                    children: <Widget>[
                      Container(
                        height: height * 0.15,
                        child: Row(
                          children: <Widget>[
                            Expanded(
                              flex: 8,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisSize: MainAxisSize.min,
                                children: <Widget>[
                                  Expanded(
                                    flex: 3,
                                    child: FittedBox(
                                      fit: BoxFit.contain,
                                      child: Text(
                                        data.username,
                                        style: TextStyle(
                                            color: Colors.black,
                                            fontSize: 22,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                    flex: 4,
                                    child: followerRow(data, uid),
                                  ),
                                  Expanded(
                                    flex: 3,
                                    child: editButton(context, data),
                                  ),
                                ],
                              ),
                            ),
                            Expanded(
                              flex: 6,
                              child: FittedBox(
                                fit: BoxFit.contain,
                                alignment: Alignment.centerRight,
                                child: userProfileImage(uid, data.photoUrl),
                              ),
                            ),
                          ],
                        ),
                      ),
                      userBio(data),
                    ],
                  ),
                ),
              ),
              Container(
                width: MediaQuery.of(context).size.width,
                decoration: BoxDecoration(
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black38,
                      offset: Offset(0.0, -1.0),
                      blurRadius: 1.0,
                    ),
                  ],
                ),
                child: ClipRRect(
                  clipBehavior: Clip.hardEdge,
                  child: Column(
                    children: <Widget>[
                      // TODO: backlog item
                      // userCollections(),
                      StickyHeader(
                        header: Container(
                          height: 40,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            border: Border(
                              bottom: BorderSide(
                                color: Colors.black,
                                width: 0.1,
                              ),
                            ),
                          ),
                          padding: EdgeInsets.symmetric(horizontal: 16.0),
                          alignment: Alignment.center,
                          child: Text(
                            "All Posts",
                            style: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                              fontSize: 18,
                            ),
                          ),
                        ),
                        content: userPostsGrid(user),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Container userPostsGrid(User user) {
    return Container(
      margin: EdgeInsets.symmetric(
        horizontal: 20.0,
      ),
      child: Column(
        children: <Widget>[
          SizedBox(
            height: 30,
          ),
          StreamBuilder<Object>(
              stream: ProfilePostsService(uid: user.uid).getProfilePosts(),
              builder: (context, snapshot) {
                if (!snapshot.hasData)
                  return Align(
                    alignment: Alignment.center,
                    child: CupertinoActivityIndicator(),
                  );

                List<VideoFeedObject> posts = snapshot.data;
                if (posts.length < 1) {
                  return Center(
                    child: Container(
                      child: Text(
                        'You don\'t have any posts yet. Try making a post by clicking the camera button on the bottom navigation bar.',
                        textAlign: TextAlign.center,
                      ),
                    ),
                  );
                }
                return GridView.builder(
                  physics: NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 4,
                    crossAxisSpacing: 5.0,
                    mainAxisSpacing: 5.0,
                  ),
                  itemCount: posts.length,
                  itemBuilder: (context, index) {
                    return GestureDetector(
                      onTap: () => _navigateToVideo(posts[index]),
                      child: Container(
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(10.0),
                          child: posts[index].thumbnail != null
                              ? FadeInImage(
                                  fit: BoxFit.cover,
                                  image: NetworkImage(posts[index].thumbnail),
                                  placeholder: AssetImage(
                                      'assets/images/unknown-profile.png'),
                                )
                              : Image.asset(
                                  'assets/images/unknown-profile.png',
                                  fit: BoxFit.cover,
                                ),
                        ),
                      ),
                    );
                  },
                );
              }),
          SizedBox(
            height: 30,
          )
        ],
      ),
    );
  }

  StickyHeader userCollections() {
    return StickyHeader(
      header: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border(bottom: BorderSide(color: Colors.black, width: 0.1)),
        ),
        height: 40,
        padding: EdgeInsets.symmetric(horizontal: 16.0),
        alignment: Alignment.center,
        child: Text(
          "Collections",
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
      ),
      content: Column(
        children: <Widget>[
          SizedBox(
            height: 30,
          ),
          Container(
            height: 300,
            child: ListView(
              scrollDirection: Axis.horizontal,
              children: <Widget>[
                _myAlbumCard(
                    "assets/images/phillip_profile.jpg",
                    "assets/images/phillip_profile.jpg",
                    "assets/images/phillip_profile.jpg",
                    "assets/images/phillip_profile.jpg",
                    "+178",
                    "Best Trip"),
                _myAlbumCard(
                    "assets/images/phillip_profile.jpg",
                    "assets/images/phillip_profile.jpg",
                    "assets/images/phillip_profile.jpg",
                    "assets/images/phillip_profile.jpg",
                    "+18",
                    "Hill Lake Tourism"),
                _myAlbumCard(
                    "assets/images/phillip_profile.jpg",
                    "assets/images/phillip_profile.jpg",
                    "assets/images/phillip_profile.jpg",
                    "assets/images/phillip_profile.jpg",
                    "+1288",
                    "The Grand Canyon"),
                SizedBox(
                  width: 100,
                ),
              ],
            ),
          ),
          SizedBox(
            height: 30,
          ),
        ],
      ),
    );
  }

  Padding userBio(UserData data) {
    return Padding(
      padding: EdgeInsets.only(
        top: 10,
        bottom: 20,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          Flexible(
            child: Text(
              data.bio != null && data.bio != ''
                  ? data.bio
                  : 'Welcome to my profile! 😊',
              softWrap: true,
              maxLines: null,
              style: TextStyle(
                color: Colors.black87,
                fontSize: 14,
              ),
            ),
          ),
        ],
      ),
    );
  }

  CircleAvatar userProfileImage(String uid, String photoUrl) {
    return CircleAvatar(
      backgroundColor: Colors.indigoAccent,
      radius: 85,
      child: ClipOval(
        child: Container(
          height: 160,
          width: 160,
          child: photoUrl != null && photoUrl != ''
              ? FadeInImage(
                  image: NetworkImage(photoUrl),
                  placeholder: AssetImage('assets/images/unknown-profile.png'),
                )
              : Image.asset('assets/images/unknown-profile.png'),
        ),
      ),
    );
  }

  FlatButton editButton(BuildContext context, UserData data) {
    return FlatButton(
      padding: EdgeInsets.only(top: 4),
      onPressed: () => Navigator.of(context).push(
        CupertinoPageRoute(
          builder: (context) => EditProfile(
            name: data.name,
            biography: data.bio,
            username: data.username,
            email: userName.email,
            profileImage: photoUrl,
          ),
        ),
      ),
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(color: Colors.black87),
          borderRadius: BorderRadius.circular(5.0),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 4.0),
          child: Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              FittedBox(
                fit: BoxFit.contain,
                child: Text(
                  "Edit ",
                  style: TextStyle(color: Colors.black87, fontSize: 16),
                ),
              ),
              FittedBox(
                fit: BoxFit.contain,
                child: Icon(
                  CupertinoIcons.pencil,
                  color: Colors.black87,
                  size: 16,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  _navigateToVideo(videos) {
    Navigator.of(context).push(
      CupertinoPageRoute(
        builder: (context) => FeedVideoPlayer(
          videos: [videos],
          feedId: userName.uid,
          userData: userData,
        ),
      ),
    );
  }

  Container followerRow(UserData data, String uid) {
    return Container(
      margin: EdgeInsets.only(top: 4),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          FittedBox(
            fit: BoxFit.contain,
            child: CupertinoButton(
              padding: EdgeInsets.zero,
              onPressed: () {
                Navigator.of(context).push(CupertinoPageRoute(
                    builder: (_) => DisplayFollow(
                          uid: uid,
                          isFollowers: false,
                        )));
              },
              child: Column(
                children: <Widget>[
                  Text(
                    data.numberFollowing.toString(),
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: 22,
                        fontWeight: FontWeight.bold),
                  ),
                  Text(
                    "Following",
                    style: TextStyle(
                      color: Colors.black87,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),
          ),
          Spacer(),
          FittedBox(
            fit: BoxFit.contain,
            child: CupertinoButton(
              padding: EdgeInsets.zero,
              onPressed: () {
                Navigator.of(context).push(CupertinoPageRoute(
                    builder: (_) => DisplayFollow(
                          uid: uid,
                          isFollowers: true,
                        )));
              },
              child: Column(
                children: <Widget>[
                  Text(
                    data.numberFollowers.toString(),
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: 22,
                        fontWeight: FontWeight.bold),
                  ),
                  Text(
                    "Followers",
                    style: TextStyle(
                      color: Colors.black87,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),
          ),
          Spacer(),
        ],
      ),
    );
  }

  _myAlbumCard(String asset1, String asset2, String asset3, String asset4,
      String more, String name) {
    return Padding(
      padding: const EdgeInsets.only(left: 40.0, bottom: 10),
      child: Container(
        height: 370,
        width: 250,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20.0),
          border: Border.all(color: Colors.grey, width: 0.2),
          boxShadow: [
            BoxShadow(
              color: Colors.black54,
              offset: Offset(0.0, 3.0),
              blurRadius: 3.0,
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Padding(
                padding: EdgeInsets.only(
                  left: 10.0,
                  bottom: 10,
                ),
                child: Text(
                  name,
                  style: TextStyle(
                      color: Colors.black,
                      fontSize: 16,
                      fontWeight: FontWeight.bold),
                ),
              ),
              Row(
                children: <Widget>[
                  ClipRRect(
                    borderRadius: BorderRadius.circular(10.0),
                    child: Image.asset(
                      asset1,
                      height: 110,
                      width: 110,
                      fit: BoxFit.cover,
                    ),
                  ),
                  Spacer(),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(10.0),
                    child: Image.asset(
                      asset2,
                      height: 110,
                      width: 110,
                      fit: BoxFit.cover,
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 10,
              ),
              Row(
                children: <Widget>[
                  ClipRRect(
                    borderRadius: BorderRadius.circular(10.0),
                    child: Image.asset(
                      asset3,
                      height: 110,
                      width: 110,
                      fit: BoxFit.cover,
                    ),
                  ),
                  Spacer(),
                  Stack(
                    overflow: Overflow.visible,
                    children: <Widget>[
                      ClipRRect(
                        borderRadius: BorderRadius.circular(10.0),
                        child: Image.asset(
                          asset4,
                          height: 110,
                          width: 110,
                          fit: BoxFit.cover,
                        ),
                      ),
                      Positioned(
                        child: Container(
                          height: 110,
                          width: 110,
                          decoration: BoxDecoration(
                            color: Colors.black38,
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                          child: Center(
                            child: Text(
                              more,
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 24,
                              ),
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  _showLogoutPopUp(context) {
    if (Platform.isAndroid) {
      showCupertinoDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text("Are you sure you want to log out?"),
            actions: <Widget>[
              // usually buttons at the bottom of the dialog
              FlatButton(
                padding: EdgeInsets.all(0),
                child: Text(
                  "Log out",
                  style: TextStyle(
                    color: Colors.blue,
                    fontSize: 16,
                  ),
                ),
                onPressed: () {
                  FireBaseAuthorization().signOut();
                  Navigator.of(context).pop();
                },
              ),
              FlatButton(
                padding: EdgeInsets.all(0),
                child: Text(
                  "Cancel",
                  style: TextStyle(
                    color: Colors.red,
                    fontSize: 16,
                  ),
                ),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        },
      );
    } else {
      showCupertinoModalPopup(
        context: context,
        builder: (context) {
          return CupertinoActionSheet(
            title: Text("Are you sure you want to log out?"),
            actions: <Widget>[
              // usually buttons at the bottom of the dialog
              CupertinoActionSheetAction(
                child: Text(
                  "Log out",
                ),
                onPressed: () {
                  FireBaseAuthorization().signOut();
                  Navigator.of(context).pop();
                },
                isDestructiveAction: true,
              ),
            ],
            cancelButton: CupertinoActionSheetAction(
              child: Text(
                "Cancel",
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          );
        },
      );
    }
  }
}

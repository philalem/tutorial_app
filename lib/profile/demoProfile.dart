import 'package:creaid/profile/editProfile.dart';
import 'package:creaid/profile/post.dart';
import 'package:creaid/profile/profilePhotoService.dart';
import 'package:creaid/profile/profilePostsService.dart';
import 'package:creaid/utility/UserData.dart';
import 'package:creaid/utility/user.dart';
import 'package:creaid/utility/userDBService.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sticky_headers/sticky_headers.dart';
import 'package:video_player/video_player.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return OrientationBuilder(
          builder: (context, orientation) {
            return CupertinoApp(
              debugShowCheckedModeBanner: false,
              home: ProfileFirst(),
            );
          },
        );
      },
    );
  }
}

class ProfileFirst extends StatefulWidget {
  final String uid;
  final String username;
  ProfileFirst({this.uid, this.username});

  @override
  _ProfileFirstState createState() => _ProfileFirstState();
}

class _ProfileFirstState extends State<ProfileFirst> {
  FirebaseUser userName;
  String photoUrl;

  @override
  void initState() {
    _loadCurrentUser();
    super.initState();
  }

  Future<void> _loadCurrentUser() async {
    return await FirebaseAuth.instance.currentUser().then((FirebaseUser user) {
      setState(() {
        this.userName = user;
      });
    });
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
    const IconData signOut = const IconData(0xf220,
        fontFamily: CupertinoIcons.iconFont,
        fontPackage: CupertinoIcons.iconFontPackage);

    return Scaffold(
      backgroundColor: Color(0xffF8F8FA),
      appBar: CupertinoNavigationBar(
        backgroundColor: Colors.indigo,
        middle: Text(
          _getLoadedName(),
          style: TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.normal,
          ),
        ),
      ),
      body: StreamBuilder<UserData>(
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
                  padding: EdgeInsets.only(left: 30.0, right: 30.0, top: 15),
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
                                    child: Container(
                                      margin: EdgeInsets.only(top: 4),
                                      child: Row(
                                        mainAxisSize: MainAxisSize.min,
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: <Widget>[
                                          FittedBox(
                                            fit: BoxFit.contain,
                                            child: Column(
                                              children: <Widget>[
                                                Text(
                                                  data.numberFollowing
                                                      .toString(),
                                                  style: TextStyle(
                                                      color: Colors.black,
                                                      fontSize: 22,
                                                      fontWeight:
                                                          FontWeight.bold),
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
                                          Spacer(),
                                          FittedBox(
                                            fit: BoxFit.contain,
                                            child: Column(
                                              children: <Widget>[
                                                Text(
                                                  data.numberFollowers
                                                      .toString(),
                                                  style: TextStyle(
                                                      color: Colors.black,
                                                      fontSize: 22,
                                                      fontWeight:
                                                          FontWeight.bold),
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
                                          Spacer(),
                                        ],
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                    flex: 3,
                                    child: FlatButton(
                                      padding: EdgeInsets.only(top: 4),
                                      onPressed: () =>
                                          Navigator.of(context).push(
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
                                          border:
                                              Border.all(color: Colors.black87),
                                          borderRadius:
                                              BorderRadius.circular(5.0),
                                        ),
                                        child: Padding(
                                          padding: const EdgeInsets.symmetric(
                                              vertical: 4.0),
                                          child: Row(
                                            mainAxisSize: MainAxisSize.max,
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: <Widget>[
                                              FittedBox(
                                                fit: BoxFit.contain,
                                                child: Text(
                                                  "Edit ",
                                                  style: TextStyle(
                                                      color: Colors.black87,
                                                      fontSize: 16),
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
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Expanded(
                              flex: 6,
                              child: FittedBox(
                                fit: BoxFit.contain,
                                alignment: Alignment.centerRight,
                                child: CircleAvatar(
                                  backgroundColor: Colors.indigoAccent,
                                  radius: 85,
                                  child: StreamBuilder<Object>(
                                      stream: ProfilePhotoService(uid: uid)
                                          .getProfilePhoto(),
                                      builder: (context, snapshot) {
                                        if (!snapshot.hasData)
                                          return Align(
                                            alignment: Alignment.center,
                                            child: CupertinoActivityIndicator(),
                                          );
                                        photoUrl = snapshot.data;
                                        return ClipOval(
                                          child: Container(
                                            height: 160,
                                            width: 160,
                                            child: photoUrl != null
                                                ? FadeInImage(
                                                    image:
                                                        NetworkImage(photoUrl),
                                                    placeholder: AssetImage(
                                                        'assets/images/unknown-profile.png'),
                                                  )
                                                : AssetImage(
                                                    'assets/images/unknown-profile.png'),
                                          ),
                                        );
                                      }),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(
                          top: 10,
                          bottom: 20,
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: <Widget>[
                            Flexible(
                              child: Text(
                                data.bio != null
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
                      ),
                    ],
                  ),
                ),
              ),
              Container(
                width: MediaQuery.of(context).size.width,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topRight: Radius.circular(30.0),
                    topLeft: Radius.circular(30.0),
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black54,
                      offset: Offset(0.0, 3.0),
                      blurRadius: 10.0,
                    ),
                  ],
                ),
                child: ClipRRect(
                  clipBehavior: Clip.hardEdge,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(30.0),
                    topRight: Radius.circular(30.0),
                  ),
                  child: Column(
                    children: <Widget>[
                      StickyHeader(
                        header: Container(
                          decoration: BoxDecoration(
                            color: Colors.white,
                            border: Border(
                                bottom: BorderSide(
                                    color: Colors.black, width: 0.1)),
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
                      ),
                      StickyHeader(
                        header: Container(
                          height: 40,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            border: Border(
                                bottom: BorderSide(
                                    color: Colors.black, width: 0.1)),
                          ),
                          padding: EdgeInsets.symmetric(horizontal: 16.0),
                          alignment: Alignment.center,
                          child: Text(
                            "All Posts",
                            style: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.bold,
                                fontSize: 18),
                          ),
                        ),
                        content: Column(
                          children: <Widget>[
                            SizedBox(
                              height: 30,
                            ),
                            StreamBuilder<Object>(
                                stream: ProfilePostsService(uid: user.uid)
                                    .getProfilePosts(),
                                builder: (context, snapshot) {
                                  if (!snapshot.hasData)
                                    return Align(
                                      alignment: Alignment.center,
                                      child: CupertinoActivityIndicator(),
                                    );
                                  List<Post> posts = snapshot.data;
                                  return GridView.builder(
                                    physics: NeverScrollableScrollPhysics(),
                                    shrinkWrap: true,
                                    gridDelegate:
                                        SliverGridDelegateWithFixedCrossAxisCount(
                                      crossAxisCount: 3,
                                      crossAxisSpacing: 5.0,
                                      mainAxisSpacing: 5.0,
                                    ),
                                    itemCount: posts.length,
                                    itemBuilder: (context, index) {
                                      return Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Container(
                                          child: ClipRRect(
                                            borderRadius:
                                                BorderRadius.circular(10.0),
                                            child: posts[index].thumbnail !=
                                                        null ||
                                                    posts[index].thumbnail != ''
                                                ? displayFadeInImage(
                                                    posts, index)
                                                : AssetImage(
                                                    'assets/images/unknown-profile.png'),
                                          ),
                                          decoration: BoxDecoration(
                                            color: Colors.grey,
                                            borderRadius:
                                                BorderRadius.circular(10.0),
                                            border: Border.all(
                                                color: Colors.grey, width: 0.2),
                                            boxShadow: [
                                              BoxShadow(
                                                color: Colors.black54,
                                                offset: Offset(-1.0, 1.0),
                                                blurRadius: 1.0,
                                              ),
                                            ],
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

  FadeInImage displayFadeInImage(List<Post> posts, int index) {
    try {
      return FadeInImage(
        image: NetworkImage(posts[index].thumbnail),
        placeholder: AssetImage('assets/images/unknown-profile.png'),
      );
    } catch (_) {
      return FadeInImage(
        image: AssetImage('assets/images/unknown-profile.png'),
        placeholder: AssetImage('assets/images/unknown-profile.png'),
      );
    }
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
}

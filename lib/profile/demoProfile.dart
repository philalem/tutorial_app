import 'package:creaid/utility/UserData.dart';
import 'package:creaid/utility/user.dart';
import 'package:creaid/utility/userDBService.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

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
    ScreenUtil.init(context);
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
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: StreamBuilder<UserData>(
        stream: UserDbService(uid: uid).getNames(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Align(
                alignment: Alignment.center,
                child: CircularProgressIndicator());
          }
          UserData data = snapshot.data;
          return Stack(
            overflow: Overflow.visible,
            children: <Widget>[
              Container(
                color: Colors.grey[200],
                height: height * 0.4,
                child: Padding(
                  padding: EdgeInsets.only(left: 30.0, right: 30.0, top: 30),
                  child: Column(
                    children: <Widget>[
                      Expanded(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Expanded(
                              flex: 6,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  FittedBox(
                                    fit: BoxFit.contain,
                                    child: Text(
                                      "Neil Sullivan Paul",
                                      style: TextStyle(
                                          color: Colors.black,
                                          fontSize: 26,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                  SizedBox(
                                    height: height * 0.008,
                                  ),
                                  Container(
                                    height: height * 0.1,
                                    child: Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: <Widget>[
                                        Expanded(
                                          child: Text(
                                            'Hello fellow CreAiders! I\'m Neil. I really like making tutorials and sharing with my friends!',
                                            softWrap: true,
                                            maxLines: 5,
                                            overflow: TextOverflow.ellipsis,
                                            style: TextStyle(
                                              color: Colors.black87,
                                              fontSize: 14,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Spacer(),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: <Widget>[
                                      FittedBox(
                                        fit: BoxFit.contain,
                                        child: Column(
                                          children: <Widget>[
                                            Text(
                                              data.numberFollowing.toString(),
                                              style: TextStyle(
                                                  color: Colors.black,
                                                  fontSize: 18,
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
                                      Spacer(),
                                      FittedBox(
                                        fit: BoxFit.contain,
                                        child: Column(
                                          children: <Widget>[
                                            Text(
                                              data.numberFollowers.toString(),
                                              style: TextStyle(
                                                  color: Colors.black,
                                                  fontSize: 18,
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
                                      Spacer(),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                            Expanded(
                              flex: 1,
                              child: SizedBox(),
                            ),
                            Expanded(
                              flex: 3,
                              child: Column(
                                children: <Widget>[
                                  FittedBox(
                                    fit: BoxFit.contain,
                                    child: CircleAvatar(
                                      backgroundColor: Colors.indigoAccent,
                                      radius: 55,
                                      child: CircleAvatar(
                                          radius: 50,
                                          backgroundImage: AssetImage(
                                              'assets/images/phillip_profile.jpg')),
                                    ),
                                  ),
                                  Spacer(),
                                  Container(
                                    decoration: BoxDecoration(
                                      border: Border.all(color: Colors.black87),
                                      borderRadius: BorderRadius.circular(5.0),
                                    ),
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Row(
                                        mainAxisSize: MainAxisSize.min,
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: <Widget>[
                                          Text(
                                            "Edit ",
                                            style: TextStyle(
                                                color: Colors.black87,
                                                fontSize: 12),
                                          ),
                                          Icon(
                                            CupertinoIcons.pencil,
                                            color: Colors.black87,
                                            size: 12,
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: height * 0.15,
                      ),
                    ],
                  ),
                ),
              ),
              DraggableScrollableSheet(
                initialChildSize: 0.65,
                maxChildSize: 0.95,
                minChildSize: 0.65,
                builder:
                    (BuildContext context, ScrollController scrollController) {
                  return Container(
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
                    child: SingleChildScrollView(
                      controller: scrollController,
                      child: Column(
                        children: <Widget>[
                          Padding(
                            padding: EdgeInsets.only(top: 30),
                            child: Text(
                              "Collections",
                              style: TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18),
                            ),
                          ),
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
                          Padding(
                            padding: EdgeInsets.only(left: 30.0, right: 30.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: <Widget>[
                                Text(
                                  "All Posts",
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 18),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(
                            height: 30,
                          ),
                          Container(
                            height: 200,
                            child: ListView(
                              scrollDirection: Axis.horizontal,
                              children: <Widget>[
                                _favoriteCard(
                                    "assets/images/phillip_profile.jpg"),
                                _favoriteCard(
                                    "assets/images/phillip_profile.jpg"),
                                _favoriteCard(
                                    "assets/images/phillip_profile.jpg"),
                                SizedBox(
                                  width: 100,
                                )
                              ],
                            ),
                          ),
                          SizedBox(
                            height: 30,
                          )
                        ],
                      ),
                    ),
                  );
                },
              ),
            ],
          );
        },
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
              blurRadius: 5.0,
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
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
              Padding(
                padding: EdgeInsets.only(
                  left: 10.0,
                  top: 10,
                ),
                child: Text(
                  name,
                  style: TextStyle(
                      color: Colors.black,
                      fontSize: 20,
                      fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  _favoriteCard(String s) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 20),
      child: Container(
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: Colors.black54,
              offset: Offset(0.0, 3.0),
              blurRadius: 10.0,
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(15.0),
          child: Image.asset(
            s,
            height: 200,
            width: 300,
            fit: BoxFit.cover,
          ),
        ),
      ),
    );
  }
}

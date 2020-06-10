import 'dart:io' show Platform;

import 'package:creaid/profile/DisplayFollow.dart';
import 'package:creaid/profile/UploadProfile.dart';
import 'package:creaid/utility/UserData.dart';
import 'package:creaid/utility/firebaseAuth.dart';
import 'package:creaid/utility/user.dart';
import 'package:creaid/utility/userDBService.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Profile extends StatefulWidget {
  String uid;
  String name;
  Profile({this.uid, this.name});

  @override
  _ProfileState createState() => _ProfileState();
}

GlobalKey profileKey = GlobalKey();

class _ProfileState extends State<Profile> {
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
      if (userName.displayName != null) {
        return userName.displayName;
      }
    }
    setState(() {
      _loadCurrentUser();
    });
    return '';
  }

  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    var screenWidth = size.width;
    final user = Provider.of<User>(context);
    var uid = user.uid;

    return Scaffold(
      appBar: AppBar(
        title: Text(_getLoadedName()),
        actions: <Widget>[
          IconButton(
              icon: Icon(Icons.settings),
              onPressed: () => _showLogoutPopUp(context))
        ],
      ),
      body: StreamBuilder<UserData>(
        stream: UserDbService(uid: uid).getNames(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            UserData data = snapshot.data;

            return ListView(
              children: <Widget>[
                Stack(
                  children: <Widget>[
                    Positioned(
                      top: 140,
                      bottom: 0,
                      child: Container(
                        color: Colors.grey[300],
                        width: screenWidth,
                      ),
                    ),
                    Column(
                      children: <Widget>[
                        GestureDetector(
                          key: profileKey,
                          onTap: () {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (_) => UploadProfile(),
                              ),
                            );
                          },
                          child: Container(
                            margin: EdgeInsets.only(
                              top: 80,
                            ),
                            width: 120,
                            height: 120,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              image: DecorationImage(
                                image: data.photoUrl != null &&
                                        data.photoUrl != ''
                                    ? Image.network(data.photoUrl).image
                                    : AssetImage(
                                        'assets/images/unknown-profile.png'),
                              ),
                            ),
                            child: Align(
                              alignment: Alignment.bottomRight,
                              child: Icon(
                                Icons.edit,
                                color: Colors.indigo,
                              ),
                            ),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.only(top: 15),
                          child: Text(
                            data.username,
                            style: TextStyle(
                                fontSize: 20, fontWeight: FontWeight.bold),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.only(top: 10),
                          child: Container(
                            child: Text(
                                'Hey ${userName.displayName}, you\'re looking great today! 😊'),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.only(top: 5),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: <Widget>[
                              Spacer(
                                flex: 2,
                              ),
                              FlatButton(
                                textColor: Colors.black,
                                onPressed: () {
                                  Navigator.of(context).push(MaterialPageRoute(
                                      builder: (_) => new DisplayFollow()));
                                },
                                child: Text(
                                  "Following: " +
                                      (data.numberFollowing != null
                                          ? data.numberFollowing.toString()
                                          : '0'),
                                ),
                              ),
                              Spacer(),
                              FlatButton(
                                textColor: Colors.black,
                                onPressed: () {
                                  Navigator.of(context).push(MaterialPageRoute(
                                      builder: (_) => new DisplayFollow()));
                                },
                                child: Text(
                                  "Followers: " +
                                      (data.numberFollowers != null
                                          ? data.numberFollowers.toString()
                                          : '0'),
                                ),
                              ),
                              Spacer(
                                flex: 2,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
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
                    return Container(
                      color: Colors.green,
                      child: Text("Index: $index"),
                    );
                  },
                ),
              ],
            );
          } else {
            return Align(
                alignment: Alignment.center,
                child: CircularProgressIndicator());
          }
        },
      ),
    );
  }
}

void _showLogoutPopUp(context) {
  if (Platform.isAndroid) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Alert Dialog title"),
          content: Text("Alert Dialog body"),
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
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return CupertinoAlertDialog(
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
        });
  }
}

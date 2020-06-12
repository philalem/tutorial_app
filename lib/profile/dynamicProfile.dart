import 'package:creaid/profile/DisplayFollow.dart';
import 'package:creaid/utility/UserData.dart';
import 'package:creaid/utility/creaidButton.dart';
import 'package:creaid/utility/followDbService.dart';
import 'package:creaid/utility/userDBService.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class DynamicProfile extends StatefulWidget {
  final String uid;
  final String loggedInUid;
  final String name;
  DynamicProfile({
    this.uid,
    this.name,
    this.loggedInUid,
  });

  @override
  _DynamicProfileState createState() => _DynamicProfileState();
}

GlobalKey profileKey = GlobalKey();

class _DynamicProfileState extends State<DynamicProfile> {
  FirebaseUser userName;
  FollowDbService followDbService;
  bool isFollowing = false;

  @override
  void initState() {
    _loadCurrentUser();
    _setDbService();
    super.initState();
  }

  Future<void> _loadCurrentUser() async {
    return await FirebaseAuth.instance.currentUser().then((FirebaseUser user) {
      setState(() {
        userName = user;
      });
    });
  }

  Future<void> _setDbService() async {
    followDbService = FollowDbService(uid: widget.loggedInUid);
    isFollowing = await followDbService.isFollowing(widget.uid);
    setState(() {});
  }

  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    var screenWidth = size.width;
    var uid = widget.uid;

    return Scaffold(
      appBar: CupertinoNavigationBar(
        backgroundColor: Colors.indigo,
        middle: Text(
          widget.name,
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.normal,
          ),
        ),
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
                        Container(
                          margin: EdgeInsets.only(
                            top: 80,
                          ),
                          width: 120,
                          height: 120,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            image: DecorationImage(
                              image:
                                  data.photoUrl != null && data.photoUrl != ''
                                      ? Image.network(data.photoUrl).image
                                      : AssetImage(
                                          'assets/images/phillip_profile.jpg'),
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
                          child: CreaidButton(
                            padding: 0,
                            shrink: true,
                            onPressed: () {
                              _updateFollowing(uid, widget.name);
                            },
                            children: isFollowing
                                ? [
                                    Text('Unfollow'),
                                  ]
                                : [
                                    Text(
                                      'Follow',
                                    ),
                                  ],
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
                                      builder: (_) => DisplayFollow(
                                            uid: uid,
                                            isFollowers: false,
                                          )));
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
                                      builder: (_) => DisplayFollow(
                                            uid: uid,
                                            isFollowers: true,
                                          )));
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

  void _updateFollowing(String uid, String name) {
    if (isFollowing) {
      followDbService.removeFromFollowing(uid);
    } else {
      followDbService.addToFollowing(uid, name);
    }
    setState(() {
      isFollowing = !isFollowing;
    });
  }
}

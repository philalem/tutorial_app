import 'package:creaid/profile/DisplayFollow.dart';
import 'package:creaid/utility/UserData.dart';
import 'package:creaid/utility/creaidButton.dart';
import 'package:creaid/utility/userDBService.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class DynamicProfile extends StatefulWidget {
  String uid;
  String name;
  DynamicProfile({this.uid, this.name});

  @override
  _DynamicProfileState createState() => _DynamicProfileState();
}

GlobalKey profileKey = GlobalKey();

class _DynamicProfileState extends State<DynamicProfile> {
  FirebaseUser userName;
  UserDbService dbService = UserDbService();
  bool isFollowing;

  @override
  void initState() {
    _loadCurrentUser();
    _setIsFollowing();
    super.initState();
  }

  Future<void> _loadCurrentUser() async {
    return await FirebaseAuth.instance.currentUser().then((FirebaseUser user) {
      setState(() {
        this.userName = user;
      });
    });
  }

  Future<void> _setIsFollowing() async {
    isFollowing = await dbService.isFollowing(userName.uid);
    setState(() {});
  }

  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    var screenWidth = size.width;
    var uid = widget.uid;

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.name),
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
                              _updateFollowing(uid);
                            },
                            children: isFollowing
                                ? [
                                    Text(
                                      'Follow',
                                      style: TextStyle(fontSize: 12),
                                    ),
                                    Icon(Icons.add)
                                  ]
                                : [
                                    Text('Unfollow'),
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
                                      builder: (_) => new DisplayFollow(
                                          people: (data.following != null
                                              ? data.following.asMap()
                                              : {}))));
                                },
                                child: Text(
                                  "Following: " +
                                      (data.following != null
                                          ? data.following.length.toString()
                                          : '0'),
                                ),
                              ),
                              Spacer(),
                              FlatButton(
                                textColor: Colors.black,
                                onPressed: () {
                                  Navigator.of(context).push(MaterialPageRoute(
                                      builder: (_) => new DisplayFollow(
                                          people: (data.followers != null
                                              ? data.followers.asMap()
                                              : {}))));
                                },
                                child: Text(
                                  "Followers: " +
                                      (data.followers != null
                                          ? data.followers.length.toString()
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

  void _updateFollowing(String uid) {
    if (isFollowing) {
      dbService.removeFromFollowing(uid);
    } else {
      dbService.addToFollowing(uid);
    }
    setState(() {
      isFollowing = !isFollowing;
    });
  }
}

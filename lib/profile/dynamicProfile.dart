import 'package:creaid/profile/DisplayFollow.dart';
import 'package:creaid/profile/UploadProfile.dart';
import 'package:creaid/utility/UserData.dart';
import 'package:creaid/utility/user.dart';
import 'package:creaid/utility/userDBService.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class DynamicProfile extends StatefulWidget {
  @override
  _DynamicProfileState createState() => _DynamicProfileState();
}

class _DynamicProfileState extends State<DynamicProfile> {
  @override
  Widget build(BuildContext context) {
    final user = Provider.of<User>(context);

    return StreamBuilder<UserData>(
      stream: UserDbService(uuid: user.uuid).getNames(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          UserData data = snapshot.data;

          return ListView(
            children: <Widget>[
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
                        fit: BoxFit.contain,
                        image:
                            Image.network(data.photoUrl).image,
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(
                      top: 5,
                      right: 15
                   ),
                   child: Container(
                     child:IconButton(
                        icon: Icon(Icons.people_outline),
                        onPressed: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(builder: (_) => new UploadProfile())
                          );
                        }
                      ),
                    )
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: 15),
                    child: Text(
                      data.name,
                      style: TextStyle(
                        fontSize: 20,
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: 10),
                    child: RaisedButton(
                      color: Colors.white,
                      onPressed: () {},
                      textColor: Colors.lightBlue,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(18.0),
                        side: BorderSide(color: Colors.lightBlue),
                      ),
                      child: Row(
                        children: <Widget>[
                          Text(
                            "Follow ",
                            style: TextStyle(fontSize: 15),
                          ),
                          Icon(Icons.add)
                        ],
                        mainAxisSize: MainAxisSize.min,
                      ),
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
                              Navigator.of(context).push(
                                  MaterialPageRoute(builder: (_) => new DisplayFollow(people: data.following.asMap()))
                              );
                          },
                          child: Text(
                            "Following: " + data.following.length.toString(),
                          ),
                        ),
                        Spacer(),
                        FlatButton(
                          textColor: Colors.black,
                          onPressed: () {
                              Navigator.of(context).push(
                                  MaterialPageRoute(builder: (_) => new DisplayFollow(people: data.followers.asMap()))
                              );
                          },
                          child: Text(
                            "Followers: " + data.followers.length.toString(),
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
          return new CircularProgressIndicator();
        }
      },
    );
  }
}

import 'package:creaid/utility/followDbService.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class DisplayFollow extends StatefulWidget {
  final String uid;
  final isFollowers;
  DisplayFollow({this.uid, this.isFollowers});

  @override
  _DisplayFollowState createState() => _DisplayFollowState();
}

class _DisplayFollowState extends State<DisplayFollow> {
  @override
  Widget build(BuildContext context) {
    FollowDbService followDbService = FollowDbService(uid: widget.uid);
    return Scaffold(
      appBar: CupertinoNavigationBar(
        backgroundColor: Colors.indigo,
        middle: Text(widget.isFollowers ? 'Followers' : 'Following'),
      ),
      body: StreamBuilder<Object>(
          stream: widget.isFollowers
              ? followDbService.getNextSetOfFollowers()
              : followDbService.getNextSetOfFollowing(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
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

              return ListView.separated(
                padding: EdgeInsets.only(top: 10),
                separatorBuilder: (context, index) => Divider(
                  color: Colors.grey[400],
                ),
                itemCount: data.length,
                itemBuilder: (context, index) => ListTile(
                  leading: Container(
                    width: 50,
                    height: 50,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      image: DecorationImage(
                        fit: BoxFit.contain,
                        image: data[index].photoUrl != null
                            ? Image.network(data[index].photoUrl).image
                            : AssetImage('assets/images/unknown-profile.png'),
                      ),
                    ),
                  ),
                  title: Text(
                    '${data[index].name}',
                  ),
                ),
              );
            } else {
              return Align(
                  alignment: Alignment.center,
                  child: CupertinoActivityIndicator());
            }
          }),
    );
  }
}

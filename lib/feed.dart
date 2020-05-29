import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:creaid/utility/UserData.dart';
import 'package:creaid/utility/userDBService.dart';
import 'package:creaid/video-player.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:creaid/utility/user.dart';

class Feed extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final user = Provider.of<User>(context);

    return StreamBuilder<UserData>(
      stream: UserDbService(uid: user.uid).getNames(),
      builder: (context, AsyncSnapshot<UserData> snapshot) {
        if (snapshot.hasData) {
          UserData userData = snapshot.data;
          final Map<int, String> videos = userData.videos.asMap();
          return Scaffold(
            body: ListView.separated(
              separatorBuilder: (context, index) => Divider(
                color: Colors.grey[400],
              ),
              itemCount: videos.length,
              itemBuilder: (context, index) => Container(
                child: InkWell(
                  child: ListTile(
                    title: Padding(
                      padding: EdgeInsets.all(5),
                      child: VideoPlayerScreen(videoUrl: videos[index])
                    ),
                    onTap: () {},
                  ),
                ),
              ),
            ),
          );
        } else {
          return Align(
              alignment: Alignment.center, child: CircularProgressIndicator());
        }
      },
    );
  }
}

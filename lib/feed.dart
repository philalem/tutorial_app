import 'package:creaid/FeedVideoPlayer.dart';
import 'package:creaid/utility/VideoFeedObject.dart';
import 'package:creaid/utility/user.dart';
import 'package:creaid/utility/userDBService.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Feed extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final user = Provider.of<User>(context);

    return StreamBuilder<List<VideoFeedObject>>(
      stream: UserDbService(uid: user.uid).getUserFeed(),
      builder: (context, AsyncSnapshot<List<VideoFeedObject>> snapshot) {
        if (snapshot.hasData) {
          List<VideoFeedObject> userData = snapshot.data;
          return FeedVideoPlayer(videos: userData);
        } else {
          return Align(
              alignment: Alignment.center, child: CircularProgressIndicator());
        }
      },
    );
  }
}

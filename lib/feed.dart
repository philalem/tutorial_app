import 'package:creaid/FeedVideoPlayer.dart';
import 'package:creaid/utility/VideoFeedObject.dart';
import 'package:creaid/utility/user.dart';
import 'package:creaid/utility/userDBService.dart';
import 'package:creaid/video-player.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Feed extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final user = Provider.of<User>(context);

    return StreamBuilder<UserData>(
      stream: UserDbService(uid: user.uid).getNames(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          if (snapshot.data.length > 0) {
            List<VideoFeedObject> userData = snapshot.data;
            return FeedVideoPlayer(videos: userData);
          }
        } else {
          return Align(
              alignment: Alignment.center, child: CircularProgressIndicator());
        }
        return VideoPlayerScreen();
      },
    );
  }
}

import 'package:creaid/feed/FeedVideoPlayer.dart';
import 'package:creaid/utility/UserData.dart';
import 'package:creaid/feed/VideoFeedObject.dart';
import 'package:creaid/utility/user.dart';
import 'package:creaid/utility/userDBService.dart';
import 'package:flutter/cupertino.dart';
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
          UserData userData = snapshot.data;
          if (userData.feedId != null) {
            if (userData.feedId.length > 0) {
              return StreamBuilder<List<VideoFeedObject>>(
                stream: UserDbService(uid: user.uid).getUserFeed(user.uid),
                builder:
                    (context, AsyncSnapshot<List<VideoFeedObject>> snapshot) {
                  if (snapshot.hasData) {
                    List<VideoFeedObject> userDatas = snapshot.data;
                    if (userDatas.length > 0) {
                      return FeedVideoPlayer(
                        videos: userDatas,
                        feedId: user.uid,
                        userData: userData,
                      );
                    } else {
                      return Align(
                          alignment: Alignment.center,
                          child: CupertinoActivityIndicator());
                    }
                  } else {
                    return Align(
                        alignment: Alignment.center,
                        child: CupertinoActivityIndicator());
                  }
                },
              );
            } else {
              return Align(
                  alignment: Alignment.center,
                  child: CupertinoActivityIndicator());
            }
          } else {
            return Align(
                alignment: Alignment.center,
                child: CupertinoActivityIndicator());
          }
        } else {
          return Align(
              alignment: Alignment.center, child: Text('Nothing to see here!'));
        }
      },
    );
  }
}

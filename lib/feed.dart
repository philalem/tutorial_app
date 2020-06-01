import 'package:creaid/FeedVideoPlayer.dart';
import 'package:creaid/utility/UserData.dart';
import 'package:creaid/utility/userDBService.dart';
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
          return FeedVideoPlayer(videos: userData.videos);
        } else {
          return Align(
              alignment: Alignment.center, child: CircularProgressIndicator());
        }
      },
    );
  }
}

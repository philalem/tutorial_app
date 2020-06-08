import 'package:creaid/notifications/notificationsDbService.dart';
import 'package:creaid/utility/user.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Notifications extends StatefulWidget {
  @override
  createState() => _NotificationsState();
}

class _NotificationsState extends State<Notifications> {
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

  String getNotificationPhrase(String type) {
    switch (type) {
      case 'follow':
        return 'followed you.';
      case 'like':
        return 'liked your post.';
      case 'comment':
        return 'commented on your creation: ';
      case 'creation':
        return 'recreated your creation!';
      default:
        return 'notified';
    }
  }

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<User>(context);
    var uid = user.uid;

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          'Notifications',
          textAlign: TextAlign.center,
        ),
      ),
      body: StreamBuilder<List<dynamic>>(
        stream: NotificationsDbService(uid: uid).getAllNotifications(),
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
                      image: AssetImage('./assets/images/phillip_profile.jpg'),
                    ),
                  ),
                ),
                title: Text(
                  '${data[index].name} ${getNotificationPhrase(data[index].type)}',
                ),
              ),
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

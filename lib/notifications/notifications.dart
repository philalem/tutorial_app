import 'package:creaid/notifications/notificationsDbService.dart';
import 'package:creaid/utility/user.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
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

  Text _getProperDateTimeAgo(DateTime date) {
    DateTime now = DateTime.now();
    var difference = now.difference(date);
    int seconds = difference.inSeconds;
    int minutes = difference.inMinutes;
    int hours = difference.inHours;
    int days = difference.inDays;
    String differencePhrase = 'Just now.';
    if (days > 7) {
      differencePhrase =
          DateFormat('MMMMd').format(date) + ', ' + date.year.toString();
    } else if (days > 1) {
      differencePhrase = '$days days ago.';
    } else if (hours > 23) {
      differencePhrase = '$days day ago.';
    } else if (hours > 1) {
      differencePhrase = '$hours hours ago.';
    } else if (minutes > 59) {
      differencePhrase = '$hours hour ago.';
    } else if (minutes > 1) {
      differencePhrase = '$hours minutes ago.';
    } else if (seconds > 59) {
      differencePhrase = '$minutes minute ago.';
    } else if (seconds > 20) {
      differencePhrase = '$seconds seconds ago.';
    }
    return Text(differencePhrase);
  }

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<User>(context);
    var uid = user.uid;

    return Scaffold(
      appBar: CupertinoNavigationBar(
        backgroundColor: Colors.indigo,
        middle: Text(
          'Notifications',
          textAlign: TextAlign.center,
          style: TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.normal,
          ),
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
              padding: EdgeInsets.only(top: 5),
              separatorBuilder: (context, index) => Divider(
                height: 0,
                color: Colors.grey[400],
              ),
              itemCount: data.length,
              itemBuilder: (context, index) => ListTile(
                leading: Container(
                  width: 30,
                  height: 30,
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
                title: RichText(
                  text: TextSpan(
                    style: new TextStyle(
                      fontSize: 14.0,
                      color: Colors.black,
                    ),
                    children: <TextSpan>[
                      TextSpan(
                        text:
                            '${data[index].name} ${getNotificationPhrase(data[index].type)} ',
                      ),
                      data[index].comment != null && data[index].comment != ''
                          ? TextSpan(
                              text: '\n${data[index].comment}',
                              style: TextStyle(fontWeight: FontWeight.bold))
                          : TextSpan(),
                    ],
                  ),
                ),
                subtitle: _getProperDateTimeAgo(data[index].date),
              ),
            );
          } else {
            return Align(
                alignment: Alignment.center,
                child: CupertinoActivityIndicator());
          }
        },
      ),
    );
  }
}

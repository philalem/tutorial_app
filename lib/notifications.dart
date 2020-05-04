import 'package:flutter/material.dart';

class Notifications extends StatefulWidget {
  @override
  createState() => _NotificationsState();
}

class _NotificationsState extends State<Notifications> {
  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      separatorBuilder: (context, index) => Divider(
        color: Colors.grey[400],
      ),
      itemCount: 10,
      itemBuilder: (context, index) => ListTile(
        leading: Container(
          width: 50,
          height: 50,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            image: DecorationImage(
              fit: BoxFit.contain,
              image: AssetImage("./assets/images/phillip_profile.jpg"),
            ),
          ),
        ),
        title: Padding(
          padding: EdgeInsets.all(5),
          child: Text(
            'Notification $index',
          ),
        ),
      ),
    );
  }
}

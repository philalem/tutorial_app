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

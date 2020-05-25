import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class Notifications extends StatefulWidget {
  @override
  createState() => _NotificationsState();
}

class _NotificationsState extends State<Notifications> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          "Creaid",
          style: GoogleFonts.satisfy(
            fontSize: 34,
          ),
          textAlign: TextAlign.center,
        ),
      ),
      body: ListView.separated(
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
      ),
    );
  }
}

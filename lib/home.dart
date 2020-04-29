import 'package:flutter/material.dart';
import 'package:tutorial_app/video-player.dart';

class Home extends StatefulWidget {
  @override
  createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  Widget build(BuildContext context) {
    var screenHeight = MediaQuery.of(context).size.height;
    var listCardHeight = screenHeight * 0.02;
    return Scaffold(
      appBar: AppBar(title: Text("Explore")),
      body: ListView.separated(
        separatorBuilder: (context, index) => Divider(
          color: Colors.blueGrey,
        ),
        itemCount: 8,
        itemBuilder: (context, index) => ListTile(
          title: Padding(
            padding: EdgeInsets.symmetric(vertical: listCardHeight),
            child: Text(
              'Item $index',
              style: Theme.of(context).textTheme.headline,
            ),
          ),
          onTap: () {
            Navigator.of(context).push(
              MaterialPageRoute(builder: (context) {
                return VideoPlayerScreen();
              }),
            );
          },
        ),
      ),
    );
  }
}

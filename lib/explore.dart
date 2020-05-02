import 'package:flutter/material.dart';
import 'package:tutorial_app/video-player.dart';

class Explore extends StatefulWidget {
  @override
  createState() => _ExploreState();
}

class _ExploreState extends State<Explore> {
  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      separatorBuilder: (context, index) => Divider(
        color: Colors.blueGrey,
      ),
      itemCount: 10,
      itemBuilder: (context, index) => InkWell(
        child: ListTile(
          title: Padding(
            padding: EdgeInsets.all(16),
            child: Text(
              'Item $index',
            ),
          ),
          onTap: () {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) {
                  return VideoPlayerScreen();
                },
              ),
            );
          },
        ),
      ),
    );
  }
}

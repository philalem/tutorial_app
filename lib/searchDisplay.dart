import 'package:flutter/material.dart';
import 'package:creaid/video-player.dart';

class SearchDisplay extends StatefulWidget {
  GlobalKey<NavigatorState> navigatorKey;
  SearchDisplay({this.navigatorKey});
  @override
  createState() => _SearchDisplayState();
}

class _SearchDisplayState extends State<SearchDisplay> {
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      shrinkWrap: true,
      itemCount: 15,
      itemBuilder: (context, index) => InkWell(
        child: Card(
          color: Colors.white,
          child: ListTile(
            title: Text(
              'Item $index',
            ),
            onTap: () {
              widget.navigatorKey.currentState.pushNamed('/profile');
            },
          ),
        ),
      ),
    );
  }
}

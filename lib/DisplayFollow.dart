import 'package:flutter/material.dart';

class DisplayFollow extends StatefulWidget {
  final Map<int, String> people;
  DisplayFollow({this.people});

  @override
  _DisplayFollowState createState() => _DisplayFollowState();
}

class _DisplayFollowState extends State<DisplayFollow> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView.separated(
        separatorBuilder: (context, index) => Divider(
          color: Colors.grey[400],
        ),
        itemCount: widget.people.length,
        itemBuilder: (context, index) => Container(
          child: InkWell(
            child: ListTile(
              title: Padding(
                padding: EdgeInsets.all(5),
                child: Text(
                  widget.people[index],
                ),
              ),
              onTap: () {},
            ),
          ),
        ),
      ),
    );
  }
}

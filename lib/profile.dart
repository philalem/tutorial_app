import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class Profile extends StatefulWidget {
  @override
  createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  bool _overlaysOn = true;
  @override
  Widget build(BuildContext context) {
    return ListView(
      children: <Widget>[
        Column(
          children: <Widget>[
            Container(
              margin: EdgeInsets.only(
                top: 80,
              ),
              width: 120,
              height: 120,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                image: DecorationImage(
                  fit: BoxFit.contain,
                  image: AssetImage("./assets/images/phillip_profile.jpg"),
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(top: 15),
              child: Text(
                "Phillip LeMaster",
                style: TextStyle(
                  fontSize: 20,
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(top: 10),
              child: RaisedButton(
                color: Colors.white,
                onPressed: () {},
                textColor: Colors.lightBlue,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(18.0),
                  side: BorderSide(color: Colors.lightBlue),
                ),
                child: Row(
                  children: <Widget>[
                    Text(
                      "Follow ",
                      style: TextStyle(fontSize: 15),
                    ),
                    Icon(Icons.add)
                  ],
                  mainAxisSize: MainAxisSize.min,
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(top: 5),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  Spacer(
                    flex: 2,
                  ),
                  FlatButton(
                    textColor: Colors.black,
                    onPressed: () {
                      /*...*/
                    },
                    child: Text(
                      "Following: 10",
                    ),
                  ),
                  Spacer(),
                  FlatButton(
                    textColor: Colors.black,
                    onPressed: () {
                      /*...*/
                    },
                    child: Text(
                      "Followers: 10",
                    ),
                  ),
                  Spacer(
                    flex: 2,
                  ),
                ],
              ),
            ),
          ],
        ),
        GridView.builder(
          physics: NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 4,
            crossAxisSpacing: 1.0,
            mainAxisSpacing: 1.0,
          ),
          itemCount: 20,
          itemBuilder: (context, index) {
            return Container(
              color: Colors.green,
              child: Text("Index: $index"),
            );
          },
        ),
      ],
    );
  }
}

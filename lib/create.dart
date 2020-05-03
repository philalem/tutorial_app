import 'package:flutter/material.dart';

class Create extends StatefulWidget {
  @override
  createState() => _CreateState();
}

class _CreateState extends State<Create> {
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
                    side: BorderSide(color: Colors.lightBlue)),
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
        Padding(
          padding: EdgeInsets.only(top: 5),
          child: Column(
            children: [
              ['1', '2', '3', '4'],
              ['5', '6', '7', '8'],
              ['9', '10', '11', '12'],
              ['13', '14', '15', '16'],
              ['17', '18', '19', '20'],
            ].map((data) {
              return Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: data.map(
                  (item) {
                    return Padding(
                      padding: EdgeInsets.symmetric(vertical: 1),
                      child: Container(
                        height: 100,
                        width: 100,
                        padding: const EdgeInsets.all(8),
                        child: Text(item.toString()),
                        color: Colors.teal[100],
                      ),
                    );
                  },
                ).toList(),
              );
            }).toList(),
          ),
        ),
      ],
    );
  }
}

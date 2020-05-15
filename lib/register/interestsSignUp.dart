import 'package:flutter/material.dart';
import 'package:creaid/home.dart';
import 'package:creaid/utility/firebaseAuth.dart';

class InterestsSignUp extends StatefulWidget {
  final String email, name, password;

  InterestsSignUp({this.email, this.name, this.password});

  @override
  _InterestsSignUpState createState() => _InterestsSignUpState();
}

class _InterestsSignUpState extends State<InterestsSignUp> {
  final FireBaseAuthorization _auth = FireBaseAuthorization();
  final interestHolder = TextEditingController();

  clearTextInput() {
    interestHolder.clear();
  }

  String error = '';
  var interests = new List<String>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.blueGrey,
        elevation: 0.0,
        title: Text('Creaid'),
      ),
      body: Container(
          padding: EdgeInsets.symmetric(vertical: 20.0, horizontal: 20.0),
          child: Column(children: <Widget>[
            SizedBox(height: 20.0),
            Text(
              'Add interests to your profile',
              textAlign: TextAlign.center,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 20.0),
            TextFormField(
                validator: (val) =>
                    val.isEmpty ? 'Enter a valid interest' : null,
                controller: interestHolder,
                onFieldSubmitted: (val) {
                  interests.add(val);
                  clearTextInput();
                },
                decoration: InputDecoration(
                  hintStyle:
                      TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                  hintText: 'Interest',
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30),
                    borderSide: BorderSide(
                      color: Theme.of(context).primaryColor,
                      width: 2,
                    ),
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30),
                    borderSide: BorderSide(
                      color: Theme.of(context).primaryColor,
                      width: 3,
                    ),
                  ),
                  prefixIcon: Padding(
                    child: IconTheme(
                      data:
                          IconThemeData(color: Theme.of(context).primaryColor),
                      child: Icon(Icons.alarm),
                    ),
                    padding: EdgeInsets.only(left: 30, right: 10),
                  ),
                )),
            SizedBox(height: 40.0),
            RaisedButton(
                color: Colors.black,
                child: Text(
                  'Done',
                  style: TextStyle(color: Colors.white),
                ),
                onPressed: () async {
                  dynamic res = await _auth.registerWithEmailAndPassword(
                      widget.email, widget.password, widget.name, interests);
                  if (res == null) {
                    setState(() {
                      error = 'Can not register this user';
                    });
                  } else {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => Home()),
                    );
                  }
                }),
            SizedBox(height: 12.0),
            Text(
              error,
              style: TextStyle(color: Colors.red, fontSize: 14.0),
            )
          ])),
    );
  }
}

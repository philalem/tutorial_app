import 'package:creaid/register/createUsername.dart';
import 'package:creaid/utility/creaidButton.dart';
import 'package:creaid/utility/firebaseAuth.dart';
import 'package:flutter/material.dart';

class UsernameAndInterestsSignUp extends StatefulWidget {
  final String email, name, password;

  UsernameAndInterestsSignUp({this.email, this.name, this.password});

  @override
  _UsernameAndInterestsSignUpState createState() =>
      _UsernameAndInterestsSignUpState();
}

class _UsernameAndInterestsSignUpState
    extends State<UsernameAndInterestsSignUp> {
  final FireBaseAuthorization _auth = FireBaseAuthorization();
  var topics = [
    {'Cooking': false},
    {'Carpentry': false},
    {'Wedding Decor': false},
    {'Crafts': false},
  ];
  final interestHolder = TextEditingController();
  final usernameHolder = TextEditingController();
  bool _isSubmitDisabled = false;
  String error = '';
  var _interests = List<String>();

  clearTextInput() {
    interestHolder.clear();
  }

  void enableSubmitButton() {
    setState(() {
      _isSubmitDisabled = false;
    });
  }

  void disableSubmitButton() {
    setState(() {
      _isSubmitDisabled = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text('Creaid'),
      ),
      body: Column(
        children: <Widget>[
          Container(
              padding: EdgeInsets.symmetric(vertical: 50.0, horizontal: 50.0),
              child: Column(children: <Widget>[
                CreateUsername(
                  enableForm: enableSubmitButton,
                  disableForm: disableSubmitButton,
                  controller: usernameHolder,
                ),
                SizedBox(height: 20.0),
                Text(
                  'Add interests to your profile',
                  textAlign: TextAlign.center,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 20.0),
                Wrap(
                    alignment: WrapAlignment.center,
                    direction: Axis.horizontal,
                    spacing: 12,
                    children: topics.map(
                      (e) {
                        bool added = e.values.toList()[0];
                        return CreaidButton(
                          color:
                              added ? Colors.indigoAccent[700] : Colors.indigo,
                          onPressed: () {
                            _addOrRemoveInterest(e);
                          },
                          shrink: true,
                          children: <Widget>[
                            Text(e.keys.toList()[0]),
                            SizedBox(
                              width: 4,
                            ),
                            added
                                ? Icon(
                                    Icons.check,
                                    size: 20,
                                  )
                                : Icon(
                                    Icons.add,
                                    size: 20,
                                  ),
                          ],
                        );
                      },
                    ).toList()),
                SizedBox(height: 40.0),
                CreaidButton(
                    disabled: _isSubmitDisabled,
                    children: <Widget>[
                      Text(
                        'Done',
                        style: TextStyle(fontSize: 16),
                        textAlign: TextAlign.center,
                      ),
                    ],
                    onPressed: () async {
                      _interests.add(interestHolder.text);
                      clearTextInput();
                      dynamic res = await _auth.registerWithEmailAndPassword(
                          widget.email,
                          usernameHolder.text,
                          widget.password,
                          widget.name,
                          _interests);
                      res = await _auth.signInWithEmailAndPassword(
                          widget.email, widget.password);
                      if (res == null) {
                        setState(() {
                          error = 'Can not register this user';
                        });
                      }
                      Navigator.of(context).pop();
                    }),
                SizedBox(height: 12.0),
                Text(
                  error,
                  style: TextStyle(color: Colors.red, fontSize: 14.0),
                )
              ])),
        ],
      ),
    );
  }

  void _addOrRemoveInterest(Map<String, bool> e) {
    var topic = e;
    var interest = e.keys.toList()[0];
    topic = {interest: !topic.values.toList()[0]};
    if (!_interests.contains(e)) {
      _interests.add(interest);
    } else {
      _interests.remove(interest);
    }
    topics[topics.indexOf(e)] = topic;
    print(topic);
    setState(() {});
  }
}

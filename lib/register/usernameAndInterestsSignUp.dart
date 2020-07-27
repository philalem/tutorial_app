import 'package:creaid/register/createUsername.dart';
import 'package:creaid/utility/creaidButton.dart';
import 'package:creaid/utility/firebaseAuth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

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
  final usernameHolder = TextEditingController();
  bool _isSubmitDisabled = false;
  String error = '';
  var _interests = List<String>();

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
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.dark.copyWith(
      statusBarBrightness: Brightness.light,
    ));
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: ListView(
          children: <Widget>[
            Column(
              children: <Widget>[
                Align(
                  alignment: Alignment.topLeft,
                  child: IconButton(
                    icon: Icon(Icons.arrow_back_ios),
                    color: Colors.indigo,
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                ),
                Container(
                    padding:
                        EdgeInsets.symmetric(vertical: 50.0, horizontal: 30.0),
                    child: Column(children: <Widget>[
                      CreateUsername(
                        enableForm: enableSubmitButton,
                        disableForm: disableSubmitButton,
                        controller: usernameHolder,
                      ),
                      SizedBox(height: 20.0),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            'What are you interested in?',
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 22,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 20.0),
                      Wrap(
                          alignment: WrapAlignment.center,
                          direction: Axis.horizontal,
                          spacing: 12,
                          children: topics.map(
                            (topic) {
                              bool added = topic.values.toList()[0];
                              return CreaidButton(
                                filled: added,
                                color: added
                                    ? Colors.indigoAccent[700]
                                    : Colors.indigo,
                                onPressed: () {
                                  _addOrRemoveInterest(topic);
                                },
                                shrink: true,
                                children: <Widget>[
                                  Text(topic.keys.toList()[0]),
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
                      Row(
                        children: <Widget>[
                          Expanded(
                            child: CupertinoButton(
                                color: Colors.indigo,
                                child: Text(
                                  'Done',
                                ),
                                onPressed: _isSubmitDisabled
                                    ? null
                                    : () async {
                                        dynamic res = await _auth
                                            .registerWithEmailAndPassword(
                                                widget.email,
                                                usernameHolder.text,
                                                widget.password,
                                                widget.name,
                                                _interests);

                                        if (res != null) {
                                          res = await _auth
                                              .signInWithEmailAndPassword(
                                                  widget.email,
                                                  widget.password);
                                          Navigator.of(context).pop();
                                        }
                                        setState(() {
                                          error = 'Can not register this user';
                                        });
                                      }),
                          ),
                        ],
                      ),
                      SizedBox(height: 12.0),
                      Text(
                        error,
                        style: TextStyle(color: Colors.red, fontSize: 14.0),
                      )
                    ])),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _addOrRemoveInterest(Map<String, bool> e) {
    var topic = e;
    var interest = e.keys.toList()[0];
    topic = {interest: !topic.values.toList()[0]};
    if (!_interests.contains(interest)) {
      _interests.add(interest);
    } else {
      _interests.remove(interest);
    }
    topics[topics.indexOf(e)] = topic;
    print(topic);
    setState(() {});
  }
}

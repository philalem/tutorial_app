import 'package:creaid/register/createUsername.dart';
import 'package:creaid/utility/creaidButton.dart';
import 'package:creaid/utility/firebaseAuth.dart';
import 'package:flutter/material.dart';

class InterestsSignUp extends StatefulWidget {
  final String email, name, password;

  InterestsSignUp({this.email, this.name, this.password});

  @override
  _InterestsSignUpState createState() => _InterestsSignUpState();
}

class _InterestsSignUpState extends State<InterestsSignUp> {
  final FireBaseAuthorization _auth = FireBaseAuthorization();
  final interestHolder = TextEditingController();
  final usernameHolder = TextEditingController();
  bool _isSubmitDisabled = false;

  clearTextInput() {
    interestHolder.clear();
  }

  String error = '';
  var interests = new List<String>();

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
        elevation: 0.0,
        title: Text('Creaid'),
      ),
      body: Column(
        children: <Widget>[
          CreateUsername(
            enableForm: enableSubmitButton,
            disableForm: disableSubmitButton,
            controller: usernameHolder,
          ),
          Container(
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
                          data: IconThemeData(
                              color: Theme.of(context).primaryColor),
                          child: Icon(Icons.alarm),
                        ),
                        padding: EdgeInsets.only(left: 30, right: 10),
                      ),
                    )),
                SizedBox(height: 40.0),
                CreaidButton(
                    disabled: _isSubmitDisabled,
                    children: <Widget>[
                      Text(
                        'Done',
                        style: TextStyle(fontSize: 16),
                      ),
                    ],
                    onPressed: () async {
                      interests.add(interestHolder.text);
                      clearTextInput();
                      dynamic res = await _auth.registerWithEmailAndPassword(
                          widget.email,
                          usernameHolder.text,
                          widget.password,
                          widget.name,
                          interests);
                      res = await _auth.signInWithEmailAndPassword(
                          widget.email, widget.password);
                      if (res == null) {
                        setState(() {
                          error = 'Can not register this user';
                        });
                      }
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
}

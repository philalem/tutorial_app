import 'package:creaid/utility/creaidButton.dart';
import 'package:creaid/utility/creaidTextField.dart';
import 'package:creaid/utility/firebaseAuth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';

class Login extends StatefulWidget {
  final Function toggleView;
  Login({this.toggleView});

  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final _formKey = GlobalKey<FormState>();
  final FireBaseAuthorization _auth = FireBaseAuthorization();

  String email = '';
  String password = '';
  String error = '';

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.dark.copyWith(
      statusBarBrightness: Brightness.light,
    ));
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.white,
      body: Center(
        child: ListView(
          children: <Widget>[
            Align(
              alignment: Alignment.topRight,
              child: FlatButton(
                child: Text(
                  'Sign up',
                  style: TextStyle(
                    color: Colors.black,
                  ),
                ),
                onPressed: () {
                  widget.toggleView();
                },
              ),
            ),
            Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 80.0),
                child: Image.asset(
                  'assets/images/creaid_app_icon.png',
                  scale: 12,
                ),
              ),
            ),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 50.0),
              child: Form(
                key: _formKey,
                child: Column(
                  children: <Widget>[
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
                        Text('Sign in',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 28,
                            )),
                      ],
                    ),
                    CreaidTextField(
                      obsecure: false,
                      onChanged: (input) => email = input,
                      validator: (input) =>
                          input.isEmpty ? "Need to enter a valid email" : null,
                      hint: "Email",
                    ),
                    CreaidTextField(
                      obsecure: true,
                      onChanged: (input) => password = input,
                      validator: (input) => input.length < 6
                          ? "Need to enter a password with length greater then 6"
                          : null,
                      hint: "Password",
                    ),
                    SizedBox(height: 12),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: <Widget>[
                        Text('Forgot your password?'),
                      ],
                    ),
                    SizedBox(height: 12),
                    CreaidButton(
                      children: <Widget>[
                        Text(
                          'Sign in',
                          style: TextStyle(fontSize: 16),
                        ),
                      ],
                      onPressed: () async {
                        if (_formKey.currentState.validate()) {
                          _formKey.currentState.save();
                          dynamic res = await _auth.signInWithEmailAndPassword(
                              email, password);

                          if (res == null) {
                            setState(() {
                              error =
                                  'Could not sign in with those credentials';
                            });
                          }
                        }
                      },
                    ),
                    SizedBox(height: 12.0),
                    Text(
                      error,
                      style: TextStyle(color: Colors.red, fontSize: 14.0),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

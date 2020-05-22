import 'package:creaid/utility/creaidButton.dart';
import 'package:creaid/utility/customTextField.dart';
import 'package:creaid/utility/firebaseAuth.dart';
import 'package:flutter/material.dart';
import 'package:creaid/home.dart';
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
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.white,
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          'Creaid',
          style: GoogleFonts.satisfy(
            fontSize: 34,
          ),
        ),
        actions: <Widget>[
          FlatButton.icon(
              icon: Icon(
                Icons.person,
                color: Colors.white,
              ),
              label: Text(
                'Sign up',
                style: TextStyle(
                  color: Colors.white,
                ),
              ),
              onPressed: () {
                widget.toggleView();
              })
        ],
      ),
      body: Center(
        child: ListView(
          children: <Widget>[
            Container(
              padding: EdgeInsets.symmetric(vertical: 20.0, horizontal: 10.0),
              child: Form(
                key: _formKey,
                child: Column(
                  children: <Widget>[
                    SizedBox(height: 20.0),
                    Text(
                      'Login to your Creaid account',
                      textAlign: TextAlign.center,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: 18,
                      ),
                    ),
                    SizedBox(height: 40.0),
                    CustomTextField(
                      icon: Icon(Icons.email),
                      obsecure: false,
                      onChanged: (input) => email = input,
                      validator: (input) =>
                          input.isEmpty ? "Need to enter a valid email" : null,
                      hint: "Email",
                    ),
                    SizedBox(height: 30.0),
                    CustomTextField(
                      icon: Icon(Icons.panorama_fish_eye),
                      obsecure: true,
                      onChanged: (input) => password = input,
                      validator: (input) => input.length < 6
                          ? "Need to enter a password with length greater then 6"
                          : null,
                      hint: "Password",
                    ),
                    SizedBox(height: 40.0),
                    CreaidButton(
                      label: 'Sign up',
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
                          } else {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => Home()),
                            );
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

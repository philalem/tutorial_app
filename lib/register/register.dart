import 'package:creaid/register/usernameAndInterestsSignUp.dart';
import 'package:creaid/utility/algoliaService.dart';
import 'package:creaid/utility/creaidTextField.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class Register extends StatefulWidget {
  final Function toggleView;
  Register({this.toggleView});

  @override
  _RegisterState createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController emailController = TextEditingController();
  AlgoliaService algoliaService = AlgoliaService();
  String emailError;
  String email = '';
  String password = '';
  String name = '';

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.dark.copyWith(
      statusBarBrightness: Brightness.light,
    ));
    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: Colors.white,
      body: Center(
        child: ListView(
          children: <Widget>[
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
              padding: EdgeInsets.symmetric(horizontal: 30.0),
              child: Form(
                key: _formKey,
                child: Column(
                  children: <Widget>[
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
                        Text('Sign up',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 28,
                            )),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
                        FlatButton(
                          padding: EdgeInsets.all(0),
                          child: Text(
                            'Already have an account?',
                            style: TextStyle(
                              color: Colors.black,
                            ),
                          ),
                          onPressed: () {
                            widget.toggleView();
                          },
                        ),
                      ],
                    ),
                    CreaidTextField(
                      onChanged: (input) => name = input.trim(),
                      validator: (input) =>
                          input.isEmpty ? "Need to enter a name" : null,
                      hint: "Name",
                    ),
                    CreaidTextField(
                      controller: emailController,
                      onChanged: (input) => email = input.trim(),
                      validator: (input) =>
                          emailError != null ? emailError : null,
                      hint: "Email",
                    ),
                    CreaidTextField(
                      obsecure: true,
                      onChanged: (input) => password = input.trim(),
                      validator: (input) => input.length < 7
                          ? "Need to enter a password with a length longer then 6"
                          : null,
                      hint: "Password",
                    ),
                    SizedBox(height: 18),
                    Row(
                      children: <Widget>[
                        Expanded(
                          child: CupertinoButton(
                            color: Colors.indigo,
                            child: Text(
                              'Next',
                              style: TextStyle(fontSize: 16),
                              textAlign: TextAlign.center,
                            ),
                            onPressed: () async {
                              await _isValidEmail(emailController.text);
                              if (_formKey.currentState.validate()) {
                                _formKey.currentState.save();
                                Navigator.push(
                                  context,
                                  CupertinoPageRoute(
                                      builder: (context) =>
                                          UsernameAndInterestsSignUp(
                                              email: email,
                                              name: name,
                                              password: password)),
                                );
                              }
                            },
                          ),
                        ),
                      ],
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

  Future _isValidEmail(String value) async {
    bool isMatch = await algoliaService.isThereAnExactEmailMatch(value);
    if (isMatch) {
      emailError = 'Sorry, this email is taken already. Try another.';
    } else if (value.isEmpty) {
      emailError = 'Please enter an email';
    } else {
      emailError = null;
    }
  }
}

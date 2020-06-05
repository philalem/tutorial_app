import 'package:creaid/register/usernameAndInterestsSignUp.dart';
import 'package:creaid/utility/algoliaService.dart';
import 'package:creaid/utility/creaidButton.dart';
import 'package:creaid/utility/creaidTextField.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';

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
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.white,
      body: Center(
        child: ListView(
          children: <Widget>[
            Align(
              alignment: Alignment.topRight,
              child: FlatButton(
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
                        Text('Sign up',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 28,
                            )),
                      ],
                    ),
                    CreaidTextField(
                      onChanged: (input) => name = input,
                      validator: (input) =>
                          input.isEmpty ? "Need to enter a name" : null,
                      hint: "Name",
                    ),
                    CreaidTextField(
                      controller: emailController,
                      validator: (value) =>
                          emailError != null ? emailError : null,
                      hint: "Email",
                    ),
                    CreaidTextField(
                      obsecure: true,
                      onChanged: (input) => password = input,
                      validator: (input) => input.length < 7
                          ? "Need to enter a password with a length longer then 6"
                          : null,
                      hint: "Password",
                    ),
                    SizedBox(height: 18),
                    CreaidButton(
                      children: <Widget>[
                        Text(
                          'Next',
                          style: TextStyle(fontSize: 16),
                          textAlign: TextAlign.center,
                        ),
                      ],
                      onPressed: () async {
                        await _isValidEmail(emailController.text);
                        if (_formKey.currentState.validate()) {
                          _formKey.currentState.save();
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    UsernameAndInterestsSignUp(
                                        email: email,
                                        name: name,
                                        password: password)),
                          );
                        }
                      },
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

import 'package:creaid/register/usernameAndInterestsSignUp.dart';
import 'package:creaid/utility/algoliaService.dart';
import 'package:creaid/utility/creaidButton.dart';
import 'package:creaid/utility/creaidTextField.dart';
import 'package:flutter/material.dart';
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
  bool _isSubmitDisabled = true;
  String emailError;
  String email = '';
  String password = '';
  String name = '';

  _disableForm() {
    _isSubmitDisabled = true;
  }

  _enableForm() {
    _isSubmitDisabled = false;
  }

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
                'Sign in',
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
            Center(
              child: Container(
                padding: EdgeInsets.symmetric(vertical: 50.0, horizontal: 50.0),
                child: Form(
                  key: _formKey,
                  child: Column(
                    children: <Widget>[
                      SizedBox(height: 20.0),
                      Text(
                        'Sign up for your Creaid account',
                        textAlign: TextAlign.center,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: 18,
                        ),
                      ),
                      SizedBox(height: 40.0),
                      CreaidTextField(
                        icon: Icon(Icons.person),
                        obsecure: false,
                        onChanged: (input) => name = input,
                        validator: (input) =>
                            input.isEmpty ? "Need to enter a name" : null,
                        hint: "Name",
                      ),
                      SizedBox(height: 30.0),
                      CreaidTextField(
                        icon: Icon(Icons.edit),
                        controller: emailController,
                        validator: (value) =>
                            emailError != null ? emailError : null,
                        onChanged: (value) => _isValidEmail(value),
                      ),
                      SizedBox(height: 30.0),
                      CreaidTextField(
                        icon: Icon(Icons.panorama_fish_eye),
                        obsecure: false,
                        onChanged: (input) => password = input,
                        validator: (input) => input.length < 7
                            ? "Need to enter a password with a length longer then 6"
                            : null,
                        hint: "Password",
                      ),
                      SizedBox(height: 40.0),
                      CreaidButton(
                        disabled: _isSubmitDisabled,
                        children: <Widget>[
                          Text(
                            'Next',
                            style: TextStyle(fontSize: 16),
                            textAlign: TextAlign.center,
                          ),
                        ],
                        onPressed: () async {
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
    setState(() {});
  }
}

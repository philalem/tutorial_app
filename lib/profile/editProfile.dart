import 'package:creaid/register/usernameAndInterestsSignUp.dart';
import 'package:creaid/utility/algoliaService.dart';
import 'package:creaid/utility/creaidButton.dart';
import 'package:creaid/utility/creaidTextField.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class EditProfile extends StatefulWidget {
  final String name;
  final String biography;
  final String username;
  final String email;
  final NetworkImage profileImage;

  EditProfile(
      {this.name,
      this.biography,
      this.username,
      this.email,
      this.profileImage});

  @override
  _EditProfileState createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {
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
      appBar: CupertinoNavigationBar(
        backgroundColor: Colors.indigo,
        middle: Text(
          'Edit Your Profile',
          style: TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.normal,
          ),
        ),
      ),
      resizeToAvoidBottomInset: true,
      backgroundColor: Colors.white,
      body: Center(
        child: ListView(
          children: <Widget>[
            Container(
              padding: EdgeInsets.symmetric(horizontal: 30.0),
              child: Form(
                key: _formKey,
                child: Column(
                  children: <Widget>[
                    CupertinoTextField(
                      textAlignVertical: TextAlignVertical.center,
                      textInputAction: TextInputAction.done,
                      onSubmitted: (value) {
                        setState(() {});
                      },
                      maxLines: 1,
                      minLines: 1,
                      onTap: () {
                        setState(() {});
                      },
                      cursorColor: Colors.white,
                      prefix: Padding(
                        padding: const EdgeInsets.only(left: 6),
                        child: Icon(
                          CupertinoIcons.search,
                          color: Colors.white,
                        ),
                      ),
                      placeholder: 'Search',
                      placeholderStyle: TextStyle(color: Colors.white54),
                      decoration: BoxDecoration(
                        color: Colors.indigo[400],
                        borderRadius: BorderRadius.circular(10),
                      ),
                      style: TextStyle(
                        color: Colors.white,
                      ),
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

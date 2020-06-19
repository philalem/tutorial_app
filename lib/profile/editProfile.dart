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
  final String profileImage;

  EditProfile({
    this.name = '',
    this.biography = '',
    this.username = '',
    this.email = '',
    this.profileImage,
  });

  @override
  _EditProfileState createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController nameController;
  TextEditingController biographyController;
  TextEditingController usernameController;
  TextEditingController emailController;
  AlgoliaService algoliaService = AlgoliaService();
  String emailError;
  String email = '';
  String password = '';
  String name = '';

  @override
  void initState() {
    nameController = TextEditingController(text: widget.name);
    biographyController = TextEditingController(text: widget.biography);
    usernameController = TextEditingController(text: widget.username);
    emailController = TextEditingController(text: widget.email);
    super.initState();
  }

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
                    FittedBox(
                      fit: BoxFit.contain,
                      child: CircleAvatar(
                        backgroundColor: Colors.indigoAccent,
                        radius: 75,
                        child: CircleAvatar(
                          radius: 70,
                          backgroundImage: widget.profileImage != null
                              ? NetworkImage(widget.profileImage)
                              : AssetImage('assets/images/unknown-profile.png'),
                        ),
                      ),
                    ),
                    CupertinoTextField(
                      controller: nameController,
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
                    CupertinoTextField(
                      controller: biographyController,
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
                    CupertinoTextField(
                      controller: usernameController,
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
                    CupertinoTextField(
                      controller: emailController,
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

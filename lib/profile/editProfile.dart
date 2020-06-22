import 'package:creaid/profile/UploadProfile.dart';
import 'package:creaid/utility/algoliaService.dart';
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
    Size size = MediaQuery.of(context).size;
    double height = size.height;
    double width = size.width;
    const IconData camera = const IconData(0xf2d3,
        fontFamily: CupertinoIcons.iconFont,
        fontPackage: CupertinoIcons.iconFontPackage);

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
      backgroundColor: Colors.grey[200],
      body: Center(
        child: ListView(
          children: <Widget>[
            Container(
              padding: EdgeInsets.symmetric(
                horizontal: width * 0.1,
              ),
              child: Form(
                key: _formKey,
                child: Column(
                  children: <Widget>[
                    SizedBox(
                      height: height * 0.01,
                    ),
                    FittedBox(
                      fit: BoxFit.contain,
                      child: FlatButton(
                        onPressed: () => Navigator.of(context).push(
                          CupertinoPageRoute(
                            builder: (_) => UploadProfile(),
                          ),
                        ),
                        child: Stack(
                          children: <Widget>[
                            Card(
                              elevation: 14,
                              shape: CircleBorder(),
                              child: CircleAvatar(
                                backgroundColor: Colors.indigoAccent,
                                radius: 75,
                                child: CircleAvatar(
                                  backgroundColor: Colors.transparent,
                                  radius: 70,
                                  backgroundImage: widget.profileImage != null
                                      ? NetworkImage(widget.profileImage)
                                      : AssetImage(
                                          'assets/images/unknown-profile.png'),
                                ),
                              ),
                            ),
                            Positioned(
                              right: 0,
                              bottom: 0,
                              child: Card(
                                color: Colors.indigo,
                                elevation: 14,
                                shape: CircleBorder(),
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Center(
                                    child: Icon(
                                      Icons.camera_alt,
                                      color: Colors.grey[200],
                                      size: 30,
                                    ),
                                  ),
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                    SizedBox(
                      height: height * 0.05,
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
                      placeholder: 'Name',
                      placeholderStyle: TextStyle(color: Colors.white54),
                      style: TextStyle(
                        color: Colors.black,
                      ),
                    ),
                    SizedBox(
                      height: height * 0.1,
                    ),
                    CupertinoTextField(
                      controller: biographyController,
                      textAlignVertical: TextAlignVertical.center,
                      textInputAction: TextInputAction.done,
                      onSubmitted: (value) {
                        setState(() {});
                      },
                      maxLines: 5,
                      minLines: 1,
                      onTap: () {
                        setState(() {});
                      },
                      cursorColor: Colors.white,
                      placeholder: 'Profile Description',
                      placeholderStyle: TextStyle(color: Colors.white54),
                      style: TextStyle(
                        color: Colors.black,
                      ),
                    ),
                    SizedBox(
                      height: height * 0.1,
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
                      placeholder: 'Username',
                      placeholderStyle: TextStyle(color: Colors.white54),
                      style: TextStyle(
                        color: Colors.black,
                      ),
                    ),
                    SizedBox(
                      height: height * 0.1,
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
                      placeholder: 'email',
                      placeholderStyle: TextStyle(color: Colors.white54),
                      style: TextStyle(
                        color: Colors.black,
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

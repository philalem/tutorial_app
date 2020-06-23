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
  FocusNode focusNode;
  String emailError;
  String email = '';
  String password = '';
  String name = '';

  @override
  void initState() {
    focusNode = FocusNode();
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

    return CupertinoPageScaffold(
      resizeToAvoidBottomInset: true,
      navigationBar: CupertinoNavigationBar(
        backgroundColor: Colors.indigo,
        middle: Text(
          'Edit Your Profile',
          style: TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.normal,
          ),
        ),
        trailing: GestureDetector(
          onTap: () => print('Pressed save for profile settings'),
          child: Text(
            'Save',
            style: TextStyle(color: Colors.white),
          ),
        ),
      ),
      backgroundColor: Colors.grey[200],
      child: Center(
        child: ListView(
          children: <Widget>[
            Form(
              key: _formKey,
              child: Column(
                children: <Widget>[
                  Container(
                    color: Colors.black87,
                    width: width,
                    height: height * 0.28,
                    child: Container(
                      height: height * 0.3,
                      child: FlatButton(
                        onPressed: () => Navigator.of(context).push(
                          CupertinoPageRoute(
                            builder: (_) => UploadProfile(),
                          ),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(25.0),
                          child: FittedBox(
                            fit: BoxFit.contain,
                            child: Stack(
                              children: <Widget>[
                                CircleAvatar(
                                  backgroundColor: Colors.indigoAccent,
                                  radius: 85,
                                  child: CircleAvatar(
                                    backgroundColor: Colors.transparent,
                                    radius: 80,
                                    backgroundImage: widget.profileImage != null
                                        ? NetworkImage(widget.profileImage)
                                        : AssetImage(
                                            'assets/images/unknown-profile.png'),
                                  ),
                                ),
                                Positioned(
                                  right: 0,
                                  bottom: 0,
                                  child: Card(
                                    color: Colors.indigo,
                                    elevation: 0,
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
                      ),
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: width * 0.1,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        SizedBox(
                          height: 24,
                        ),
                        Text(
                          'Name',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        CupertinoTextField(
                          controller: nameController,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius:
                                BorderRadius.all(Radius.circular(5.0)),
                          ),
                          textAlignVertical: TextAlignVertical.center,
                          textInputAction: TextInputAction.done,
                          onSubmitted: (value) {
                            focusNode.unfocus();
                            setState(() {});
                          },
                          onTap: () {
                            focusNode.requestFocus();
                            setState(() {});
                          },
                          maxLines: 1,
                          minLines: 1,
                          placeholder: 'Name',
                          placeholderStyle: TextStyle(color: Colors.white54),
                          style: TextStyle(
                            color: Colors.black,
                          ),
                        ),
                        SizedBox(
                          height: 14,
                        ),
                        Text(
                          'Profile Description',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        CupertinoTextField(
                          // TODO: add focus node to request focus
                          controller: biographyController,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius:
                                BorderRadius.all(Radius.circular(5.0)),
                          ),
                          onSubmitted: (value) {
                            focusNode.unfocus();
                            setState(() {});
                          },
                          onTap: () {
                            focusNode.requestFocus();
                            setState(() {});
                          },
                          textAlignVertical: TextAlignVertical.center,
                          textInputAction: TextInputAction.done,

                          maxLines: 5,
                          minLines: 1,

                          placeholder: 'Profile Description',
                          placeholderStyle: TextStyle(color: Colors.white54),
                          style: TextStyle(
                            color: Colors.black,
                          ),
                        ),
                        SizedBox(
                          height: 14,
                        ),
                        Text(
                          'Username',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        CupertinoTextField(
                          controller: usernameController,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius:
                                BorderRadius.all(Radius.circular(5.0)),
                          ),
                          onSubmitted: (value) {
                            focusNode.unfocus();
                            setState(() {});
                          },
                          onTap: () {
                            focusNode.requestFocus();
                            setState(() {});
                          },
                          textAlignVertical: TextAlignVertical.center,
                          textInputAction: TextInputAction.done,
                          maxLines: 1,
                          minLines: 1,
                          placeholder: 'Username',
                          placeholderStyle: TextStyle(color: Colors.white54),
                          style: TextStyle(
                            color: Colors.black,
                          ),
                        ),
                        SizedBox(
                          height: 14,
                        ),
                        Text(
                          'Email',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        CupertinoTextField(
                          controller: emailController,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius:
                                BorderRadius.all(Radius.circular(5.0)),
                          ),
                          onSubmitted: (value) {
                            focusNode.unfocus();
                            setState(() {});
                          },
                          onTap: () {
                            focusNode.requestFocus();
                            setState(() {});
                          },
                          textAlignVertical: TextAlignVertical.center,
                          textInputAction: TextInputAction.done,
                          maxLines: 1,
                          minLines: 1,
                          placeholder: 'Email',
                          placeholderStyle: TextStyle(color: Colors.white54),
                          style: TextStyle(
                            color: Colors.black,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
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

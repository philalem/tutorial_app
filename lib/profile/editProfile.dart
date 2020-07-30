import 'dart:io';

import 'package:creaid/profile/profilePhotoService.dart';
import 'package:creaid/utility/algoliaService.dart';
import 'package:creaid/utility/user.dart';
import 'package:creaid/utility/userDBService.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

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
  final picker = ImagePicker();
  bool _isLoading = false;
  File _image;
  String _uploadedFileURL;
  var _scaffoldKey = new GlobalKey<ScaffoldState>();
  final _formKey = GlobalKey<FormState>();
  TextEditingController nameController;
  TextEditingController biographyController;
  TextEditingController usernameController;
  TextEditingController emailController;
  AlgoliaService algoliaService = AlgoliaService();
  FocusNode focusNode;
  String usernameError = '';

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
    final user = Provider.of<User>(context);
    Size size = MediaQuery.of(context).size;
    double height = size.height;
    double width = size.width;

    return CupertinoPageScaffold(
      key: _scaffoldKey,
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
          onTap: () => _validateAndUploadForm(user),
          child: Text(
            'Save',
            style: TextStyle(color: Colors.white),
          ),
        ),
      ),
      backgroundColor: Colors.white,
      child: Stack(
        children: <Widget>[
          Center(
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
                            onPressed: () => _changeProfileImage(),
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
                                        backgroundImage:
                                            _getProfileImage(_image),
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
                                border: Border(
                                    bottom: BorderSide(
                                        color: Colors.black, width: 1)),
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
                              placeholderStyle:
                                  TextStyle(color: Colors.white54),
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
                            usernameError != ''
                                ? FittedBox(
                                    fit: BoxFit.contain,
                                    child: Text(
                                      usernameError,
                                      style: TextStyle(
                                        fontSize: 14,
                                        color: Colors.red,
                                      ),
                                    ),
                                  )
                                : SizedBox(),
                            CupertinoTextField(
                              controller: usernameController,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                border: Border(
                                    bottom: BorderSide(
                                        color: Colors.black, width: 1)),
                              ),
                              onChanged: (value) {
                                _isValidUsername(value);
                              },
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
                              placeholderStyle:
                                  TextStyle(color: Colors.white54),
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
                              controller: biographyController,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                border: Border(
                                    bottom: BorderSide(
                                        color: Colors.black, width: 1)),
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
                              placeholderStyle:
                                  TextStyle(color: Colors.white54),
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
                                border: Border(
                                    bottom: BorderSide(
                                        color: Colors.black, width: 1)),
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
                              placeholderStyle:
                                  TextStyle(color: Colors.white54),
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
          _isLoading
              ? Align(
                  alignment: Alignment.center,
                  child: CupertinoActivityIndicator(),
                )
              : Container(),
        ],
      ),
    );
  }

  Future _saveUserEditedData(User user, BuildContext context) async {
    setState(() {
      _isLoading = true;
    });
    if (_image != null) {
      await uploadFile(user);
      print(_uploadedFileURL);
    }
    await UserDbService(uid: user.uid).updateUserEditedInfo(
        nameController.text,
        usernameController.text,
        emailController.text,
        biographyController.text,
        _uploadedFileURL);
    setState(() {
      _isLoading = false;
    });
    Navigator.pop(context, true);
  }

  Future _changeProfileImage() async {
    setState(() {
      _isLoading = true;
    });
    var image = await chooseFile();
    if (image != null) {
      File croppedImage = await cropImageView();
      _image = croppedImage;
    }
    setState(() {
      _isLoading = false;
    });
  }

  _getProfileImage(File image) {
    if (image != null) return FileImage(image);
    if (widget.profileImage != null) {
      return NetworkImage(widget.profileImage);
    }
    return AssetImage('assets/images/unknown-profile.png');
  }

  Future<File> cropImageView() {
    return ImageCropper.cropImage(
        sourcePath: _image.path,
        aspectRatio: CropAspectRatio(ratioX: 1, ratioY: 1),
        androidUiSettings: AndroidUiSettings(
            toolbarTitle: 'Crop your Profile Picture',
            toolbarColor: Colors.deepOrange,
            toolbarWidgetColor: Colors.white,
            initAspectRatio: CropAspectRatioPreset.original,
            lockAspectRatio: false),
        iosUiSettings: IOSUiSettings(
          title: 'Crop your Profile Picture',
        ));
  }

  Future chooseFile() async {
    final pickedFile = await picker.getImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
      });
    }
    return pickedFile;
  }

  Future uploadFile(User user) async {
    String fileUrl = await ProfilePhotoService(uid: user.uid)
        .uploadPhotoToCloudStore(_image)
        .catchError((onError) {
      print(onError);
      _showDialog('Upload Failed.');
    });
    setState(() {
      _uploadedFileURL = fileUrl;
    });
  }

  void _showDialog(title) {
    if (Platform.isAndroid) {
      showDialog(
        context: _scaffoldKey.currentContext,
        builder: (BuildContext context) {
          // return object of type Dialog
          return AlertDialog(
            title: Text(title),
            actions: <Widget>[
              // usually buttons at the bottom of the dialog
              FlatButton(
                child: Text("Okay"),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        },
      );
    } else {
      showCupertinoDialog(
        context: _scaffoldKey.currentContext,
        builder: (BuildContext context) {
          // return object of type Dialog
          return CupertinoAlertDialog(
            title: Text(title),
            actions: <Widget>[
              // usually buttons at the bottom of the dialog
              CupertinoDialogAction(
                child: Text("Okay"),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        },
      );
    }
  }

  Future _validateAndUploadForm(User user) async {
    String emailError = await _isValidEmail(emailController.text);
    String nameError = await _isValidName(nameController.text);

    if (emailError != null) {
      _showDialog(emailError);
      return;
    }
    if (nameError != null) {
      _showDialog(nameError);
      return;
    }
    if (usernameError != '') {
      _showDialog(usernameError);
      return;
    }
    _saveUserEditedData(user, context);
  }

  Future _isValidName(String value) async {
    String name = value.trim();
    if (name.isEmpty || name.trim().length < 1) {
      return 'Please enter your name.';
    }
    return null;
  }

  Future _isValidUsername(String value) async {
    String username = value.trim();
    bool isMatch = await algoliaService.isThereAnExactUsernameMatch(username);
    if (isMatch && username.toLowerCase() != widget.username.toLowerCase()) {
      usernameError = 'Sorry, the username is already taken.';
    } else if (username.isEmpty) {
      usernameError = 'Please enter a username.';
    } else {
      usernameError = '';
    }
    setState(() {});
  }

  Future _isValidEmail(String value) async {
    String email = value.trim();
    bool isMatch = await algoliaService.isThereAnExactEmailMatch(email);
    if (isMatch && email.toLowerCase() != widget.email.toLowerCase()) {
      return 'Sorry, this email is already taken.';
    } else if (value.isEmpty) {
      return 'Please enter an email.';
    }
    return null;
  }
}

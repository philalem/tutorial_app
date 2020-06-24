import 'dart:io';

import 'package:creaid/profile/UploadProfile.dart';
import 'package:creaid/profile/profilePhotoService.dart';
import 'package:creaid/utility/algoliaService.dart';
import 'package:creaid/utility/user.dart';
import 'package:firebase_storage/firebase_storage.dart';
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
    final user = Provider.of<User>(context);
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
          onTap: () async {
            setState(() {
              _isLoading = true;
            });
            await uploadFile();
            print(_uploadedFileURL);
            setState(() {
              _isLoading = false;
            });
            if (_uploadedFileURL != null) {
              ProfilePhotoService(uid: user.uid).uploadPhoto(_uploadedFileURL);
              Navigator.pop(context, true);
            } else {
              _showDialog();
            }
          },
          child: Text(
            'Save',
            style: TextStyle(color: Colors.white),
          ),
        ),
      ),
      backgroundColor: Colors.grey[200],
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
                            onPressed: () async {
                              setState(() {
                                _isLoading = true;
                              });
                              await chooseFile();
                              File croppedImage = await cropImageView();
                              setState(() {
                                _isLoading = false;
                                _image = croppedImage;
                              });
                            },
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

  _getProfileImage(File image) {
    if (widget.profileImage != null) {
      if (image != null) return FileImage(image);
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
    setState(() {
      _image = File(pickedFile.path);
    });
  }

  Future uploadFile() async {
    StorageReference storageReference =
        FirebaseStorage.instance.ref().child('profilePictures/${_image.path}}');
    StorageUploadTask uploadTask = storageReference.putFile(_image);
    await uploadTask.onComplete;
    print('File Uploaded');
    String fileUrl = await storageReference.getDownloadURL();
    setState(() {
      _uploadedFileURL = fileUrl;
    });
  }

  void _showDialog() {
    if (Platform.isAndroid) {
      showDialog(
        context: _scaffoldKey.currentContext,
        builder: (BuildContext context) {
          // return object of type Dialog
          return AlertDialog(
            title: Text("Upload failed"),
            content: Text("Try Again"),
            actions: <Widget>[
              // usually buttons at the bottom of the dialog
              FlatButton(
                child: Text("Close"),
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
            title: Text("Upload failed. Please try again."),
            actions: <Widget>[
              // usually buttons at the bottom of the dialog
              CupertinoDialogAction(
                child: Text("okay"),
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

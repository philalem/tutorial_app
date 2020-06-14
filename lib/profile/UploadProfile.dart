import 'dart:io';

import 'package:creaid/profile/profilePhotoService.dart';
import 'package:creaid/utility/creaidButton.dart';
import 'package:creaid/utility/user.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

class UploadProfile extends StatefulWidget {
  @override
  _UploadProfileState createState() => _UploadProfileState();
}

class _UploadProfileState extends State<UploadProfile> {
  final picker = ImagePicker();
  File _image;
  String _uploadedFileURL;
  var _scaffoldKey = new GlobalKey<ScaffoldState>();
  double xCoordinate = 100.0;
  double yCoordinate = 100.0;

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<User>(context);
    Size size = MediaQuery.of(context).size;
    var navBarHeight = CupertinoNavigationBar().preferredSize.height;
    var statusBarHeight = MediaQuery.of(context).padding.top;

    return Scaffold(
      backgroundColor: Colors.black87,
      appBar: CupertinoNavigationBar(
        padding: EdgeInsetsDirectional.only(end: 0, start: 0),
        backgroundColor: Colors.indigo,
        middle: Text(
          'Profile Picture',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.normal,
          ),
        ),
      ),
      key: _scaffoldKey,
      body: Stack(
        fit: StackFit.expand,
        children: <Widget>[
          Container(
            padding: EdgeInsets.symmetric(horizontal: 24.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                _image != null
                    ? Column(
                        children: <Widget>[
                          SizedBox(
                            height: 24,
                          ),
                          CreaidButton(
                            children: <Widget>[
                              Text(
                                'Upload Picture',
                              ),
                            ],
                            onPressed: () async {
                              await uploadFile();
                              print(_uploadedFileURL);
                              if (_uploadedFileURL != null) {
                                ProfilePhotoService(uid: user.uid)
                                    .uploadPhoto(_uploadedFileURL);
                                Navigator.pop(context, true);
                              } else {
                                _showDialog();
                              }
                            },
                          ),
                        ],
                      )
                    : Container(),
                CreaidButton(
                  children: <Widget>[
                    Text(
                      'Choose Picture',
                    ),
                  ],
                  onPressed: () {
                    chooseFile();
                  },
                ),
                SizedBox(
                  height: 28,
                )
              ],
            ),
          ),
          _image != null
              ? Positioned(
                  left: xCoordinate,
                  top: yCoordinate - navBarHeight - statusBarHeight,
                  child: Draggable(
                    feedback: _getChosedProfileImage(_image),
                    childWhenDragging: Container(),
                    onDraggableCanceled: (velocity, offset) =>
                        _setXandYCoordinates(offset),
                    child: _getChosedProfileImage(_image),
                  ),
                )
              : Container(),
        ],
      ),
    );
  }

  Widget _getChosedProfileImage(File image) {
    return Container(
      width: 300,
      height: 300,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        image: DecorationImage(fit: BoxFit.fitWidth, image: FileImage(image)),
      ),
    );
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

  _setXandYCoordinates(offset) {
    setState(() {
      xCoordinate = offset.dx;
      yCoordinate = offset.dy;
    });
  }
}

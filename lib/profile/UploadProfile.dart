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

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<User>(context);

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
      body: Center(
        child: Column(
          children: <Widget>[
            CreaidButton(
              color: Colors.black,
              children: <Widget>[
                Text(
                  'Choose Picture',
                ),
              ],
              onPressed: () {
                chooseFile();
              },
            ),
            _image != null
                ? CreaidButton(
                    color: Colors.black,
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
                    })
                : Container(),
          ],
        ),
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
}

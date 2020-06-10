import 'dart:io';

import 'package:creaid/utility/user.dart';
import 'package:creaid/utility/userDBService.dart';
import 'package:firebase_storage/firebase_storage.dart';
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
      appBar: AppBar(
        title: Text('Edit Your Profile Picture'),
      ),
      key: _scaffoldKey,
      body: Column(children: <Widget>[
        RaisedButton(
            color: Colors.black,
            child: Text(
              'Choose Picture',
              style: TextStyle(color: Colors.white),
            ),
            onPressed: () {
              chooseFile();
            }),
        _image != null
            ? RaisedButton(
                color: Colors.black,
                child: Text(
                  'Upload Picture',
                  style: TextStyle(color: Colors.white),
                ),
                onPressed: () async {
                  uploadFile();
                  print(_uploadedFileURL);
                  if (_uploadedFileURL != null) {
                    UserDbService(uid: user.uid)
                        .updatePhotoUrl(_uploadedFileURL);
                    Navigator.pop(context, true);
                  } else {
                    _showDialog();
                  }
                })
            : new Container(),
        SizedBox(height: 20.0),
        _uploadedFileURL == null
            ? RaisedButton(
                color: Colors.black,
                child: Text('Return to Profile',
                    style: TextStyle(color: Colors.white)),
                onPressed: () {
                  Navigator.pop(context, true);
                })
            : Container()
      ]),
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
    _uploadedFileURL = fileUrl;
  }

  void _showDialog() {
    showDialog(
      context: _scaffoldKey.currentContext,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          title: new Text("Upload failed"),
          content: new Text("Try Again"),
          actions: <Widget>[
            // usually buttons at the bottom of the dialog
            new FlatButton(
              child: new Text("Close"),
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

import 'package:creaid/profile/dynamicProfile.dart';
import 'package:creaid/utility/user.dart';
import 'package:creaid/utility/userDBService.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';

class UploadProfile extends StatefulWidget {
  @override
  _UploadProfileState createState() => _UploadProfileState();
}

class _UploadProfileState extends State<UploadProfile> {
  File _image;
  String _uploadedFileURL;
  var _scaffoldKey = new GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<User>(context);

    return Scaffold(
        backgroundColor: Colors.white,
        key: _scaffoldKey,
        appBar: AppBar(
          elevation: 0.0,
          title: Text(
            'Creaid',
            style: GoogleFonts.satisfy(
              fontSize: 34,
            ),
          ),
        ),
        body: Container(
          padding: EdgeInsets.symmetric(vertical: 20.0, horizontal: 10.0),
          child: Column(children: <Widget>[
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
                      if(_uploadedFileURL != null){
                        UserDbService(uuid: user.uuid).updatePhotoUrl(_uploadedFileURL);
                        Navigator.pop(context, true);
                      }
                      else{
                        _showDialog();
                      }
                    })
                : new Container(),
            SizedBox(height: 20.0),
            _uploadedFileURL == null ? RaisedButton(
              color: Colors.black,
              child: Text(
                'Return to Profile',
                style: TextStyle(color: Colors.white)
              ),
              onPressed: () {
                Navigator.pop(context, true);
              }
            ) : new Container()
          ]),
        ));
  }

  Future chooseFile() async {
    await ImagePicker.pickImage(source: ImageSource.gallery).then((image) {
      setState(() {
        _image = image;
      });
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
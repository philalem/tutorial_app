import 'dart:async';
import 'dart:io';

import 'package:creaid/profile/profilePhotoService.dart';
import 'package:creaid/utility/creaidButton.dart';
import 'package:creaid/utility/user.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_cropper/image_cropper.dart';
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
  double xCoordinate = 0.0;
  double yCoordinate = 0.0;

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<User>(context);
    Size size = MediaQuery.of(context).size;
    double height = size.height;
    double width = size.width;

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
      body: Container(
        height: height,
        width: width,
        child: Stack(
          children: <Widget>[
            Container(
              padding: EdgeInsets.symmetric(horizontal: 24.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: <Widget>[
                  _image != null
                      ? _getChosenProfileImage(_image, width)
                      : Container(),
                  SizedBox(
                    height: 28,
                  ),
                  _image != null
                      ? CreaidButton(
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
                        )
                      : Container(),
                  CreaidButton(
                    children: <Widget>[
                      Text(
                        'Choose Picture',
                      ),
                    ],
                    onPressed: () async {
                      await chooseFile();
                      File croppedImage = await cropImageView();
                      setState(() {
                        _image = croppedImage;
                      });
                    },
                  ),
                  SizedBox(
                    height: 28,
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
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

  Widget _getChosenProfileImage(File image, double width) {
    return Container(
      height: width * 0.9,
      width: width * 0.9,
      child: Image.file(
        image,
        fit: BoxFit.cover,
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

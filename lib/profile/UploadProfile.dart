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
  double xCoordinate = 0.0;
  double yCoordinate = 0.0;
  Offset _startingFocalPoint;
  Offset _previousOffset;
  Offset _offset = Offset.zero;
  double _previousZoom;
  double _zoom = 1.0;

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<User>(context);
    Size size = MediaQuery.of(context).size;
    double height = size.height;
    double width = size.width;
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
      body: Container(
        height: height,
        width: width,
        child: Stack(
          fit: StackFit.expand,
          children: <Widget>[
            _image != null
                ? GestureDetector(
                    onScaleStart: (details) => _handleScaleStart(details),
                    onScaleUpdate: (details) => _handleScaleUpdate(details),
                    // onPanUpdate: (tapInfo) {
                    //   setState(() {
                    //     xCoordinate += tapInfo.delta.dx;
                    //     yCoordinate += tapInfo.delta.dy;
                    //   });
                    // },
                    onDoubleTap: _handleScaleReset,
                    child: Transform(
                        transform: Matrix4.translationValues(
                            _offset.dx, _offset.dy, _zoom),
                        child: _getChosenProfileImage(_image, height, width)),
                  )
                : Container(),
            _image != null ? _getProfileImageFrame() : Container(),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 24.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: <Widget>[
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
          ],
        ),
      ),
    );
  }

  void _handleScaleReset() {
    setState(() {
      _zoom = 1.0;
      _offset = Offset.zero;
    });
  }

  void _handleScaleStart(ScaleStartDetails details) {
    setState(() {
      _startingFocalPoint = details.focalPoint;
      _previousOffset = _offset;
      _previousZoom = _zoom;
    });
  }

  void _handleScaleUpdate(ScaleUpdateDetails details) {
    setState(() {
      _zoom = _previousZoom * details.scale;

      // Ensure that item under the focal point stays in the same place despite zooming
      final Offset normalizedOffset =
          (_startingFocalPoint - _previousOffset) / _previousZoom;
      _offset = details.focalPoint - normalizedOffset * _zoom;
    });
  }

  Widget _getChosenProfileImage(File image, double height, double width) {
    return Image.file(image, fit: BoxFit.fitWidth);
  }

  Widget _getProfileImageFrame() {
    return IgnorePointer(
      child: ClipPath(
        clipper: InvertedCircleClipper(),
        child: Container(
          color: Color.fromRGBO(0, 0, 0, 0.7),
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

class InvertedCircleClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    return Path()
      ..addOval(Rect.fromCircle(
          center: Offset(size.width / 2, size.height / 2.5),
          radius: size.width * 0.45))
      ..addRect(Rect.fromLTWH(0.0, 0.0, size.width, size.height))
      ..fillType = PathFillType.evenOdd;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}

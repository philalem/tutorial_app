import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'package:firebase_storage/firebase_storage.dart';

class PreviewImageScreen extends StatefulWidget {
  final List<String> paths;
  PreviewImageScreen({this.paths});

  @override
  _PreviewImageScreenState createState() => _PreviewImageScreenState();
}

class _PreviewImageScreenState extends State<PreviewImageScreen> {
  final List<StorageReference> storageReferences = [];
  final titleTextController = TextEditingController();
  final descriptionTextController = TextEditingController();
  final databaseReference = Firestore.instance;
  List<String> _paths;
  int index = 0;
  double _progress = 0;
  bool _changeLock = false;
  List<VideoPlayerController> _controllers = [];
  bool isSaving = false;

  @override
  void initState() {
    super.initState();
    _paths = widget.paths;
    for (var i = 0; i < _paths.length; i++) {
      storageReferences.add(FirebaseStorage.instance.ref().child(_paths[i]));
    }
    _controllers
        .add(VideoPlayerController.file(File(_paths[_paths.length - 1])));

    for (int i = 0; i < ((_paths.length > 2) ? 2 : _paths.length); i++) {
      _controllers.add(VideoPlayerController.file(File(_paths[i])));
    }

    attachListenerAndInit(_controllers[1]).then((_) {
      _controllers[1].play().then((_) {
        setState(() {});
      });
    });

    if (_controllers.length > 2) {
      attachListenerAndInit(_controllers[2]);
    }
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final height = size.height;
    final width = size.width;
    final deviceRatio = width / height;
    final bottom = MediaQuery.of(context).viewInsets.bottom;
    bool isIOS = Theme.of(context).platform == TargetPlatform.iOS;

    return Scaffold(
      resizeToAvoidBottomInset: false,
      resizeToAvoidBottomPadding: false,
      body: Stack(
        children: <Widget>[
          _getCamera(deviceRatio, _controllers[1]),
          Positioned(
            bottom: isIOS ? height * 0.05 : 0.0,
            child: Padding(
              padding: EdgeInsets.only(bottom: bottom),
              child: Container(
                width: width,
                child: Column(
                  children: <Widget>[
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      mainAxisSize: MainAxisSize.max,
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.only(
                            bottom: 0,
                            left: 30,
                          ),
                          child: SizedBox(
                            width: width - 30 * 2,
                            child: TextFormField(
                              controller: titleTextController,
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 34,
                              ),
                              decoration: const InputDecoration(
                                hintText: 'Title',
                                hintStyle: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 34,
                                ),
                                border: InputBorder.none,
                              ),
                              validator: (value) {
                                if (value.isEmpty) {
                                  return 'Please enter some text';
                                }
                                return null;
                              },
                            ),
                          ),
                        ),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      mainAxisSize: MainAxisSize.max,
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.only(
                            bottom: 30,
                            left: 30,
                          ),
                          child: SizedBox(
                            width: width - 30 * 2,
                            child: TextFormField(
                              controller: descriptionTextController,
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                              decoration: const InputDecoration(
                                hintText: 'What you need:',
                                hintStyle: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                ),
                                border: InputBorder.none,
                              ),
                              validator: (value) {
                                if (value.isEmpty) {
                                  return 'Please enter some text';
                                }
                                return null;
                              },
                            ),
                          ),
                        ),
                      ],
                    ),
                    Container(
                      width: width,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Spacer(flex: 1),
                          RaisedButton(
                            onPressed: () {
                              setState(() {
                                isSaving = true;
                              });
                              _addPostToDb();
                              _saveVideosToDb();
                              setState(() {
                                isSaving = false;
                              });
                              Navigator.of(context).pop();
                              Navigator.of(context).pop();
                            },
                            textColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(18.0),
                            ),
                            child: Row(
                              children: <Widget>[
                                Text(
                                  "Share",
                                  style: TextStyle(fontSize: 16),
                                ),
                              ],
                              mainAxisSize: MainAxisSize.min,
                            ),
                          ),
                          Spacer(flex: 1),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          SafeArea(
            child: Align(
              alignment: Alignment.topLeft,
              child: IconButton(
                iconSize: 30,
                icon: Icon(
                  Icons.arrow_back_ios,
                  color: Colors.white,
                ),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ),
          ),
          isSaving
              ? Container(
                  alignment: Alignment.center,
                  child: CircularProgressIndicator(),
                )
              : Container(),
        ],
      ),
    );
  }

  Future<void> attachListenerAndInit(VideoPlayerController controller) async {
    if (!controller.hasListeners) {
      addNewListener(controller);
    }
    controller.initialize().then((_) {});
    return;
  }

  void addNewListener(VideoPlayerController controller) {
    controller.addListener(() {
      if (controller.value.initialized &&
          controller.value.duration.inMilliseconds -
                  controller.value.position.inMilliseconds <
              1) {
        controller.seekTo(Duration(milliseconds: 0));
        nextVideo();
      }
    });
  }

  void previousVideo() {
    _controllers[1]?.pause();
    index = index - 1 < 0 ? _paths.length - 1 : index - 1;
    _controllers.last?.dispose();
    _controllers.removeLast();

    if (index != 0) {
      _controllers.insert(
          0, VideoPlayerController.file(File(_paths[index - 1])));
      attachListenerAndInit(_controllers.first);
    } else if (index == 0) {
      _controllers.insert(
          0, VideoPlayerController.file(File(_paths[_paths.length - 1])));
      attachListenerAndInit(_controllers.first);
    }

    _controllers[1].play().then((_) {
      setState(() {
        _changeLock = false;
      });
    });
  }

  void nextVideo() {
    if (_changeLock) {
      return;
    }
    index = index + 1 == _paths.length ? 0 : index + 1;
    _changeLock = true;
    _controllers[1]?.pause();
    _controllers.first?.dispose();
    _controllers.removeAt(0);
    if (index != _paths.length - 1) {
      _controllers.add(VideoPlayerController.file(File(_paths[index + 1])));
      attachListenerAndInit(_controllers.last);
    } else if (index == _paths.length - 1) {
      _controllers.add(VideoPlayerController.file(File(_paths[0])));
      attachListenerAndInit(_controllers.last);
    }

    _controllers[1].play().then((_) {
      setState(() {
        _changeLock = false;
      });
    });
  }

  Widget _getCamera(deviceRatio, controller) {
    if (controller == null) {
      return Container();
    }
    return Stack(
      children: <Widget>[
        SizedBox(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          child: Center(
            child: VideoPlayer(
              _controllers[1],
            ),
          ),
        ),
        Positioned(
          right: 0,
          child: SizedBox(
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width / 2,
            child: GestureDetector(
              onTap: () {
                setState(
                  () {
                    nextVideo();
                  },
                );
              },
            ),
          ),
        ),
        Positioned(
          left: 0,
          child: SizedBox(
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width / 2,
            child: GestureDetector(
              onTap: () {
                setState(
                  () {
                    previousVideo();
                  },
                );
              },
            ),
          ),
        ),
      ],
    );
  }

  void _saveVideosToDb() async {
    _controllers[1].pause();
    for (var i = 0; i < storageReferences.length; i++) {
      final StorageUploadTask uploadTask = storageReferences[i].putFile(
        File(widget.paths[i]),
        StorageMetadata(
          contentType: 'videos/.mp4',
        ),
      );
      await uploadTask.onComplete;

      var successfulUpload = uploadTask.isSuccessful;
      if (successfulUpload) {
        Directory(widget.paths[i]).deleteSync(recursive: true);
      }
      print('Was video upload successful: ' + successfulUpload.toString());
    }
  }

  void _addPostToDb() async {
    print('Adding post information...');
    FirebaseUser uid = await getCurrentUser();
    DocumentReference ref = await databaseReference
        .collection("posts")
        .document(uid.uid.toString())
        .collection("user-posts")
        .add({
      'title': titleTextController.text,
      'description': descriptionTextController.text,
      'videos': widget.paths,
      'number-likes': 0,
      'date': DateTime.now(),
    }).catchError((e) {
      print("Got error: ${e.error}");
      return 1;
    });
    print("Document ID: " + ref.documentID);
    print('Done.');
  }

  Future<FirebaseUser> getCurrentUser() async {
    final FirebaseAuth _auth = FirebaseAuth.instance;
    return await _auth.currentUser();
  }

  Row _thumbnailWidget(controller) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        _controllers == null
            ? Container()
            : SafeArea(
                child: Container(
                  child: Center(
                    child: AspectRatio(
                      aspectRatio: controller.value.size != null
                          ? controller.value.aspectRatio
                          : 1.0,
                      child: VideoPlayer(controller),
                    ),
                  ),
                  height: 400,
                ),
              ),
      ],
    );
  }
}

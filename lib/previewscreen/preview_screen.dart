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
  List<Future<void>> _initializeVideoPlayerFuture = [];
  bool isSaving = false;

  @override
  void initState() {
    super.initState();
    _paths = widget.paths;
    for (var i = 0; i < _paths.length; i++) {
      storageReferences.add(FirebaseStorage.instance.ref().child(_paths[i]));
    }
    _controllers.add(null);
    _initializeVideoPlayerFuture.add(null);

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
    for (var i = 0; i < _controllers.length; i++) {
      _controllers[i]?.dispose();
    }
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
          FutureBuilder(
            future: _initializeVideoPlayerFuture[1],
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.done) {
                // If the VideoPlayerController has finished initialization, use
                // the data it provides to limit the aspect ratio of the video.
                return _getCamera(deviceRatio, _controllers[1]);
              } else {
                // If the VideoPlayerController is still initializing, show a
                // loading spinner.
                return Center(child: CircularProgressIndicator());
              }
            },
          ),
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
                            color: Colors.lightBlue,
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
                icon: Icon(
                  Icons.close,
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
    if (!controller.hasListeners && controller.value != null) {
      addNewListener(controller);
    }
    _initializeVideoPlayerFuture.add(controller.initialize().then((_) {}));
    return;
  }

  Future<void> addNewListener(VideoPlayerController controller) {
    controller.addListener(() {
      int duration = controller.value.duration.inMilliseconds;
      int position = controller.value.position.inMilliseconds;
      if (duration - position < 1) {
        controller.seekTo(Duration(milliseconds: 0));
        nextVideo();
      }
    });
  }

  void previousVideo() {
    if (_changeLock) {
      return;
    }
    _changeLock = true;

    if (index == 0) {
      _changeLock = false;
      return;
    }
    _controllers[1]?.pause();
    index--;

    if (index != _paths.length - 2) {
      _controllers.last?.dispose();
      _initializeVideoPlayerFuture.removeLast();
      _controllers.removeLast();
    }
    if (index != 0) {
      _controllers.insert(
          0, VideoPlayerController.file(File(_paths[index - 1])));
      attachListenerAndInit(_controllers.first);
    } else {
      _controllers.insert(0, null);
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
    _changeLock = true;
    if (index == _paths.length - 1) {
      _changeLock = false;
      return;
    }
    _controllers[1]?.pause();
    index++;
    _controllers.first?.dispose();
    _controllers.removeAt(0);
    _initializeVideoPlayerFuture.removeAt(0);
    if (index != _paths.length - 1) {
      _controllers.add(VideoPlayerController.file(File(_paths[index + 1])));
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
    controller.play();
    return Transform.scale(
      scale: controller.value.aspectRatio / (deviceRatio * 0.90),
      child: AspectRatio(
        aspectRatio: controller.value.aspectRatio,
        child: VideoPlayer(controller),
      ),
    );
  }

  void _saveVideosToDb() async {
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

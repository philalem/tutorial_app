import 'dart:async';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:creaid/utility/postsDbService.dart';
import 'package:creaid/utility/user.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_ffmpeg/flutter_ffmpeg.dart';
import 'package:provider/provider.dart';
import 'package:video_player/video_player.dart';

class PreviewImageScreen extends StatefulWidget {
  final List<String> paths;
  final String directoryPath;
  final String name;
  PreviewImageScreen({this.paths, this.directoryPath, this.name});

  @override
  _PreviewImageScreenState createState() => _PreviewImageScreenState();
}

class _PreviewImageScreenState extends State<PreviewImageScreen> {
  final FlutterFFmpeg _flutterFFmpeg = FlutterFFmpeg();
  final List<StorageReference> storageReferences = [];
  StorageReference thumbnailReference;
  String thumbnailPath;
  final titleTextController = TextEditingController();
  final descriptionTextController = TextEditingController();
  final databaseReference = Firestore.instance;
  List<String> _paths;
  List<String> pathUrls = [];
  String thumbnailUrl;
  int index = 0;
  double _progress = 0;
  bool _changeLock = false;
  List<VideoPlayerController> _controllers = [];
  bool isSaving = false;
  String documentId;

  @override
  void initState() {
    super.initState();
    _paths = widget.paths;
    String timestamp() => DateTime.now().millisecondsSinceEpoch.toString();
    thumbnailPath = '${widget.directoryPath}/${timestamp()}_thumb.png';
    thumbnailReference = FirebaseStorage.instance.ref().child(thumbnailPath);

    if (_paths.length == 1) {
      for (var i = 0; i < 3; i++) {
        _controllers.add(VideoPlayerController.file(File(_paths[0])));
      }
    } else if (_paths.length == 2) {
      _controllers.add(VideoPlayerController.file(File(_paths[0])));
      _controllers.add(VideoPlayerController.file(File(_paths[0])));
      _controllers.add(VideoPlayerController.file(File(_paths[1])));
    } else {
      _controllers
          .add(VideoPlayerController.file(File(_paths[_paths.length - 1])));
      for (int i = 0; i < ((_paths.length > 2) ? 2 : _paths.length); i++) {
        _controllers.add(VideoPlayerController.file(File(_paths[i])));
      }
    }

    for (var i = 0; i < _paths.length; i++) {
      storageReferences.add(FirebaseStorage.instance.ref().child(_paths[i]));
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
    final user = Provider.of<User>(context);

    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: Stack(
        fit: StackFit.expand,
        children: <Widget>[
          _getCamera(deviceRatio, _controllers[1]),
          Positioned(
            bottom: 0,
            child: Container(
              width: width,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.bottomCenter,
                  end: Alignment.topCenter,
                  colors: [
                    Colors.black45,
                    Colors.transparent,
                  ],
                ),
              ),
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        Expanded(
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
                      ],
                    ),
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        Expanded(
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
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        Expanded(
                          child: CupertinoButton(
                            color: Colors.indigo,
                            onPressed: () => _savePost(user, context),
                            child: Text(
                              "Share",
                            ),
                          ),
                        ),
                      ],
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
                  _controllers[1]?.pause();
                  Navigator.of(context).pop();
                },
              ),
            ),
          ),
          isSaving
              ? Container(
                  color: Colors.black45,
                  alignment: Alignment.center,
                  child: CupertinoActivityIndicator(),
                )
              : Container(),
        ],
      ),
    );
  }

  Future _savePost(User user, BuildContext context) async {
    setState(() {
      isSaving = true;
    });
    documentId = await PostsDbService(uid: user.uid).addPostToDb(
      titleTextController.text,
      descriptionTextController.text,
      widget.name,
    );
    setState(() {
      isSaving = false;
    });
    Navigator.of(context).pop();
    Navigator.of(context).pop();
    _saveVideosToDb(user.uid);
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

  Future _saveVideosToDb(String uid) async {
    _controllers[1].pause();
    await _saveThumbnail();
    for (var i = 0; i < storageReferences.length; i++) {
      final StorageUploadTask uploadTask = storageReferences[i].putFile(
        File(widget.paths[i]),
        StorageMetadata(
          contentType: 'videos/.mp4',
        ),
      );
      await uploadTask.onComplete;
      pathUrls.add(await storageReferences[i].getDownloadURL());
      var successfulUpload = uploadTask.isSuccessful;
      if (successfulUpload) {
        Directory(widget.paths[i]).deleteSync(recursive: true);
      }
      print('Was video upload successful: ' + successfulUpload.toString());
    }
    await PostsDbService(uid: uid)
        .addMediaInformation(documentId, pathUrls, thumbnailUrl);
    _controllers[0]?.dispose();
    _controllers[1]?.dispose();
    if (_controllers.length > 2) _controllers[2]?.dispose();
  }

  Future _saveThumbnail() async {
    await _flutterFFmpeg
        .execute("-ss 00:00:00 -i ${widget.paths[0]} -vframes 1 $thumbnailPath")
        .then((rc) => print("FFmpeg process exited with rc $rc"));
    StorageUploadTask uploadThumbnail = thumbnailReference.putFile(
      File(thumbnailPath),
      StorageMetadata(
        contentType: 'thumbnails/.png',
      ),
    );
    await uploadThumbnail.onComplete;
    thumbnailUrl = await thumbnailReference.getDownloadURL();
    var successfulThumbnailUpload = uploadThumbnail.isSuccessful;
    print('Was thumbnail upload successful: ' +
        successfulThumbnailUpload.toString());
  }

  Future<FirebaseUser> getCurrentUser() async {
    final FirebaseAuth _auth = FirebaseAuth.instance;
    return await _auth.currentUser();
  }
}

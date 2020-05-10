import 'dart:io';

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
  List<VideoPlayerController> _controller = [];
  bool isSaving = false;

  @override
  void initState() {
    super.initState();
    for (var i = 0; i < widget.paths.length; i++) {
      _controller.add(VideoPlayerController.file(File(widget.paths[i])));
      _controller[i].initialize();
      storageReferences
          .add(FirebaseStorage.instance.ref().child(widget.paths[i]));
    }
  }

  @override
  void dispose() {
    for (var i = 0; i < _controller.length; i++) {
      _controller[i]?.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final height = size.height;
    final width = size.width;
    final deviceRatio = width / height;
    bool isIOS = Theme.of(context).platform == TargetPlatform.iOS;

    return Scaffold(
      body: Stack(
        children: <Widget>[
          ListView(
            children: <Widget>[
              Container(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: <Widget>[
                    SizedBox(height: 10.0),
                    Column(
                      children: _controller
                          .map((controller) =>
                              _getCamera(deviceRatio, controller))
                          .toList(),
                    ),
                  ],
                ),
              ),
            ],
          ),
          Positioned(
            bottom: (isIOS) ? (height * 0.05) : 0.0,
            child: Container(
              width: width,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Spacer(flex: 1),
                  RaisedButton(
                    color: Colors.white70,
                    onPressed: () {
                      setState(() {
                        isSaving = true;
                      });
                      _saveVideosToDb();
                      setState(() {
                        isSaving = false;
                      });
                      Navigator.of(context).pop();
                      Navigator.of(context).pop();
                    },
                    textColor: Colors.lightBlue,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(18.0),
                      side: BorderSide(color: Colors.lightBlue),
                    ),
                    child: Row(
                      children: <Widget>[
                        Text(
                          "Share",
                          style: TextStyle(fontSize: 15),
                        ),
                      ],
                      mainAxisSize: MainAxisSize.min,
                    ),
                  ),
                  Spacer(flex: 1),
                ],
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

  Widget _getCamera(deviceRatio, controller) {
    if (controller == null) {
      return Container();
    }
    return Transform.scale(
      scale: controller.value.aspectRatio / (deviceRatio * 0.95),
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

  Row _thumbnailWidget(controller) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        _controller == null
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

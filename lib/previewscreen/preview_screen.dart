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
    return Scaffold(
      appBar: AppBar(
        title: Text('Preview'),
        backgroundColor: Colors.lightBlue,
      ),
      body: Stack(
        children: <Widget>[
          Container(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                SizedBox(height: 10.0),
                Column(
                  children: _controller
                      .map(
                        (controller) => Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: <Widget>[
                            _thumbnailWidget(controller),
                          ],
                        ),
                      )
                      .toList(),
                ),
                Flexible(
                  flex: 1,
                  child: Container(
                    padding: EdgeInsets.all(60.0),
                    child: RaisedButton(
                      color: Colors.white,
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
                  ),
                ),
              ],
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

  Expanded _thumbnailWidget(controller) {
    return Expanded(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.max,
        children: <Widget>[
          _controller == null
              ? Container()
              : SizedBox(
                  child: Container(
                    child: Center(
                      child: AspectRatio(
                        aspectRatio: controller.value.size != null
                            ? controller.value.aspectRatio
                            : 1.0,
                        child: VideoPlayer(controller),
                      ),
                    ),
                  ),
                  width: 100,
                  height: 400,
                ),
        ],
      ),
    );
  }
}

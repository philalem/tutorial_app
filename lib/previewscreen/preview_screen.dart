/*
 * Copyright (c) 2019 Razeware LLC
 *
 * Permission is hereby granted, free of charge, to any person obtaining a copy
 * of this software and associated documentation files (the "Software"), to deal
 * in the Software without restriction, including without limitation the rights
 * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 * copies of the Software, and to permit persons to whom the Software is
 * furnished to do so, subject to the following conditions:
 *
 * The above copyright notice and this permission notice shall be included in
 * all copies or substantial portions of the Software.
 *
 * Notwithstanding the foregoing, you may not use, copy, modify, merge, publish,
 * distribute, sublicense, create a derivative work, and/or sell copies of the
 * Software in any work that is designed, intended, or marketed for pedagogical or
 * instructional purposes related to programming, coding, application development,
 * or information technology.  Permission for such use, copying, modification,
 * merger, publication, distribution, sublicensing, creation of derivative works,
 * or sale is expressly withheld.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
 * THE SOFTWARE.
 */

import 'dart:io';
import 'dart:typed_data';
import 'package:esys_flutter_share/esys_flutter_share.dart';
import 'package:flutter/material.dart';
import 'package:path/path.dart';
import 'package:video_player/video_player.dart';

class PreviewImageScreen extends StatefulWidget {
  final List<String> paths;
  PreviewImageScreen({this.paths});

  @override
  _PreviewImageScreenState createState() => _PreviewImageScreenState();
}

class _PreviewImageScreenState extends State<PreviewImageScreen> {
  List<VideoPlayerController> _controller = [];

  @override
  void initState() {
    super.initState();
    for (var i = 0; i < widget.paths.length; i++) {
      _controller.add(VideoPlayerController.file(File(widget.paths[i])));
      _controller[i].initialize();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Preview'),
        backgroundColor: Colors.blueGrey,
      ),
      body: Container(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            SizedBox(height: 10.0),
            Flexible(
              flex: 1,
              child: Container(
                padding: EdgeInsets.all(60.0),
                child: RaisedButton(
                  onPressed: () {
                    // getBytesFromFile().then((bytes) {
                    //   Share.file('Share via:', basename(widget.paths),
                    //       bytes.buffer.asUint8List(), 'image/png');
                    // });
                  },
                  child: Text('Share'),
                ),
              ),
            ),
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
          ],
        ),
      ),
    );
  }

  // Future<ByteData> getBytesFromFile() async {
  //   Uint8List bytes = File(widget.paths).readAsBytesSync() as Uint8List;
  //   return ByteData.view(bytes.buffer);
  // }

  Expanded _thumbnailWidget(controller) {
    controller.initialize();
    return Expanded(
      child: Align(
        alignment: Alignment.centerRight,
        child: Row(
          mainAxisSize: MainAxisSize.min,
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
                            child: VideoPlayer(controller)),
                      ),
                      decoration:
                          BoxDecoration(border: Border.all(color: Colors.pink)),
                    ),
                    width: 64.0,
                    height: 64.0,
                  ),
          ],
        ),
      ),
    );
  }

  // Widget _getVideoPlayer(path) {
  //   _controller = VideoPlayerController.file(
  //     File(path),
  //   )..initialize().then((_) {
  //       setState(() {});
  //     });

  //   if (_controller.value.initialized) {
  //     return AspectRatio(
  //       aspectRatio: _controller.value.aspectRatio,
  //       child: VideoPlayer(_controller),
  //     );
  //   }
  //   return Container(
  //     margin: EdgeInsets.all(10),
  //     color: Colors.black,
  //     height: 500,
  //     width: 500,
  //     child: Text("data"),
  //   );
  // }
}

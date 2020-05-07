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

import 'package:flutter/material.dart';
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
        backgroundColor: Colors.lightBlue,
      ),
      body: Container(
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
                  onPressed: () {},
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
    );
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

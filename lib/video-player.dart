import 'dart:async';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

void main() => runApp(VideoPlayerApp());

class VideoPlayerApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Video Player Demo',
      home: VideoPlayerScreen(),
    );
  }
}

class VideoPlayerScreen extends StatefulWidget {
  final String videoUrl;
  VideoPlayerScreen({Key key, this.videoUrl}) : super(key: key);

  @override
  _VideoPlayerScreenState createState() => _VideoPlayerScreenState();
}

class _VideoPlayerScreenState extends State<VideoPlayerScreen> {
  VideoPlayerController _controller;
  Future<void> _initializeVideoPlayerFuture;

  @override
  void initState() {
    // Create and store the VideoPlayerController. The VideoPlayerController
    // offers several different constructors to play videos from assets, files,
    // or the internet.
    _controller =
        VideoPlayerController.asset('assets/videos/portrait_demo.mp4');

    // Initialize the controller and store the Future for later use.
    _initializeVideoPlayerFuture = _controller.initialize();

    // Use the controller to loop the video.
    _controller.setLooping(true);
    _controller.play();
    super.initState();
  }

  @override
  void dispose() {
    // Ensure disposing of the VideoPlayerController to free up resources.
    _controller.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var screenHeight = MediaQuery.of(context).size.height;
    return ListView(
      children: [
        Card(
          margin: EdgeInsets.fromLTRB(0.0, 20.0, 0.0, 20.0),
          color: Colors.white,
          child: Column(
            children: [
              ListTile(
                title: Text("Tutorial Name"),
                trailing: IconButton(
                  icon: Icon(Icons.more_vert),
                  onPressed: () {
                    print("Pressed More");
                  },
                ),
              ),
              FutureBuilder(
                future: _initializeVideoPlayerFuture,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.done) {
                    // If the VideoPlayerController has finished initialization, use
                    // the data it provides to limit the aspect ratio of the video.
                    return Container(
                      height: 450,
                      child: GestureDetector(
                        onTap: () async {
                          setState(
                            () {
                              (_controller.value.isPlaying)
                                  ? _controller.pause()
                                  : _controller.play();
                            },
                          );
                        },
                        child: AspectRatio(
                          aspectRatio: _controller.value.aspectRatio,
                          // Use the VideoPlayer widget to display the video.
                          child: VideoPlayer(_controller),
                        ),
                      ),
                    );
                  } else {
                    // If the VideoPlayerController is still initializing, show a
                    // loading spinner.
                    return Center(child: CircularProgressIndicator());
                  }
                },
              ),
              ListTile(
                title: Text("Creator Name"),
                leading: IconButton(
                  icon: Icon(Icons.portrait),
                  onPressed: () {
                    print("Pressed Profile");
                  },
                ),
              ),
              Padding(
                padding: EdgeInsets.fromLTRB(screenHeight * 0.02, 0,
                    screenHeight * 0.02, screenHeight * 0.02),
                child: ListTile(
                  title: Text(
                      "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum."),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

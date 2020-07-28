import 'package:creaid/feed/VideoFeedObject.dart';
import 'package:creaid/feed/feedCommentPage.dart';
import 'package:creaid/feed/feedDescription.dart';
import 'package:creaid/feed/feedSharePage.dart';
import 'package:creaid/profile/dynamicProfile.dart';
import 'package:creaid/utility/UserData.dart';
import 'package:creaid/utility/userDBService.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:creaid/utility/algoliaService.dart';
import 'package:video_player/video_player.dart';

class FeedVideoPlayer extends StatefulWidget {
  final List<VideoFeedObject> videos;
  final String feedId;
  final String videoId;
  final UserData userData;
  FeedVideoPlayer(
      {Key key, this.videos, this.feedId, this.userData, this.videoId})
      : super(key: key);

  @override
  _FeedVideoPlayerState createState() => _FeedVideoPlayerState();
}

class _FeedVideoPlayerState extends State<FeedVideoPlayer> {
  int index = 0;
  bool _changeLock = false;
  double _progress = 0;
  String shareId = "";
  List<VideoPlayerController> _controllers = [];
  var _scaffoldKey = new GlobalKey<ScaffoldState>();
  final _formKey = new GlobalKey<FormState>();
  final interestHolder = TextEditingController();
  final userHolder = TextEditingController();
  AlgoliaService algoliaService = AlgoliaService();
  List<VideoFeedObject> videos;

  clearTextInput() {
    interestHolder.clear();
  }

  @override
  void initState() {
    super.initState();
    _initControllers();
  }

  _initControllers() async {
    _controllers.add(null);
    videos = videos == null
        ? [
            await UserDbService(uid: widget.userData.uid)
                .getVideoFuture(widget.userData.uid, widget.videoId)
          ]
        : videos;
    for (int i = 0; i < videos.length; i++) {
      print(videos[i].videoUrl);
      if (i == 2) {
        break;
      }
      _controllers.add(VideoPlayerController.network(videos[i].videoUrl));
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

  Future<void> attachListenerAndInit(VideoPlayerController controller) async {
    if (!controller.hasListeners) {
      controller.addListener(() {
        int dur = controller.value.duration.inMilliseconds;
        int pos = controller.value.position.inMilliseconds;
        setState(() {
          if (dur <= pos) {
            _progress = 0;
          } else {
            _progress = (dur - (dur - pos)) / dur;
          }
        });
        if (dur - pos < 1) {
          controller.seekTo(Duration(milliseconds: 0));
          //nextVideo();
        }
      });
    }
    await controller.initialize().then((_) {});
    return;
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

    if (index != videos.length - 2) {
      _controllers.last?.dispose();
      _controllers.removeLast();
    }
    if (index != 0) {
      _controllers.insert(
          0, VideoPlayerController.network(videos[index - 1].videoUrl));
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
    if (index == videos.length - 1) {
      _changeLock = false;
      return;
    }
    _controllers[1]?.pause();
    index++;
    _controllers.first?.dispose();
    _controllers.removeAt(0);
    if (index != videos.length - 1) {
      _controllers
          .add(VideoPlayerController.network(videos[index + 1].videoUrl));
      attachListenerAndInit(_controllers.last);
    }

    _controllers[1].play().then((_) {
      setState(() {
        _changeLock = false;
      });
    });
  }

  successfulShare(BuildContext context) {
    showDialog(
        context: context,
        builder: (context) {
          return Dialog(
            elevation: 15,
            child: Container(
              color: Colors.black12,
              height: 100,
              child: Center(
                child: Text(
                  "Video Shared!",
                  style: TextStyle(color: Colors.black, fontSize: 20),
                ),
              ),
            ),
          );
        });
  }

  failedShare(BuildContext context) {
    showDialog(
        context: context,
        builder: (context) {
          return Dialog(
            elevation: 15,
            child: Container(
              color: Colors.black12,
              height: 100,
              child: Center(
                child: Text(
                  "User doesn't exist!",
                  style: TextStyle(color: Colors.black, fontSize: 20),
                ),
              ),
            ),
          );
        });
  }

  void _showFeedShare(BuildContext context) {
    Navigator.of(context).push(FeedSharePage());
  }

  void _showFeedComment(BuildContext context) {
    Navigator.of(context).push(
        FeedCommentPage(index: index, videos: videos, feedId: widget.feedId));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: CupertinoNavigationBar(
        middle: Text(
          'Creaid',
          style: GoogleFonts.satisfy(
            fontSize: 34,
          ),
        ),
      ),
      body: Stack(
        children: <Widget>[
          SizedBox(
              //video
              height: MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.width,
              child: Center(child: VideoPlayer(_controllers[1]))),
          Positioned(
            //swipe
            right: 0,
            child: SizedBox(
              height: MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.width,
              child: GestureDetector(onPanUpdate: (details) {
                if (details.delta.dy > 1.6) {
                  // swiping in right direction
                  setState(() {
                    nextVideo();
                  });
                } else if (details.delta.dy < -1.6) {
                  setState(() {
                    previousVideo();
                  });
                }
              }),
            ),
          ),
          Positioned(
              //title/description
              child: Container(
                  height: 65,
                  width: MediaQuery.of(context).size.width,
                  color: Colors.black12,
                  child: Align(
                    alignment: FractionalOffset.bottomCenter,
                    child: InkWell(
                      onTap: () {
                        Navigator.of(context).push(FeedDescription(
                            description: videos[index].description));
                      },
                      child: Text(
                        videos[index].title,
                        style: TextStyle(color: Colors.white, fontSize: 20),
                      ),
                    ),
                  ))),
          Positioned(
            //user
            child: Container(
              height: 45,
              width: MediaQuery.of(context).size.width,
              color: Colors.white,
              child: Align(
                alignment: FractionalOffset.centerLeft,
                child: Row(
                  children: <Widget>[
                    SizedBox(
                      width: 5,
                    ),
                    CircleAvatar(
                      radius: 12,
                      backgroundImage: NetworkImage(widget.userData.photoUrl),
                      backgroundColor: Colors.transparent,
                    ),
                    SizedBox(
                      width: 5,
                    ),
                    InkWell(
                      onTap: () {
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => DynamicProfile(
                                uid: videos[index].uid,
                                name: videos[index].author)));
                      },
                      child: Padding(
                        padding: const EdgeInsets.all(1.0),
                        child: Text(
                          videos[index].author,
                          style: TextStyle(color: Colors.black, fontSize: 20),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          //share button
          SizedBox(
            width: MediaQuery.of(context).size.width * .08,
          ),
          FloatingActionButton(
            onPressed: () => _showFeedShare(context),
            child: Icon(
              Icons.share,
              color: Colors.black,
            ),
            backgroundColor: Colors.white,
          ),
          SizedBox(
            width: MediaQuery.of(context).size.width * .25,
          ),
          FloatingActionButton.extended(
            //like button
            onPressed: () => UserDbService(uid: videos[index].uid).addLike(
                videos[index].documentId, widget.feedId, videos[index].author),
            label: StreamBuilder<VideoFeedObject>(
              stream: UserDbService(uid: videos[index].uid)
                  .getVideo(widget.feedId, videos[index].documentId),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  VideoFeedObject video = snapshot.data;
                  return Text(
                    video.likes.toString(),
                    style: TextStyle(color: Colors.black),
                  );
                } else {
                  return Text(
                    '0',
                    style: TextStyle(color: Colors.black),
                  );
                }
              },
            ),
            icon: Icon(
              Icons.thumb_up,
              color: Colors.black,
            ),
            backgroundColor: Colors.white,
          ),
          SizedBox(
            width: MediaQuery.of(context).size.width * .18,
          ),
          FloatingActionButton(
              //comment button
              onPressed: () => _showFeedComment(context),
              child: Icon(
                Icons.comment,
                color: Colors.black,
              ),
              backgroundColor: Colors.white)
        ],
      ),
    );
  }
}

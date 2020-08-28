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
  final List<dynamic> videos;
  final String ownerUid;
  final String documentId;
  final String author;
  final String description;
  final String title;
  final String feedId;
  final UserData userData;
  FeedVideoPlayer(
      {Key key,
      this.videos,
      this.feedId,
      this.userData,
      this.documentId,
      this.author,
      this.description,
      this.title,
      this.ownerUid})
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

  clearTextInput() {
    interestHolder.clear();
  }

  @override
  void initState() {
    super.initState();
    _initControllers();
  }

  @override
  void dispose() {
    for (int i = 0; i < _controllers.length; i++) {
      _controllers[i]?.dispose();
    }
    interestHolder?.dispose();
    userHolder?.dispose();
    super.dispose();
  }

  _initControllers() async {
    _controllers.add(null);
    for (int i = 0; i < widget.videos.length; i++) {
      print(widget.videos[i]);
      if (i == 2) {
        break;
      }
      _controllers.add(VideoPlayerController.network(widget.videos[i]));
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
    if (!controller.hasListeners && controller.value.duration != null) {
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

    if (index != widget.videos.length - 2) {
      _controllers.last?.dispose();
      _controllers.removeLast();
    }
    if (index != 0) {
      _controllers.insert(
          0, VideoPlayerController.network(widget.videos[index - 1]));
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
    if (index == widget.videos.length - 1) {
      _changeLock = false;
      return;
    }
    _controllers[1]?.pause();
    index++;
    _controllers.first?.dispose();
    _controllers.removeAt(0);
    if (index != widget.videos.length - 1) {
      _controllers.add(VideoPlayerController.network(widget.videos[index + 1]));
      attachListenerAndInit(_controllers.last);
    }

    _controllers[1].play().then((_) {
      setState(() {
        _changeLock = false;
      });
    });
  }

  void _showFeedShare(BuildContext context) {
    Navigator.of(context).push(FeedSharePage());
  }

  void _showFeedComment(BuildContext context) {
    Navigator.of(context).push(FeedCommentPage(
        index: index,
        videos: widget.videos,
        documentId: widget.documentId,
        author: widget.author,
        feedId: widget.feedId));
  }

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;
    return Stack(
      children: <Widget>[
        SizedBox(
            //video
            height: height,
            width: width,
            child: Center(child: VideoPlayer(_controllers[1]))),
        Positioned(
          //swipe
          right: 0,
          child: SizedBox(
            height: height,
            width: width,
            child: GestureDetector(onPanUpdate: (details) {
              if (details.delta.dx > 20.0) {
                // swiping in right direction
                setState(() {
                  nextVideo();
                });
              } else if (details.delta.dx < -20.0) {
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
                height: 70,
                width: width,
                color: Colors.black12,
                child: Align(
                  alignment: FractionalOffset.bottomCenter,
                  child: InkWell(
                    onTap: () {
                      Navigator.of(context).push(
                          FeedDescription(description: widget.description));
                    },
                    child: Text(
                      widget.title,
                      style: GoogleFonts.mcLaren(
                          textStyle: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                      )),
                    ),
                  ),
                ))),
        Positioned(
          //user
          child: Container(
            height: 45,
            width: width,
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
                    backgroundImage: widget.userData.photoUrl != null
                        ? NetworkImage(widget.userData.photoUrl)
                        : AssetImage('assets/images/unknown-profile.png'),
                    backgroundColor: Colors.transparent,
                  ),
                  SizedBox(
                    width: 5,
                  ),
                  InkWell(
                    onTap: () {
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => DynamicProfile(
                              uid: widget.feedId, name: widget.author)));
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(1.0),
                      child: Text(
                        widget.author != null ? widget.author : '',
                        style: GoogleFonts.mcLaren(
                            textStyle:
                                TextStyle(color: Colors.black, fontSize: 20)),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        Positioned.fill(
          child: Align(
            alignment: Alignment.bottomCenter,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: <Widget>[
                  //share button
                  FloatingActionButton(
                    onPressed: () => _showFeedShare(context),
                    child: Icon(
                      Icons.share,
                      color: Colors.black,
                    ),
                    backgroundColor: Colors.white,
                  ),
                  Spacer(),
                  FloatingActionButton.extended(
                    //like button
                    onPressed: () => UserDbService(uid: widget.userData.feedId)
                        .addLike(
                            widget.documentId, widget.ownerUid, widget.author),
                    label: StreamBuilder<VideoFeedObject>(
                      stream: UserDbService(uid: widget.userData.feedId)
                          .getVideo(widget.feedId, widget.documentId),
                      builder: (context, snapshot) {
                        if (snapshot.hasData && snapshot.data.likes != null) {
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
                  Spacer(),
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
            ),
          ),
        )
      ],
    );
  }
}

import 'package:creaid/feed/FeedCommentObject.dart';
import 'package:creaid/feed/VideoFeedObject.dart';
import 'package:creaid/profile/profile.dart';
import 'package:creaid/utility/userDBService.dart';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'package:google_fonts/google_fonts.dart';

class FeedVideoPlayer extends StatefulWidget {
  final List<VideoFeedObject> videos;
  final String feedId;
  FeedVideoPlayer({Key key, this.videos, this.feedId}) : super(key: key);

  @override
  _FeedVideoPlayerState createState() => _FeedVideoPlayerState();
}

class _FeedVideoPlayerState extends State<FeedVideoPlayer> {
  int index = 0;
  bool _changeLock = false;
  List<VideoPlayerController> _controllers = [];
  var _scaffoldKey = new GlobalKey<ScaffoldState>();
  final interestHolder = TextEditingController();

  clearTextInput() {
    interestHolder.clear();
  }

  @override
  void initState() {
    super.initState();
    _initControllers();
  }

  _initControllers() {
    _controllers.add(null);
    for (int i = 0; i < widget.videos.length; i++) {
      print(widget.videos[i].videoUrl);
      if (i == 2) {
        break;
      }
      _controllers
          .add(VideoPlayerController.network(widget.videos[i].videoUrl));
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

    if (index != widget.videos.length - 2) {
      _controllers.last?.dispose();
      _controllers.removeLast();
    }
    if (index != 0) {
      _controllers.insert(
          0, VideoPlayerController.network(widget.videos[index - 1].videoUrl));
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
      _controllers.add(
          VideoPlayerController.network(widget.videos[index + 1].videoUrl));
      attachListenerAndInit(_controllers.last);
    }

    _controllers[1].play().then((_) {
      setState(() {
        _changeLock = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          'Creaid',
          style: GoogleFonts.satisfy(
            fontSize: 34,
          ),
        ),
      ),
      body: Stack(
        children: <Widget>[
          SizedBox(
              height: MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.width,
              child: Center(child: VideoPlayer(_controllers[1]))),
          Positioned(
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
              }
              else if(details.delta.dy < -1.6){
                setState(() {
                  previousVideo();
                });
              }
            }
            ),
            ),
          ),
          Positioned(
            child: Container(
              height: 25,
              width: MediaQuery.of(context).size.width,
              color: Colors.blue,
              child: Align(
                alignment: FractionalOffset.bottomCenter,
                child: InkWell(
                  onTap: () {
                    Navigator.of(context).push(MaterialPageRoute(builder: (context) => Profile(uid: widget.videos[index].uid, name: widget.videos[index].author)));
                  },
                  child: Text(
                    widget.videos[index].author,
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 20
                    ),
                    
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: <Widget>[
          FloatingActionButton(
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (context) {
                    return Dialog(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(40)),
                      elevation: 16,
                      child: Container(
                        height: 400.0,
                        width: 360.0,
                        child: ListView(
                          children: <Widget>[
                            SizedBox(height: 20),
                            Center(
                              child: Text(
                                "Comments",
                                style: TextStyle(
                                    fontSize: 24,
                                    color: Theme.of(context).primaryColor,
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                            SizedBox(
                              height: 20,
                            ),
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 20.0),
                              child: TextFormField(
                                  onFieldSubmitted: (value) => {
                                        UserDbService(
                                                uid: widget.videos[index].uid)
                                            .addComment(
                                                widget.videos[index].documentId,
                                                widget.feedId,
                                                value),
                                        interestHolder.clear()
                                      },
                                  validator: (val) => val.isEmpty
                                      ? 'Enter a valid comment'
                                      : null,
                                  controller: interestHolder,
                                  decoration: InputDecoration(
                                    hintStyle: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 20),
                                    hintText: 'Comment',
                                    enabledBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(30),
                                      borderSide: BorderSide(
                                        color: Theme.of(context).primaryColor,
                                        width: 2,
                                      ),
                                    ),
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(30),
                                      borderSide: BorderSide(
                                        color: Theme.of(context).primaryColor,
                                        width: 5,
                                      ),
                                    ),
                                    prefixIcon: Padding(
                                      child: IconTheme(
                                        data: IconThemeData(
                                            color:
                                                Theme.of(context).primaryColor),
                                        child: Icon(Icons.comment),
                                      ),
                                      padding:
                                          EdgeInsets.only(left: 20, right: 10),
                                    ),
                                  )),
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            Divider(
                              color: Colors.indigo[400],
                              thickness: 5,
                            ),
                            SizedBox(height: 20),
                            Container(
                                height: 220,
                                child: StreamBuilder<List<FeedCommentObject>>(
                                  stream: UserDbService(
                                          uid: widget.videos[index].uid)
                                      .getFeedComments(
                                          widget.videos[index].documentId,
                                          widget.feedId),
                                  builder: (context, snapshot) {
                                    if (snapshot.hasData) {
                                      List<FeedCommentObject>
                                          feedCommentObject = snapshot.data;
                                      return ListView.separated(
                                        physics:
                                            AlwaysScrollableScrollPhysics(),
                                        separatorBuilder: (context, idx) =>
                                            Divider(
                                          color: Colors.grey[400],
                                        ),
                                        itemCount: feedCommentObject.length,
                                        itemBuilder: (context, idx) => InkWell(
                                          child: ListTile(
                                            title: Padding(
                                              padding: EdgeInsets.all(5),
                                              child: Text(feedCommentObject[idx]
                                                  .comment),
                                            ),
                                            onTap: () {},
                                          ),
                                        ),
                                      );
                                    } else {
                                      return Align(
                                          alignment: Alignment.center,
                                          child: CircularProgressIndicator());
                                    }
                                  },
                                ))
                          ],
                        ),
                      ),
                    );
                  },
                );
              },
              child: Icon(Icons.comment)),
          SizedBox(
            width: MediaQuery.of(context).size.width * .05,
          ),
          FloatingActionButton(
            onPressed: () => UserDbService(uid: widget.videos[index].uid)
                .addLike(widget.videos[index].documentId, widget.feedId),
            child: StreamBuilder<VideoFeedObject>(
              stream: UserDbService(uid: widget.videos[index].uid)
                  .getVideo(widget.feedId, widget.videos[index].documentId),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  VideoFeedObject video = snapshot.data;
                  return Text(video.likes.toString());
                } else {
                  return Text('0');
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}

import 'package:creaid/utility/customTextField.dart';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'package:google_fonts/google_fonts.dart';

class FeedVideoPlayer extends StatefulWidget {
  final List<String> videos;
  FeedVideoPlayer({Key key, this.videos}) : super(key: key);

  @override
  _FeedVideoPlayerState createState() => _FeedVideoPlayerState();
}

class _FeedVideoPlayerState extends State<FeedVideoPlayer> {
  int index = 0;
  double _progress = 0;
  bool _changeLock = false;
  List<VideoPlayerController> _controllers = [];
  var _scaffoldKey = new GlobalKey<ScaffoldState>();
  final interestHolder = TextEditingController();

  @override
  void initState() {
    super.initState();
    _initControllers();
  }

  _initControllers() {
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
          nextVideo();
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
            child: Container(
              height: 10,
              width: MediaQuery.of(context).size.width * _progress,
              color: Colors.white,
            ),
          )
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
                            SizedBox(height: 10,),
                            Divider(
                              color: Colors.indigo[400],
                              thickness: 5,
                            ),
                            SizedBox(height: 20),
                            Container(
                                height: 220, //Your custom height
                                child: ListView.separated(
                                  physics: AlwaysScrollableScrollPhysics(),
                                  separatorBuilder: (context, index) => Divider(
                                    color: Colors.grey[400],
                                  ),
                                  itemCount: 20,
                                  itemBuilder: (context, index) => InkWell(
                                    child: ListTile(
                                      title: Padding(
                                        padding: EdgeInsets.all(5),
                                        child: Text(
                                          'Item $index',
                                        ),
                                      ),
                                      onTap: () {},
                                    ),
                                  ),
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
            width: MediaQuery.of(context).size.width * .43,
          ),
          FloatingActionButton(
            onPressed: previousVideo,
            child: Icon(Icons.arrow_back),
          ),
          SizedBox(
            width: 24,
          ),
          FloatingActionButton(
            onPressed: nextVideo,
            child: Icon(Icons.arrow_forward),
          ),
        ],
      ),
    );
  }

  void_showDialog() {
    showDialog(
      context: _scaffoldKey.currentContext,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          title: new Text("Upload failed"),
          content: new Text("Try Again"),
          actions: <Widget>[
            // usually buttons at the bottom of the dialog
            new FlatButton(
              child: new Text("Close"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}

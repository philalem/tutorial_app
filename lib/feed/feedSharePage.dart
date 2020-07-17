import 'package:creaid/utility/algoliaService.dart';
import 'package:creaid/utility/creaidButton.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:creaid/notifications/notificationsDbService.dart';

class FeedSharePage extends ModalRoute<void> {
  String shareId = "";
  final userHolder = TextEditingController();
  AlgoliaService algoliaService = AlgoliaService();

  @override
  Duration get transitionDuration => Duration(milliseconds: 500);

  @override
  bool get opaque => false;

  @override
  bool get barrierDismissible => false;

  @override
  Color get barrierColor => Colors.black.withOpacity(0.5);

  @override
  String get barrierLabel => null;

  @override
  bool get maintainState => true;

  @override
  Widget buildPage(
    BuildContext context,
    Animation<double> animation,
    Animation<double> secondaryAnimation,
  ) {
    return Material(
      type: MaterialType.transparency,
      child: SafeArea(
        child: _buildOverlayContent(context),
      ),
    );
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

  Widget _buildOverlayContent(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Container(
            height: 200.0,
            width: 360.0,
            color: Colors.white,
            child: ListView(children: <Widget>[
              SizedBox(
                height: 20,
              ),
              Center(
                child: Text(
                  "Send this video to:",
                  style: TextStyle(
                      fontSize: 24,
                      color: Theme.of(context).primaryColor,
                      fontWeight: FontWeight.bold),
                ),
              ),
              SizedBox(height: 20),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: TextFormField(
                  onFieldSubmitted: (value) => {shareId = value},
                  validator: (val) => val.isEmpty ? "Enter valid user" : null,
                  decoration: InputDecoration(
                    hintStyle: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                        color: Theme.of(context).primaryColor),
                    hintText: 'Enter username',
                  ),
                  controller: userHolder,
                ),
              ),
              SizedBox(height: 20),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 100.0),
                child: CreaidButton(
                  children: <Widget>[
                    Text(
                      'Send',
                      style: TextStyle(fontSize: 16),
                    ),
                  ],
                  onPressed: () async {
                    bool valid = await algoliaService
                        .isThereAnExactUsernameMatch(userHolder.text);
                    if (valid) {
                      String uuid = await algoliaService
                          .getUserFromUserName(userHolder.text);
                      NotificationsDbService(uid: uuid)
                          .sendShareVideoNotification(userHolder.text);
                      successfulShare(context);
                    } else {
                      failedShare(context);
                    }
                    userHolder.clear();
                  },
                ),
              ),
            ]),
          ),
          RaisedButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Back to Feed'),
          )
        ],
      ),
    );
  }

  @override
  Widget buildTransitions(BuildContext context, Animation<double> animation,
      Animation<double> secondaryAnimation, Widget child) {
    return FadeTransition(
      opacity: animation,
      child: ScaleTransition(
        scale: animation,
        child: child,
      ),
    );
  }
}

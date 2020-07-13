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
    // This makes sure that text and other content follows the material style
    return Material(
      type: MaterialType.transparency,
      // make sure that the overlay content is not cut off
      child: SafeArea(
        child: _buildOverlayContent(context),
      ),
    );
  }

  Widget _buildOverlayContent(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Container(
                      height: 200.0,
                      width: 360.0,
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
                            validator: (val) =>
                                val.isEmpty ? "Enter valid user" : null,
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
                          padding:
                              const EdgeInsets.symmetric(horizontal: 100.0),
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
                                    .sendShareVideoNotification(
                                        userHolder.text);
                               // successfulShare(context);
                               Text("Succesful Share!");
                              } else {
                                 Text("User doesn't exist!");
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
    // You can add your own animations for the overlay content
    return FadeTransition(
      opacity: animation,
      child: ScaleTransition(
        scale: animation,
        child: child,
      ),
    );
  }
}

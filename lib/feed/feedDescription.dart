import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

class FeedDescription extends ModalRoute<void> {
  final String description;
  FeedDescription({this.description});

  final interestHolder = TextEditingController();

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

  Widget _buildOverlayContent(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Container(
              color: Colors.white,
              height: 100,
              width: MediaQuery.of(context).size.width*.7,
              child: Center(
                child: Text(
                  description,
                  style: TextStyle(color: Colors.black, fontSize: 20),
                ),
              ),
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

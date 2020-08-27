import 'package:creaid/feed/FeedCommentObject.dart';
import 'package:creaid/utility/userDBService.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class FeedCommentPage extends ModalRoute<void> {
  final int index;
  final List<String> videos;
  final String documentId;
  final String author;
  final String feedId;
  FeedCommentPage(
      {this.documentId, this.author, this.index, this.videos, this.feedId});

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
            height: 400.0,
            width: 360.0,
            color: Colors.white,
            child: ListView(
              children: <Widget>[
                SizedBox(height: 20),
                Center(
                  child: Text("Comments",
                      style: GoogleFonts.mcLaren(
                        textStyle: TextStyle(
                            fontSize: 24,
                            color: Theme.of(context).primaryColor,
                            fontWeight: FontWeight.bold),
                      )),
                ),
                SizedBox(
                  height: 20,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
                  child: TextFormField(
                      validator: (val) =>
                          val.isEmpty ? 'Enter a valid comment' : null,
                      controller: interestHolder,
                      decoration: InputDecoration(
                        hintStyle: GoogleFonts.mcLaren(
                          textStyle: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 20),
                        ),
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
                                color: Theme.of(context).primaryColor),
                            child: Icon(Icons.comment),
                          ),
                          padding: EdgeInsets.only(left: 20, right: 10),
                        ),
                        suffixIcon: IconButton(
                          onPressed: () => {
                            UserDbService(uid: feedId).addComment(documentId,
                                feedId, interestHolder.text, author),
                            interestHolder.clear()
                          },
                          icon: Icon(Icons.send),
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
                      stream: UserDbService(uid: feedId)
                          .getFeedComments(documentId, feedId),
                      builder: (context, snapshot) {
                        if (snapshot.hasData) {
                          List<FeedCommentObject> feedCommentObject =
                              snapshot.data;
                          return ListView.separated(
                            physics: AlwaysScrollableScrollPhysics(),
                            separatorBuilder: (context, idx) => Divider(
                              color: Theme.of(context).primaryColor,
                            ),
                            itemCount: feedCommentObject.length,
                            itemBuilder: (context, idx) => InkWell(
                              child: ListTile(
                                title: Padding(
                                  padding: EdgeInsets.all(5),
                                  child: Text(
                                    feedCommentObject[idx].comment,
                                    style: GoogleFonts.mcLaren(
                                      textStyle: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 20),
                                    ),
                                  ),
                                ),
                                onTap: () {},
                              ),
                            ),
                          );
                        } else {
                          return Align(
                              alignment: Alignment.center,
                              child: CupertinoActivityIndicator());
                        }
                      },
                    ))
              ],
            ),
          ),
          RaisedButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              'Back to Feed',
              style: GoogleFonts.mcLaren(
                textStyle: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
              ),
            ),
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

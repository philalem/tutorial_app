class VideoFeedObject {
  String author;
  String videoUrl;
  int likes;
  List<String> comments;
  String documentId;
  String uid;

  VideoFeedObject(
    {this.author,
    this.videoUrl,
    this.likes,
    this.comments,
    this.documentId,
    this.uid
    }
  );
}
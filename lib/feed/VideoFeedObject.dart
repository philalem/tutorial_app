class VideoFeedObject {
  String author;
  List<String> videoUrls;
  int likes;
  List<String> comments;
  String documentId;
  String uid;
  String title;
  String description;
  String thumbnail;
  String ownerUid;

  VideoFeedObject(
      {this.author,
      this.videoUrls,
      this.likes,
      this.comments,
      this.documentId,
      this.uid,
      this.title,
      this.description,
      this.thumbnail,
      this.ownerUid});
}

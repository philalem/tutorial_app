const Firestore = require("@google-cloud/firestore");
const FieldValue = require("firebase-admin").firestore.FieldValue;

const firestore = new Firestore({
  projectId: process.env.GCP_PROJECT,
});

exports.incrementNotifications = async (id) => {
  return await firestore
    .collection("notifications")
    .doc(id)
    .update({ "new-notifications": FieldValue.increment(1) });
};

exports.sendLikeNotifications = async (snap, context) => {
  const userId = context.params.uid;
  const timestamp = new Date().getTime();
  const name = snap.data().name;
  exports.incrementNotifications(userId).catch((error) => {
    console.log(error);
  });

  return await firestore
    .collection("notifications")
    .doc(userId)
    .collection("notifications")
    .doc()
    .set({
      uid: userId,
      name: name,
      type: "like",
      comment: "",
      date: timestamp,
    });
};

exports.sendCommentNotifications = async (snap, context) => {
  const timestamp = new Date().getTime();
  const name = snap.data().name;
  const comment = snap.data().comment;
  const userId = snap.data().uid;

  exports.incrementNotifications(userId).catch((error) => {
    console.log(error);
  });

  return await firestore
    .collection("notifications")
    .doc(userId)
    .collection("notifications")
    .doc()
    .set({
      uid: userId,
      name: name,
      type: "comment",
      comment: comment,
      date: timestamp,
    });
};

exports.updateExplorePosts = async (snap, context) => {
  const videoId = context.params.videoId;
  const feedId = context.params.feedId;
  const currentExplorePosts = await exports.getExplorePosts();
  var lowestLikesPost = exports.findLowestLikedPost(currentExplorePosts);

  if (currentExplorePosts.length < 20) {
    return await exports.addToExplorePosts(feedId, videoId);
  }
  await exports.addNewPostIfItHasMoreLikes(exports, videoId, lowestLikesPost);
  return 0;
};

exports.getExplorePosts = async () => {
  const topPosts = await firestore.collection("explore").get();
  return topPosts.docs.map((postSnapshot) => ({
    id: postSnapshot.id,
    thumbnail: postSnapshot.get("thumbnail"),
    likes: postSnapshot.get("likes"),
  }));
};

exports.getPost = async (postId) => {
  return await firestore.collection("explore").doc(postId).get();
};

exports.addToExplorePosts = async (feedId, videoId) => {
  const post = await firestore
    .collection("posts")
    .doc(feedId)
    .collection("following-posts")
    .doc(videoId)
    .get();
  return await firestore.collection("explore").doc(videoId).set(post);
};

exports.removePostFromExplorePosts = async (videoId) => {
  return await firestore.collection("explore").doc(videoId).delete();
};

exports.findLowestLikedPost = (currentExplorePosts) => {
  var lowestLikes = Number.MAX_SAFE_INTEGER;
  var lowestLikesPost = { likes: Number.MAX_SAFE_INTEGER, id: null };
  var i;
  for (i = 0; i < currentExplorePosts.length; i++) {
    if (currentExplorePosts[i].likes < lowestLikes) {
      lowestLikesPost.likes = currentExplorePosts[i].likes;
      lowestLikesPost.id = currentExplorePosts[i].id;
    }
  }
  return lowestLikesPost;
};
exports.addNewPostIfItHasMoreLikes = async (videoId, lowestLikesPost) => {
  const postData = await exports.getPost(videoId);
  if (postData.get("likes") > lowestLikesPost.likes) {
    exports.removePostFromExplorePosts(lowestLikesPost.id);
    exports.addToExplorePosts(postData.get(id));
  }
};

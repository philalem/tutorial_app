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
  const userId = context.params.uid;
  const videoId = context.params.videoId;
  const feedId = context.params.feedId;
  const timestamp = new Date().getTime();
  const name = snap.data().name;
  const currentExplorePosts = exports.getExplorePosts();
  if (currentExplorePosts.length < 20) {
    exports.addToExplorePosts(feedId, videoId);
  }

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

exports.getExplorePosts = async () => {
  const topPosts = await firestore.collection("explore").get();
  return topPosts.docs.map((postSnapshot) => ({
    id: postSnapshot.id,
    thumbnail: postSnapshot.get("thumbnail"),
  }));
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

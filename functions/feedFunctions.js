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

exports.incrementLike = async (document, videoId) => {
  return await firestore
    .collection("posts")
    .doc(document)
    .collection("following-posts")
    .doc(videoId)
    .update({ "likes": FieldValue.increment(1) });
}

exports.addComment = async (document, videoId, comment, name, uid) => {
  return await firestore
    .collection("posts")
    .doc(document)
    .collection("following-posts")
    .doc(videoId)
    .collection("comments")
    .doc()
    .set({
      comment: comment,
      name: name,
      uid: uid
    });
}

exports.getUsers = async () => {
  const collection = await firestore.collection("posts").get();
    const documents = [];

    collection.docs.forEach(
      (document) => {
        documents.push(document.id);
      }
    );

    return documents
}

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
        type: "Like notification",
        comment: "",
        date: timestamp,
      });
};

exports.propagateLike = async (snap, context) => {
    const documents = exports.getUsers();
    const video = context.params.videoId;

    (await documents).forEach( document => {
      exports.incrementLike(document, video).catch((error) => {
        console.log(error);
      });
    });
};

exports.propagateComment = async (snap, context) => {
  const documents = exports.getUsers();
  const video = context.params.videoId;
  const name = snap.data().name;
  const comment = snap.data().comment;
  const userId = snap.data().uid;

  (await documents).forEach( document => {
    exports.addComment(document, video, comment, name, userId).catch((error) => {
      console.log(error);
    });
  });
}

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
        type: "Comment notification",
        comment: comment,
        date: timestamp,
      });
};
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
        type: "Like notification",
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
        type: "Comment notification",
        comment: comment,
        date: timestamp,
      });
};
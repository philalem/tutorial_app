const Firestore = require("@google-cloud/firestore");

const firestore = new Firestore({
  projectId: process.env.GCP_PROJECT,
});

exports.incrementFollowers = async (userId) => {
  return await firestore
    .collection("user-info")
    .doc(userId)
    .set({ "number-followers": firestore.FieldValue.increment(1) });
};

exports.decrementFollowers = async (userId) => {
  return await firestore
    .collection("user-info")
    .doc(userId)
    .set({ "number-followers": firestore.FieldValue.increment(-1) });
};

exports.addUserToFollowers = async (snap, context) => {
  const userId = context.params.userId;
  const followedUserId = context.params.followingId;
  exports.incrementFollowers(followedUserId);
  return await firestore
    .collection("follow-info")
    .doc(followedUserId)
    .collection("followers")
    .doc(userId)
    .set({ uid: userId });
};

exports.removeUserFromFollowers = async (snap, context) => {
  const userId = context.params.userId;
  const followedUserId = context.params.followingId;
  exports.decrementFollowers(followedUserId);
  return await firestore
    .collection("follow-info")
    .doc(followedUserId)
    .collection("followers")
    .doc(userId)
    .delete();
};

exports.incrementNewNotifications = async (userId) => {
  return await firestore
    .collection("follow-info")
    .doc(userId)
    .set({ "new-notifications": firestore.FieldValue.increment(1) });
};

exports.sendFollowNotification = async (snap, context) => {
  const userId = context.params.userId;
  const followedUserId = context.params.followingId;
  const followedUserName = snap.data().name;
  const timestamp = new Date().getTime();
  exports.incrementNewNotifications(followedUserId);
  return await firestore
    .collection("notifications")
    .doc(userId)
    .collection("notifications")
    .doc(followedUserId)
    .set({
      name: followedUserName,
      type: "follow",
      comment: "",
      date: timestamp,
    });
};

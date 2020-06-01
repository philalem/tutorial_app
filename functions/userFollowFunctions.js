const Firestore = require("@google-cloud/firestore");

const firestore = new Firestore({
  projectId: process.env.GCP_PROJECT,
});

exports.addUserToFollowers = async (snap, context) => {
  const userId = context.params.userId;
  const followedUserId = context.params.followingId;
  return await firestore
    .collection("user-info")
    .doc(followedUserId)
    .collection("followers")
    .doc(userId)
    .set({ uid: userId });
};

exports.removeUserFromFollowers = async (snap, context) => {
  const userId = context.params.userId;
  const followedUserId = context.params.followingId;
  return await firestore
    .collection("user-info")
    .doc(followedUserId)
    .collection("followers")
    .doc(userId)
    .delete();
};

exports.sendFollowNotification = async (snap, context) => {
  const userId = context.params.userId;
  const followedUserId = context.params.followingId;
  return await firestore
    .collection("user-info")
    .doc(userId)
    .collection("notifications")
    .doc(followedUserId)
    .set({ type: "follow" });
};

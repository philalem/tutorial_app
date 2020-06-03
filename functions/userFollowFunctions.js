const Firestore = require("@google-cloud/firestore");

const firestore = new Firestore({
  projectId: process.env.GCP_PROJECT,
});

exports.addUserToFollowers = async (snap, context) => {
  const userId = context.params.userId;
  const followedUserId = context.params.followingId;
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
  return await firestore
    .collection("follow-info")
    .doc(followedUserId)
    .collection("followers")
    .doc(userId)
    .delete();
};

exports.sendFollowNotification = async (snap, context) => {
  const userId = context.params.userId;
  const followedUserId = context.params.followingId;
  const followedUserName = snap.data().name;
  const timestamp = new Date().getTime();
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

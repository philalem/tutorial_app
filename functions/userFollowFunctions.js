const Firestore = require("@google-cloud/firestore");
const FieldValue = require("firebase-admin").firestore.FieldValue;

const firestore = new Firestore({
  projectId: process.env.GCP_PROJECT,
});

exports.incrementFollowers = async (userId) => {
  return await firestore
    .collection("user-info")
    .doc(userId)
    .update({ "number-followers": FieldValue.increment(1) });
};

exports.decrementFollowers = async (userId) => {
  return await firestore
    .collection("user-info")
    .doc(userId)
    .update({ "number-followers": FieldValue.increment(-1) });
};

exports.addUserToFollowers = async (snap, context, admin) => {
  const userId = context.params.userId;
  const followedUserId = context.params.followingId;
  exports.incrementFollowers(followedUserId).catch((error) => {
    console.log(error);
  });
  admin
    .auth()
    .getUser(userId)
    .then(async (userRecord) => {
      console.log("Successfully fetched user data:", userRecord.displayName);
      const displayName = userRecord.displayName;
      return await firestore
        .collection("follow-info")
        .doc(followedUserId)
        .collection("followers")
        .doc(userId)
        .set({ uid: userId, name: displayName });
    })
    .catch((error) => {
      console.log("Error fetching user data:", error);
    });
  return;
};

exports.removeUserFromFollowers = async (snap, context) => {
  const userId = context.params.userId;
  const followedUserId = context.params.followingId;
  exports.decrementFollowers(followedUserId).catch((error) => {
    console.log(error);
  });
  return await firestore
    .collection("follow-info")
    .doc(followedUserId)
    .collection("followers")
    .doc(userId)
    .delete();
};

exports.incrementNewNotifications = async (userId) => {
  return await firestore
    .collection("notifications")
    .doc(userId)
    .update({ "new-notifications": FieldValue.increment(1) });
};

exports.sendFollowNotification = async (snap, context) => {
  const userId = context.params.userId;
  const followerUserId = context.params.followerId;
  const followerUserName = snap.data().name;
  const timestamp = new Date().getTime();
  exports.incrementNewNotifications(userId).catch((error) => {
    console.log(error);
  });
  return await firestore
    .collection("notifications")
    .doc()
    .collection("notifications")
    .doc(followerUserId)
    .set({
      uid: followerUserId,
      name: followerUserName,
      type: "follow",
      comment: "",
      date: timestamp,
    });
};

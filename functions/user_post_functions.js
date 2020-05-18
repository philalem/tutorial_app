const functions = require("firebase-functions");
const firestoreInstance = functions.firestore.firestoreInstance;

exports.getUserFollowersIds = async (userId) => {
  const followers = await firestoreInstance
    .collection("userInfo")
    .doc(userId)
    .collection("followers")
    .get();
  return followers.docs.map((followerSnapshot) => followerSnapshot.id);
};

exports.createPostToFollowersBatchJobs = async (
  snap,
  context,
  isPostDeletion
) => {
  const data = snap.data();
  const postId = context.params.postId;
  const authorId = context.params.userId;

  const userPosts = firestoreInstance.collection("posts");
  try {
    const userFollowers = await getUserFollowersIds(authorId);

    if (userFollowers.length === 0) {
      return console.log("There are no followers to update feed.");
    }

    const batches = _.chunk(userFollowers, 500).map((userIds) => {
      const writeBatch = firestoreInstance.batch();
      if (isPostDeletion) {
        userIds.forEach((userId) => {
          writeBatch.delete(
            userPosts.doc(userId).collection("following-posts").doc(postId)
          );
        });
      } else {
        userIds.forEach((userId) => {
          writeBatch.set(
            userPosts.doc(userId).collection("following-posts").doc(postId),
            event.data.data()
          );
        });
      }
      return writeBatch.commit();
    });

    await Promise.all(batches);
    console.log("The feed of ", userFollowers.length, " have been update");
  } catch (err) {
    console.error(
      "Failed updating the users feed after the user",
      authorId,
      " posted ",
      postId,
      "with error",
      err
    );
    return 1;
  }
  return 0;
};

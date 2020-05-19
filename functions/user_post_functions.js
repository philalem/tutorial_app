const Firestore = require("@google-cloud/firestore");
const admin = require("firebase-admin");
const _ = require("underscore");
const path = require("path");
const ffmpeg = require("fluent-ffmpeg");

const firestore = new Firestore({
  projectId: process.env.GCP_PROJECT,
});

exports.getUserFollowersIds = async (userId) => {
  const followers = await firestore
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
  const postId = context.params.postId;
  const authorId = context.params.userId;

  const userPosts = firestore.collection("posts");
  try {
    const userFollowers = await exports.getUserFollowersIds(authorId);

    if (userFollowers.length === 0) {
      return console.log("There are no followers to update feed.");
    }

    const batches = _.chunk(userFollowers, 500).map((userIds) => {
      const writeBatch = firestore.batch();
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
            snap.data()
          );
        });
      }
      return writeBatch.commit();
    });

    await Promise.all(batches);
    console.log(
      "The feed of ",
      userFollowers.length,
      " follower(s) has been updated"
    );
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

exports.generateVideoThumbnail = async (object) => {
  const fullFilePath = object.name; // File path in the bucket.
  const fileName = path.baseName(fullFilePath);
  const pathName = path.dirname(fullFilePath);
  const thumbnailName = "thumbnail_" + fileName + ".png";
  const uid = object.owner.entity.uid;

  ffmpeg(fullFilePath)
    .screenshots({
      timestamps: [0.0],
      filename: thumbnailName,
      folder: pathName,
    })
    .on("end", () => {
      console.log("Generated thumbnail: " + thumbnailName);
    });

  firestore
    .collection("posts")
    .document(uid)
    .collection("user-posts")
    .setData({
      thumbnails: admin.firestore.FieldValue.arrayUnion(thumbnailName),
    });
};

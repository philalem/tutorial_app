const Firestore = require("@google-cloud/firestore");
const _ = require("underscore");
const path = require("path");
const os = require("os");
const fs = require("fs");
const ffmpeg = require("fluent-ffmpeg");
const ffmpegPath = require("@ffmpeg-installer/ffmpeg").path;

const firestore = new Firestore({
  projectId: process.env.GCP_PROJECT,
});

exports.getUserFollowersIds = async (userId) => {
  const followers = await firestore
    .collection("user-info")
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

exports.generateVideoThumbnail = async (object, admin) => {
  const fullFilePath = object.name;
  const fileBucket = object.fileBucket;
  const contentType = object.contentType;
  const fileName = path.basename(fullFilePath);
  const pathName = path.dirname(fullFilePath);
  const thumbnailName = "thumbnail_" + fileName + ".png";
  const directories = fullFilePath.split("/");
  const uid = directories[directories.length - 2];
  const bucket = admin.storage().bucket(fileBucket);
  const tempDirectory = path.join(os.tmpdir(), fileName);
  const metadata = {
    contentType: contentType,
  };

  await ffmpeg(fullFilePath)
    .setFfmpegPath(ffmpegPath)
    .screenshots({
      timestamps: [0.0],
      filename: thumbnailName,
      folder: tempDirectory,
    })
    .on("end", () => {
      console.log("Generated thumbnail: " + thumbnailName);
    });

  await bucket.upload(tempDirectory, {
    destination: pathName,
    metadata: metadata,
  });

  firestore
    .collection("posts")
    .document(uid)
    .collection("user-posts")
    .setData({
      thumbnails: admin.firestore.FieldValue.arrayUnion(thumbnailName),
    });
  return fs.unlinkSync(tempDirectory);
};

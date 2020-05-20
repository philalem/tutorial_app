const postFunctions = require("./user_post_functions");
const functions = require("firebase-functions");

exports.sendPostToFollowers = functions.firestore
  .document("posts/{userId}/user-posts/{postId}")
  .onCreate((snap, context) => {
    return postFunctions.createPostToFollowersBatchJobs(snap, context, false);
  });
// Shelving this for now.
//
// exports.generateThumbnailFromPost = functions.storage
//   .object()
//   .onFinalize(async (object) => {
//     return postFunctions.generateVideoThumbnail(object);
//   });

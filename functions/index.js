const postFunctions = require("./userPostFunctions");
const agoliaFunctions = require("./agoliaFunctions");
const functions = require("firebase-functions");
const admin = require("firebase-admin");
admin.initializeApp();
const db = admin.firestore();

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
//     return postFunctions.generateVideoThumbnail(object, admin);
//   });

// Create a HTTP request cloud function.
exports.sendUsersToAlgolia = functions.https.onRequest(async (req, res) => {
  return agoliaFunctions.sendDataToAgolia(req, res, db);
});

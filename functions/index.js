const postFunctions = require("./userPostFunctions");
const algoliaFunctions = require("./algoliaFunctions");
const functions = require("firebase-functions");
const admin = require("firebase-admin");
admin.initializeApp();
const db = admin.firestore();

exports.sendPostToFollowers = functions
  .region("us-east4")
  .firestore.document("posts/{userId}/user-posts/{postId}")
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
exports.sendUsersToAlgolia = functions
  .region("us-east4")
  .https.onRequest((req, res) => {
    return algoliaFunctions.sendDataToAgolia(req, res, db);
  });

exports.collectionOnCreate = functions
  .region("us-east4")
  .firestore.document("user-info/{uid}")
  .onCreate(async (snapshot, context) => {
    await algoliaFunctions.saveDocumentInAlgolia(snapshot);
  });

exports.collectionOnUpdate = functions
  .region("us-east4")
  .firestore.document("user-info/{uid}")
  .onUpdate(async (change, context) => {
    await algoliaFunctions.updateDocumentInAlgolia(change);
  });

exports.collectionOnDelete = functions
  .region("us-east4")
  .firestore.document("user-info/{uid}")
  .onDelete(async (snapshot, context) => {
    await algoliaFunctions.deleteDocumentFromAlgolia(snapshot);
  });

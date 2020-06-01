const postFunctions = require("./userPostFunctions");
const followFunctions = require("./userFollowFunctions");
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

exports.addUserToFollowers = functions
  .region("us-east4")
  .firestore.document("posts/{userId}/following/{followingId}")
  .onCreate((snap, context) => {
    return followFunctions.addUserToFollowers(snap, context);
  });

exports.removeUserFromFollowers = functions
  .region("us-east4")
  .firestore.document("posts/{userId}/following/{followingId}")
  .onDelete((snap, context) => {
    return followFunctions.removeUserFromFollowers(snap, context);
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
    return algoliaFunctions.sendUsersToAlgolia(req, res, db, "users");
  });

exports.sendUserNamesToAlgolia = functions
  .region("us-east4")
  .https.onRequest((req, res) => {
    return algoliaFunctions.sendUsernamesToAlgolia(req, res, db, "usernames");
  });

exports.collectionOnCreate = functions
  .region("us-east4")
  .firestore.document("user-info/{uid}")
  .onCreate(async (snapshot, context) => {
    await algoliaFunctions.saveUserInAlgolia(snapshot, "users");
  });

exports.collectionOnCreateForUsernames = functions
  .region("us-east4")
  .firestore.document("user-info/{uid}")
  .onCreate(async (snapshot, context) => {
    await algoliaFunctions.saveUsernameInAlgolia(snapshot, "usernames");
  });

exports.collectionOnUpdate = functions
  .region("us-east4")
  .firestore.document("user-info/{uid}")
  .onUpdate(async (change, context) => {
    await algoliaFunctions.updateDocumentInAlgolia(change, "users");
  });

exports.collectionOnUpdateForUsernames = functions
  .region("us-east4")
  .firestore.document("user-info/{uid}")
  .onUpdate(async (change, context) => {
    await algoliaFunctions.updateDocumentInAlgolia(change, "usernames");
  });

exports.collectionOnDelete = functions
  .region("us-east4")
  .firestore.document("user-info/{uid}")
  .onDelete(async (snapshot, context) => {
    await algoliaFunctions.deleteDocumentFromAlgolia(snapshot);
  });

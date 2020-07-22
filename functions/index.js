const postFunctions = require("./userPostFunctions");
const followFunctions = require("./userFollowFunctions");
const userFunctions = require("./userFunctions");
const algoliaFunctions = require("./algoliaFunctions");
const functions = require("firebase-functions");
const admin = require("firebase-admin");
const feedFunction = require("./feedFunctions");
admin.initializeApp();
const db = admin.firestore();

exports.sendPostToFollowers = functions
  .region("us-east4")
  .firestore.document("posts/{userId}/user-posts/{postId}")
  .onCreate((snap, context) => {
    return postFunctions.createPostToFollowersBatchJobs(snap, context, false);
  });

exports.deletePostFromFollowers = functions
  .region("us-east4")
  .firestore.document("posts/{userId}/user-posts/{postId}")
  .onDelete((snap, context) => {
    return postFunctions.createPostToFollowersBatchJobs(snap, context, true);
  });

exports.addUserToFollowers = functions
  .region("us-east4")
  .firestore.document("follow-info/{userId}/following/{followingId}")
  .onCreate((snap, context) => {
    return followFunctions.addUserToFollowers(snap, context, admin);
  });

exports.removeUserFromFollowers = functions
  .region("us-east4")
  .firestore.document("follow-info/{userId}/following/{followingId}")
  .onDelete((snap, context) => {
    return followFunctions.removeUserFromFollowers(snap, context);
  });

exports.sendFollowNotification = functions
  .region("us-east4")
  .firestore.document("follow-info/{userId}/followers/{followerId}")
  .onCreate((snap, context) => {
    return followFunctions.sendFollowNotification(snap, context);
  });

exports.sendLikeNotifications = functions
  .region("us-east4")
  .firestore.document("posts/{feedId}/following-posts/{videoId}/liked/{uid}")
  .onCreate((snap, context) => {
    return feedFunction.sendLikeNotifications(snap, context);
  });

// exports.updateExploreCollection = functions
//   .region("us-east4")
//   .firestore.document("posts/{feedId}/following-posts/{videoId}/liked/{uid}")
//   .onCreate((snap, context) => {
//     return feedFunction.updateExplorePosts(snap, context);
//   });

exports.sendCommentNotification = functions
  .region("us-east4")
  .firestore.document(
    "posts/{feedId}/following-posts/{videoId}/comments/{randomId}"
  )
  .onCreate((snap, context) => {
    return feedFunction.sendCommentNotifications(snap, context);
  });

// Create a HTTP request cloud function.

exports.sendUsersToAlgolia = functions
  .region("us-east4")
  .https.onRequest((req, res) => {
    return algoliaFunctions.sendUsersToAlgolia(req, res, db);
  });

exports.sendEmailsToAlgolia = functions
  .region("us-east4")
  .https.onRequest((req, res) => {
    return algoliaFunctions.sendEmailsToAlgolia(req, res, db);
  });

exports.onCreationOfUser = functions
  .region("us-east4")
  .firestore.document("user-info/{uid}")
  .onCreate(async (snapshot, context) => {
    userFunctions.addUserToUsersCollection(snapshot, context);
  });

exports.onMigrationOfUserInfoToUsers = functions
  .region("us-east4")
  .firestore.document("users/{uid}")
  .onCreate(async (snapshot, context) => {
    await algoliaFunctions.saveUserInAlgolia(snapshot);
  });

exports.onEmailCreation = functions
  .region("us-east4")
  .firestore.document("emails/{uid}")
  .onCreate(async (snapshot, context) => {
    await algoliaFunctions.saveEmailInAlgolia(snapshot);
  });

exports.onUsernameUpdate = functions
  .region("us-east4")
  .firestore.document("users/{uid}")
  .onUpdate(async (change, context) => {
    await algoliaFunctions.updateDocumentInAlgolia(change, "users");
  });

exports.onEmailUpdate = functions
  .region("us-east4")
  .firestore.document("emails/{uid}")
  .onUpdate(async (change, context) => {
    await algoliaFunctions.updateDocumentInAlgolia(change, "emails");
  });

exports.onUserDeletion = functions
  .region("us-east4")
  .firestore.document("users/{uid}")
  .onDelete(async (snapshot, context) => {
    await algoliaFunctions.deleteUserFromAlgolia(snapshot);
  });

exports.onEmailDeletion = functions
  .region("us-east4")
  .firestore.document("emails/{uid}")
  .onDelete(async (snapshot, context) => {
    await algoliaFunctions.deleteEmailFromAlgolia(snapshot);
  });

//TODO: add a function to move the original photo

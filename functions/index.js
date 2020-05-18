const createPostToFollowersBatchJobs = require("./user_post_functions");
const functions = require("firebase-functions");

// Create and Deploy Your First Cloud Functions
// https://firebase.google.com/docs/functions/write-firebase-functions

exports.helloWorld = functions.https.onRequest((request, response) => {
  response.send("Hello from Firebase!");
});

exports.sendPostToFollowers = functions.firestore
  .document("posts/{userId}/user-posts/{postId}")
  .onCreate((snap, context) => {
    return createPostToFollowersBatchJobs(snap, context, false);
  });

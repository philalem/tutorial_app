const Firestore = require("@google-cloud/firestore");

const firestore = new Firestore({
  projectId: process.env.GCP_PROJECT,
});

exports.addUserToUsersCollection = async (snap, context) => {
  const name = snap.data().name;
  const username = snap.data().username;
  const userId = context.params.uid;
  return await firestore
    .collection("users")
    .doc(userId)
    .set({ name: name, username: username });
};

exports.addEmailToEmailsCollection = async (snap, context) => {
  const email = snap.data().email;
  const userId = context.params.uid;
  return await firestore.collection("emails").doc(userId).set({ email: email });
};

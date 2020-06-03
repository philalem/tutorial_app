const algoliasearch = require("algoliasearch");
const functions = require("firebase-functions");

const algoliaClient = algoliasearch(
  functions.config().algolia.appid,
  functions.config().algolia.apikey
);
const userCollectionIndex = algoliaClient.initIndex("users");
const usernameCollectionIndex = algoliaClient.initIndex("usernames");

exports.sendUsersToAlgolia = async (req, res, db) => {
  const algoliaRecords = [];
  const querySnapshot = await db.collection("user-info").get();

  exports.sendUsernamesToAlgolia(req, res, db);

  querySnapshot.docs.forEach((doc) => {
    const document = doc.data();
    const record = {
      objectID: doc.id,
      name: document.name,
      username: document.username,
    };

    algoliaRecords.push(record);
  });

  await userCollectionIndex.saveObjects(algoliaRecords, (_error, content) => {
    res.status(200).send("COLLECTION was indexed to Algolia successfully.");
  });

  return res.status(200).send("Success");
};
exports.sendUsernamesToAlgolia = async (req, res, db) => {
  const algoliaRecords = [];
  const querySnapshot = await db.collection("user-info").get();

  querySnapshot.docs.forEach((doc) => {
    const document = doc.data();
    const record = {
      objectID: doc.id,
      username: document.username,
    };

    algoliaRecords.push(record);
  });

  await usernameCollectionIndex.saveObjects(
    algoliaRecords,
    (_error, content) => {
      res.status(200).send("COLLECTION was indexed to Algolia successfully.");
    }
  );

  return res.status(200).send("Success");
};

exports.saveUserInAlgolia = async (snapshot) => {
  exports.saveUsernameInAlgolia(snapshot);
  if (snapshot.exists) {
    const record = snapshot.data();
    if (record) {
      const user = {
        objectID: snapshot.id,
        name: record.name,
        username: record.username,
      };
      await userCollectionIndex.saveObject(user);
    }
  }
};
exports.saveUsernameInAlgolia = async (snapshot) => {
  if (snapshot.exists) {
    const record = snapshot.data();
    if (record) {
      // Removes the possibility of snapshot.data() being undefined.
      // We only index products that are complete.
      const username = {
        objectID: snapshot.id,
        username: record.username,
      };

      // In this example, we are including all properties of the Firestore document
      // in the Algolia record, but do remember to evaluate if they are all necessary.
      // More on that in Part 2, Step 2 above.

      await usernameCollectionIndex.saveObject(username); // Adds or replaces a specific object.
    }
  }
};

exports.updateDocumentInAlgolia = async (change) => {
  const docBeforeChange = change.before.data();
  const docAfterChange = change.after.data();
  if (docBeforeChange && docAfterChange) {
    if (docAfterChange.isIncomplete && !docBeforeChange.isIncomplete) {
      // If the doc was COMPLETE and is now INCOMPLETE, it was
      // previously indexed in algolia and must now be removed.
      await deleteDocumentFromAlgolia(change.after);
    } else if (docAfterChange.isIncomplete === false) {
      await saveDocumentInAlgolia(change.after);
    }
  }
};

exports.deleteDocumentFromAlgolia = async (snapshot) => {
  if (snapshot.exists) {
    const objectID = snapshot.id;
    await userCollectionIndex.deleteObject(objectID);
    await usernameCollectionIndex.deleteObject(objectID);
  }
};

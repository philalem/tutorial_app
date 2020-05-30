const algoliasearch = require("algoliasearch");
const functions = require("firebase-functions");

const algoliaClient = algoliasearch(
  functions.config().algolia.appid,
  functions.config().algolia.apikey
);

exports.sendUsersToAlgolia = async (req, res, db, collectionIndexName) => {
  const collectionIndex = algoliaClient.initIndex(collectionIndexName);
  const algoliaRecords = [];
  const querySnapshot = await db.collection("user-info").get();

  querySnapshot.docs.forEach((doc) => {
    const document = doc.data();
    const record = {
      objectID: doc.id,
      name: document.name,
      username: document.username,
    };

    algoliaRecords.push(record);
  });

  await collectionIndex.saveObjects(algoliaRecords, (_error, content) => {
    res.status(200).send("COLLECTION was indexed to Algolia successfully.");
  });

  return res.status(200).send("Success");
};
exports.sendUsernamesToAlgolia = async (req, res, db, collectionIndexName) => {
  const collectionIndex = algoliaClient.initIndex(collectionIndexName);
  // This array will contain all records to be indexed in Algolia.
  // A record does not need to necessarily contain all properties of the Firestore document,
  // only the relevant ones.
  const algoliaRecords = [];

  // Retrieve all documents from the COLLECTION collection.
  const querySnapshot = await db.collection("user-info").get();

  querySnapshot.docs.forEach((doc) => {
    const document = doc.data();
    // Essentially, you want your records to contain any information that facilitates search,
    // display, filtering, or relevance. Otherwise, you can leave it out.
    const record = {
      objectID: doc.id,
      username: document.username,
    };

    algoliaRecords.push(record);
  });

  // After all records are created, we save them to
  await collectionIndex.saveObjects(algoliaRecords, (_error, content) => {
    res.status(200).send("COLLECTION was indexed to Algolia successfully.");
  });

  return res.status(200).send("Success");
};

exports.saveUserInAlgolia = async (snapshot, collectionIndexName) => {
  const collectionIndex = algoliaClient.initIndex(collectionIndexName);
  if (snapshot.exists) {
    const record = snapshot.data();
    if (record) {
      if (record.isIncomplete === false) {
        const user = {
          objectID: snapshot.id,
          name: record.name,
          username: record.username,
        };
        await collectionIndex.saveObject(user);
      }
    }
  }
};
exports.saveUsernameInAlgolia = async (snapshot, collectionIndexName) => {
  const collectionIndex = algoliaClient.initIndex(collectionIndexName);
  if (snapshot.exists) {
    const record = snapshot.data();
    if (record) {
      // Removes the possibility of snapshot.data() being undefined.
      if (record.isIncomplete === false) {
        // We only index products that are complete.
        const username = {
          objectID: snapshot.id,
          username: record.username,
        };

        // In this example, we are including all properties of the Firestore document
        // in the Algolia record, but do remember to evaluate if they are all necessary.
        // More on that in Part 2, Step 2 above.

        await collectionIndex.saveObject(username); // Adds or replaces a specific object.
      }
    }
  }
};

exports.updateDocumentInAlgolia = async (change, collectionIndexName) => {
  const docBeforeChange = change.before.data();
  const docAfterChange = change.after.data();
  if (docBeforeChange && docAfterChange) {
    if (docAfterChange.isIncomplete && !docBeforeChange.isIncomplete) {
      // If the doc was COMPLETE and is now INCOMPLETE, it was
      // previously indexed in algolia and must now be removed.
      await deleteDocumentFromAlgolia(change.after, collectionIndexName);
    } else if (docAfterChange.isIncomplete === false) {
      await saveDocumentInAlgolia(change.after, collectionIndexName);
    }
  }
};

exports.deleteDocumentFromAlgolia = async (snapshot, collectionIndexName) => {
  const collectionIndex = algoliaClient.initIndex(collectionIndexName);
  if (snapshot.exists) {
    const objectID = snapshot.id;
    await collectionIndex.deleteObject(objectID);
  }
};

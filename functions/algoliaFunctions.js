const algoliasearch = require("algoliasearch");
const functions = require("firebase-functions");

const algoliaClient = algoliasearch(
  functions.config().algolia.appid,
  functions.config().algolia.apikey
);
const userCollectionIndex = algoliaClient.initIndex("users");

exports.sendUsersToAlgolia = async (req, res, db) => {
  const algoliaRecords = [];
  const querySnapshot = await db.collection("users").get();

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

exports.saveUserInAlgolia = async (snapshot) => {
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
  }
};

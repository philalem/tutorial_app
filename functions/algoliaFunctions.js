const algoliasearch = require("algoliasearch");
const functions = require("firebase-functions");

const algoliaClient = algoliasearch(
  functions.config().algolia.appid,
  functions.config().algolia.apikey
);
const userCollectionIndex = algoliaClient.initIndex("users");
const emailCollectionIndex = algoliaClient.initIndex("emails");

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

exports.sendEmailsToAlgolia = async (req, res, db) => {
  const algoliaRecords = [];
  const querySnapshot = await db.collection("emails").get();

  querySnapshot.docs.forEach((doc) => {
    const document = doc.data();
    const record = {
      objectID: doc.id,
      email: document.email,
    };

    algoliaRecords.push(record);
  });

  await emailCollectionIndex.saveObjects(algoliaRecords, (_error, content) => {
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

exports.saveEmailInAlgolia = async (snapshot) => {
  if (snapshot.exists) {
    const record = snapshot.data();
    if (record) {
      const user = {
        objectID: snapshot.id,
        email: record.email,
      };
      await emailCollectionIndex.saveObject(user);
    }
  }
};

exports.updateDocumentInAlgolia = async (change, type) => {
  const docBeforeChange = change.before.data();
  const docAfterChange = change.after.data();
  var isUsers = type === "users";
  if (docBeforeChange && docAfterChange) {
    if (docAfterChange.isIncomplete && !docBeforeChange.isIncomplete) {
      if (isUsers) {
        await this.deleteUserFromAlgolia(change.after);
      } else {
        await this.deleteEmailFromAlgolia(change.after);
      }
    } else if (docAfterChange.isIncomplete === false) {
      if (isUsers) {
        await this.saveUserInAlgolia(change.after);
      } else {
        await this.saveEmailInAlgolia(change.after);
      }
    }
  }
};

exports.deleteUserFromAlgolia = async (snapshot) => {
  if (snapshot.exists) {
    const objectID = snapshot.id;
    await userCollectionIndex.deleteObject(objectID);
  }
};

exports.deleteEmailFromAlgolia = async (snapshot) => {
  if (snapshot.exists) {
    const objectID = snapshot.id;
    await emailCollectionIndex.deleteObject(objectID);
  }
};

const algoliasearch = require("algoliasearch");
const functions = require("firebase-functions");

// Set up Algolia.
// The app id and API key are coming from the cloud functions environment, as we set up in Part 1, Step 3.
const algoliaClient = algoliasearch(
  functions.config().algolia.appid,
  functions.config().algolia.apikey
);
// Since I'm using develop and production environments, I'm automatically defining
// the index name according to which environment is running. functions.config().projectId is a default
// property set by Cloud Functions.
const collectionIndexName = "users";
const collectionIndex = algoliaClient.initIndex(collectionIndexName);

exports.sendDataToAgolia = async (req, res, db) => {
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
      name: document.name,
      email: document.email,
    };

    algoliaRecords.push(record);
  });

  // After all records are created, we save them to
  await collectionIndex.saveObjects(algoliaRecords, (_error, content) => {
    res.status(200).send("COLLECTION was indexed to Algolia successfully.");
  });

  return res.status(200).send("Success");
};

import 'package:algolia/algolia.dart';

class AlgoliaService {
  Algolia algolia = Algolia.init(
    applicationId: 'JRNVNTRH9V',
    apiKey: '409b8ed6d2483d5d25b3d738bd9a48ed',
  );

  Future<List<AlgoliaObjectSnapshot>> searchForUsers(text, hitsPerPage) async {
    AlgoliaQuery query = algolia.instance
        .index('users')
        .setHitsPerPage(hitsPerPage != null ? hitsPerPage : 5);
    query = query.search(text);
    return (await query.getObjects()).hits;
  }

  Future<bool> isThereAnExactUsernameMatch(potentialUsername) async {
    AlgoliaQuery query = algolia.instance.index('users').setHitsPerPage(1);
    query = query.search(potentialUsername);
    var hit = (await query.getObjects()).hits;
    if (hit.length == 0) {
      return false;
    }
    AlgoliaObjectSnapshot snap = hit[0];
    var closestMatch = snap.data['username'];
    return closestMatch == potentialUsername;
  }

  Future<bool> isThereAnExactEmailMatch(potentialEmail) async {
    AlgoliaQuery query = algolia.instance.index('emails').setHitsPerPage(1);
    query = query.search(potentialEmail);
    var hit = (await query.getObjects()).hits;
    if (hit.length == 0) {
      return false;
    }
    AlgoliaObjectSnapshot snap = hit[0];
    String closestMatch = snap.data['email'].toString().toLowerCase();
    return closestMatch == potentialEmail.toString().toLowerCase();
  }

  Future<String> getUserFromUserName(userName) async {
    AlgoliaQuery query = algolia.instance.index('users').setHitsPerPage(1);
    query = query.search(userName);
    var hit = (await query.getObjects()).hits;
    AlgoliaObjectSnapshot snap = hit[0];
    //var closestMatch = snap.data['uid'];
    print(snap.objectID);
    return snap.objectID;
  }
}

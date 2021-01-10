import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:getNav/models/data/follower_model.dart';
import 'user_api.dart';

class FollowerApi {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Stream<List<FollowerModel>> followerStream(String uid) {
    return _firestore
        .collection("users")
        .doc(uid)
        .collection("followers")
        .snapshots()
        .map((QuerySnapshot query) {
      List<FollowerModel> retVal = List();
      query.docs.forEach((element) {
        retVal.add(FollowerModel.fromDocumentSnapshot(element));
      });
      return retVal;
    });
  }

  Future<List<FollowerModel>> getFollowersFromUid(String uid) async {
    List<FollowerModel> retVal = List();
    await _firestore
        .collection("users")
        .doc(uid.trim())
        .collection("followers")
        .get()
        .then((value) {
      value.docs.forEach((element) {
        retVal.add(FollowerModel.fromDocumentSnapshot(element));
      });
    });

    print(retVal);
    return retVal;
  }

  Future<void> addThisToFollowersList(String uid, String username) async {
    print(username);
    String uidOfFollowing = await UserApi().getUidFromUsername(username);
    print(uidOfFollowing);
    try {
      await _firestore
          .collection("users")
          .doc(uidOfFollowing)
          .collection("followers")
          .add({
        'followerId': uid,
      });
    } catch (e) {
      print(e);
      rethrow;
    }
  }

  Future<void> removeThisFromFollowersList(String uid, String username) async {
    String uidOfFollowing = await UserApi().getUidFromUsername(username);
    print(uidOfFollowing);
    try {
      await _firestore
          .collection('users')
          .doc(uidOfFollowing.trim())
          .collection("followers")
          .where('followerId', isEqualTo: uid)
          .limit(1)
          .get()
          .then((snapshot) {
        snapshot.docs.first.reference.delete();
        print("FOLLOWER REMOVED");
      });
    } catch (e) {
      print(e);
      rethrow;
    }
  }

  Future<void> removeThemFromFollowersList(String uid, String username) async {
    String uidOfFollowing = await UserApi().getUidFromUsername(username);
    print(uidOfFollowing);
    try {
      await _firestore
          .collection('users')
          .doc(uid)
          .collection("followers")
          .where('followerId', isEqualTo: uidOfFollowing.trim())
          .limit(1)
          .get()
          .then((snapshot) {
        snapshot.docs.first.reference.delete();
        print("FOLLOWER REMOVED");
      });
    } catch (e) {
      print(e);
      rethrow;
    }
  }
}

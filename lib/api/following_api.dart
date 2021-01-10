import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:getNav/models/data/follower_model.dart';
import 'package:getNav/models/data/following_model.dart';
import 'user_api.dart';

class FollowingApi {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Stream<List<FollowingModel>> followingStream(String uid) {
    return _firestore
        .collection("users")
        .doc(uid)
        .collection("followings")
        .snapshots()
        .map((QuerySnapshot query) {
      // print(query.docs.length);
      List<FollowingModel> retVal = List();
      query.docs.forEach((element) {
        retVal.add(FollowingModel.fromDocumentSnapshot(element));
      });

      return retVal;
    });
  }

  Future<List<FollowingModel>> getFollowingsFromUid(String uid) async {
    List<FollowingModel> retVal = List();
    await _firestore
        .collection("users")
        .doc(uid.trim())
        .collection("followings")
        .get()
        .then((value) {
      value.docs.forEach((element) {
        retVal.add(FollowingModel.fromDocumentSnapshot(element));
      });
    });

    print(retVal);
    return retVal;
  }

  Future<void> addThemToFollowingsList(String uid, String username) async {
    String uidOfFollowing = await UserApi().getUidFromUsername(username);
    print(uidOfFollowing);
    try {
      await _firestore
          .collection("users")
          .doc(uid)
          .collection("followings")
          .add({
        'followingId': uidOfFollowing,
      });
    } catch (e) {
      print(e);
      rethrow;
    }
  }

  Future<void> removeThemFromFollowingsList(String uid, String username) async {
    String uidOfFollowing = await UserApi().getUidFromUsername(username);
    print(uidOfFollowing);
    try {
      await _firestore
          .collection('users')
          .doc(uid)
          .collection("followings")
          .where('followingId', isEqualTo: uidOfFollowing.trim())
          .limit(1)
          .get()
          .then((snapshot) {
        snapshot.docs.first.reference.delete();
        print("FOLLOWING REMOVED");
      });
    } catch (e) {
      print(e);
      rethrow;
    }
  }

  Future<void> removeThisFromFollowingsList(String uid, String username) async {
    String uidOfFollowing = await UserApi().getUidFromUsername(username);
    print(uidOfFollowing);
    try {
      await _firestore
          .collection('users')
          .doc(uidOfFollowing.trim())
          .collection("followings")
          .where('followingId', isEqualTo: uid)
          .limit(1)
          .get()
          .then((snapshot) {
        snapshot.docs.first.reference.delete();
        print("FOLLOWING REMOVED");
      });
    } catch (e) {
      print(e);
      rethrow;
    }
  }
}

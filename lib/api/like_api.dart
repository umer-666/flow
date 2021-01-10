import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:getNav/api/user_api.dart';
import 'package:getNav/controllers/auth_controller.dart';
import 'package:getNav/controllers/user_controller.dart';

class LikeApi {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<bool> addLike(String postOwnerUsername, String postUrl) async {
    String postOwnerUid = await UserApi().getUidFromUsername(postOwnerUsername);
    print(postOwnerUsername);
    print(postUrl);
    try {
      await _firestore
          .collection("users")
          .doc(postOwnerUid.trim())
          .collection("posts")
          .where('postUrl', isEqualTo: postUrl)
          .get()
          .then((value) => value.docs.first.reference.update({
                'likes': FieldValue.arrayUnion([
                  {
                    'likerId': AuthController.to.user.uid,
                    'likerUserName': UserController.to.user.userName,
                    'likerProfilePicUrl': UserController.to.user.profilePicUrl
                  }
                ])
              }));
      return true;
    } catch (e) {
      print(e);
      // rethrow;
      return false;
    }
  }

  Future<bool> removeLike(String usernameOfLiked, String postUrl) async {
    String postOwnerUid = await UserApi().getUidFromUsername(usernameOfLiked);
    try {
      await _firestore
          .collection("users")
          .doc(postOwnerUid.trim())
          .collection("posts")
          .where('postUrl', isEqualTo: postUrl)
          .get()
          .then((value) => value.docs.first.reference.update({
                'likes': FieldValue.arrayRemove([
                  {
                    'likerId': AuthController.to.user.uid,
                    'likerUserName': UserController.to.user.userName,
                    'likerProfilePicUrl': UserController.to.user.profilePicUrl
                  }
                ])
              }));
      return true;
    } catch (e) {
      print(e);
      rethrow;
    }
  }
}

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:getNav/api/user_api.dart';
import 'package:getNav/controllers/auth_controller.dart';
import 'package:getNav/controllers/user_controller.dart';

class CommentApi {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<bool> addComment(
      String postOwnerUsername, String postUrl, String commentText) async {
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
                'comments': FieldValue.arrayUnion([
                  {
                    'commenterId': AuthController.to.user.uid,
                    'commentText': commentText,
                    'commenterUserName': UserController.to.user.userName,
                    'commenterProfilePicUrl':
                        UserController.to.user.profilePicUrl,
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

  // Future<bool> removeLike(String postOwnerUsername, String postUrl) async {
  //   String postOwnerUid = await UserApi().getUidFromUsername(postOwnerUsername);
  //   try {
  //     await _firestore
  //         .collection("users")
  //         .doc(postOwnerUid.trim())
  //         .collection("posts")
  //         .where('postUrl', isEqualTo: postUrl)
  //         .get()
  //         .then((value) => value.docs.first.reference.update({
  //               'likes': FieldValue.arrayRemove([
  //                 {
  //                   'likerId': AuthController.to.user.uid,
  //                   'likerUserName': UserController.to.user.userName,
  //                   'likerProfilePicUrl': UserController.to.user.profilePicUrl
  //                 }
  //               ])
  //             }));
  //     return true;
  //   } catch (e) {
  //     print(e);
  //     rethrow;
  //   }
  // }
}

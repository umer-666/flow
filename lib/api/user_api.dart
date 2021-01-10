import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:getNav/models/data/user_model.dart';
import 'package:get/get.dart';
import 'package:getNav/controllers/user_controller.dart';

class UserApi {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<bool> createNewUser(UserModel user) async {
    try {
      await _firestore.collection("users").doc(user.id).set({
        "userName": user.userName,
        "email": user.email,
        "fullName": user.fullName,
        "profilePicUrl": user.profilePicUrl,
        "bio": user.bio,
      });
      return true;
    } catch (e) {
      print(e);
      return false;
    }
  }

  Future<bool> editUser(
      String fullName, String bio, String profilePicUrl) async {
    try {
      await Get.find<UserController>().editUser(fullName, bio, profilePicUrl);
      await _firestore
          .collection("users")
          .doc(Get.find<UserController>().user.id)
          .update({
        "fullName": fullName,
        "bio": bio,
        "profilePicUrl": profilePicUrl,
      });
      return true;
    } catch (e) {
      print(e);
      return false;
    }
  }

  Future<UserModel> getUserFromUid(String uid) async {
    try {
      DocumentSnapshot _doc =
          await _firestore.collection("users").doc(uid).get();

      return UserModel.fromDocumentSnapshot(documentSnapshot: _doc);
    } catch (e) {
      print(e);
      rethrow;
    }
  }

  Future<String> getUidFromUsername(String name) async {
    final QuerySnapshot result = await FirebaseFirestore.instance
        .collection('users')
        .where('userName', isEqualTo: name.toLowerCase())
        .limit(1)
        .get();
    final List<DocumentSnapshot> documents = result.docs;
    if (documents.length > 0) {
      return (documents[0].id);
    } else {
      return ('null');
    }
  }

  // Future<UserModel> getUserFromUid(String uid) async {
  //   final DocumentSnapshot result =
  //       await FirebaseFirestore.instance.collection('users').doc(uid).get();

  //   return (UserModel.fromDocumentSnapshot(documentSnapshot: result));
  // }
}

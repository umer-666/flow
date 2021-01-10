import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:getNav/api/user_api.dart';
import 'package:getNav/controllers/following_controller.dart';
import 'package:getNav/controllers/post_controller.dart';
import 'package:getNav/controllers/user_controller.dart';
import 'package:getNav/models/data/user_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:getNav/views/routes/login_screen.dart';
import 'package:getNav/global/constants/snackbar_style.dart' as SnackbarStyle;

import 'navigation/route_delegate.dart';
import 'follower_controller.dart';

class AuthController extends GetxController {
  static AuthController get to => Get.find();
  FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Rx<User> _firebaseUser = Rx<User>();

  User get user => _firebaseUser.value;

  @override
  onInit() {
    _firebaseUser.bindStream(_auth.authStateChanges());
  }

  ///[*********  SIGN UP / CREATE USER  *********]
  void createUser(String userName, String email, String name,
      String profilePicUrl, String password, String bio) async {
    try {
      if (await doesNameAlreadyExist(userName)) {
        Get.snackbar(
          "Error creating Account",
          "Username is already in use",
          colorText: SnackbarStyle.colorText,
          backgroundColor: SnackbarStyle.backgroundColor,
          margin: SnackbarStyle.margin,
          borderRadius: SnackbarStyle.borderRadius,
          snackStyle: SnackbarStyle.snackStyle,
          snackPosition: SnackbarStyle.snackPosition,
          forwardAnimationCurve: SnackbarStyle.forwardAnimationCurve,
          reverseAnimationCurve: SnackbarStyle.reverseAnimationCurve,
        );
        return;
      }
      UserCredential _authResult = await _auth.createUserWithEmailAndPassword(
          email: email.trim(), password: password);

      //create user in database.dart
      UserModel _user = UserModel(
        id: _authResult.user.uid,
        userName: userName.toLowerCase(),
        email: _authResult.user.email,
        fullName: name,
        profilePicUrl: profilePicUrl,
        bio: bio,
      );
      print("BEFORE BACK");
      if (await UserApi().createNewUser(_user)) {
        Get.find<UserController>().user = _user;
        // Get.find<PostController>().rebindStream();
        // Get.find<FollowerController>().rebindStream();
        // Get.find<FollowingController>().rebindStream();
        Get.back();
        print("AFTER BACK");
        // signOut();
        // Get.offAll(Root());
      }
    } catch (e) {
      Get.snackbar(
        "Error creating Account",
        e,
        colorText: SnackbarStyle.colorText,
        backgroundColor: SnackbarStyle.backgroundColor,
        margin: SnackbarStyle.margin,
        borderRadius: SnackbarStyle.borderRadius,
        snackStyle: SnackbarStyle.snackStyle,
        snackPosition: SnackbarStyle.snackPosition,
        forwardAnimationCurve: SnackbarStyle.forwardAnimationCurve,
        reverseAnimationCurve: SnackbarStyle.reverseAnimationCurve,
      );
    }
  }

  Future<bool> doesNameAlreadyExist(String name) async {
    final QuerySnapshot result = await FirebaseFirestore.instance
        .collection('users')
        .where('userName', isEqualTo: name.toLowerCase())
        .limit(1)
        .get();
    final List<DocumentSnapshot> documents = result.docs;
    return documents.length == 1;
  }

  ///[*********  LOGIN  *********]
  void login(String email, String password) async {
    try {
      UserCredential _authResult = await _auth.signInWithEmailAndPassword(
          email: email.trim(), password: password);
      Get.find<UserController>().user =
          await UserApi().getUserFromUid(_authResult.user.uid);
      // Get.off(Root());
    } catch (e) {
      Get.snackbar(
        "Error signing in",
        "$e",
        colorText: SnackbarStyle.colorText,
        backgroundColor: SnackbarStyle.backgroundColor,
        margin: SnackbarStyle.margin,
        borderRadius: SnackbarStyle.borderRadius,
        snackStyle: SnackbarStyle.snackStyle,
        snackPosition: SnackbarStyle.snackPosition,
        forwardAnimationCurve: SnackbarStyle.forwardAnimationCurve,
        reverseAnimationCurve: SnackbarStyle.reverseAnimationCurve,
      );
    }
  }

  ///[*********  LOGOUT / SIGNOUT  *********]
  void signOut() async {
    try {
      await _auth.signOut();
      Get.find<UserController>().clear();
      Get.find<PostController>().clear();
      Get.find<FollowingController>().clear();
      Get.find<FollowerController>().clear();
      Get.offAll(RouteDelegate());
    } catch (e) {
      Get.snackbar(
        "Error signing out",
        e,
        colorText: SnackbarStyle.colorText,
        backgroundColor: SnackbarStyle.backgroundColor,
        margin: SnackbarStyle.margin,
        borderRadius: SnackbarStyle.borderRadius,
        snackStyle: SnackbarStyle.snackStyle,
        snackPosition: SnackbarStyle.snackPosition,
        forwardAnimationCurve: SnackbarStyle.forwardAnimationCurve,
        reverseAnimationCurve: SnackbarStyle.reverseAnimationCurve,
      );
    }
  }
}

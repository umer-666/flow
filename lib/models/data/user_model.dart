import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  String id;
  String userName;
  String email;
  String fullName;
  String profilePicUrl;
  String bio;
  // List<String> followers;
  // List<String> following;
  // List<String> posts;
  // List<String> requestsSent;
  // List<String> requestsReceived;

  UserModel({
    this.id,
    this.userName,
    this.email,
    this.fullName,
    this.profilePicUrl,
    this.bio,
    // this.followers,
    // this.following,
    // this.posts,
    // this.requestsSent,
    // this.requestsReceived,
  });

  UserModel.fromDocumentSnapshot({DocumentSnapshot documentSnapshot}) {
    id = documentSnapshot.id;
    userName = documentSnapshot["userName"];
    email = documentSnapshot["email"];
    fullName = documentSnapshot["fullName"];
    profilePicUrl = documentSnapshot["profilePicUrl"];
    bio = documentSnapshot["bio"];
    // followers = documentSnapshot["followers"];
    // following = documentSnapshot["following"];
    // posts = documentSnapshot["posts"];
    // requestsSent = documentSnapshot["requestsSent"];
    // requestsReceived = documentSnapshot["requestsReceived"];
  }
}

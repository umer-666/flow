import 'package:cloud_firestore/cloud_firestore.dart';

class LikeModel {
  String likerId;

  String likerUserName;
  String likerProfilePicUrl;
  // String creationTime;
  // String location;
  // List<Like> likes;
  // List<Comment> comments;
  // String postUrl;

  LikeModel(
    this.likerId,
    this.likerUserName,
    this.likerProfilePicUrl,
    // this.postUrl,
  );
  LikeModel.fromMap(Map<dynamic, dynamic> data)
      : likerId = data["likerId"],
        likerUserName = data["likerUserName"],
        likerProfilePicUrl = data["likerProfilePicUrl"];

  LikeModel.fromDocumentSnapshot(
    DocumentSnapshot documentSnapshot,
  ) {
    likerId = documentSnapshot["likerId"];
    likerUserName = documentSnapshot["likerUserName"];
    likerProfilePicUrl = documentSnapshot["likerProfilePicUrl"];
    // postUrl = documentSnapshot["postUrl"];
  }
}

import 'package:cloud_firestore/cloud_firestore.dart';

class CommentModel {
  String commenterId;
  String commentText;
  String commenterUserName;
  String commenterProfilePicUrl;
  // String creationTime;
  // String location;
  // List<Like> likes;
  // List<Comment> comments;
  // String postUrl;

  CommentModel(
    this.commenterId,
    this.commentText,
    this.commenterUserName,
    this.commenterProfilePicUrl,
    // this.postUrl,
  );
  CommentModel.fromMap(Map<dynamic, dynamic> data)
      : commenterId = data["commenterId"],
        commentText = data["commentText"],
        commenterUserName = data["commenterUserName"],
        commenterProfilePicUrl = data["commenterProfilePicUrl"];

  CommentModel.fromDocumentSnapshot(
    DocumentSnapshot documentSnapshot,
  ) {
    commenterId = documentSnapshot["commenterId"];
    commentText = documentSnapshot["commentText"];
    commenterUserName = documentSnapshot["commenterUserName"];
    commenterProfilePicUrl = documentSnapshot["commenterProfilePicUrl"];
    // postUrl = documentSnapshot["postUrl"];
  }
}

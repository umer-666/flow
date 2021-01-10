import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:getNav/models/data/comment_model.dart';
import 'package:getNav/models/data/like_model.dart';

class PostModel {
  String userId;
  String userName;
  String postId;
  String postCaption;
  String timeStamp;
  String category;
  String postUrl;
  String thumbUrl;
  List<CommentModel> comments =  List<CommentModel>();
  List<LikeModel> likes =  List<LikeModel>();
  // String location;

  PostModel(
      this.userId,
      this.userName,
      this.postId,
      this.postCaption,
      this.postUrl,
      this.thumbUrl,
      this.timeStamp,
      this.comments,
      this.likes,
      this.category);

  PostModel.fromDocumentSnapshot(
    DocumentSnapshot documentSnapshot,
  ) {
    userId = documentSnapshot["userId"];
    userName = documentSnapshot["userName"];
    postId = documentSnapshot.id;
    postCaption = documentSnapshot["postCaption"];
    postUrl = documentSnapshot["postUrl"];
    thumbUrl = documentSnapshot["thumbUrl"];
    timeStamp = documentSnapshot["timeStamp"];
    category = documentSnapshot["category"];
    if (documentSnapshot['comments'].length == 0) {
      comments = [];
    } else {
      comments = documentSnapshot['comments'].map<CommentModel>((item) {
        return CommentModel.fromMap(item);
      }).toList();
    }
    if (documentSnapshot['likes'].length == 0) {
      likes = [];
    } else {
      likes = documentSnapshot['likes'].map<LikeModel>((item) {
        return LikeModel.fromMap(item);
      }).toList();
    }
  }
}

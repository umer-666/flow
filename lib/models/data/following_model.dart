import 'package:cloud_firestore/cloud_firestore.dart';

class FollowingModel {
  String followingId;

  FollowingModel(
    this.followingId,
  );

  FollowingModel.fromDocumentSnapshot(
    DocumentSnapshot documentSnapshot,
  ) {
    followingId = documentSnapshot["followingId"];
  }
}

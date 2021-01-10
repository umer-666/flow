import 'package:cloud_firestore/cloud_firestore.dart';

class FollowerModel {
  String followerId;

  FollowerModel(
    this.followerId,
  );

  FollowerModel.fromDocumentSnapshot(
    DocumentSnapshot documentSnapshot,
  ) {
    followerId = documentSnapshot["followerId"];
  }
}

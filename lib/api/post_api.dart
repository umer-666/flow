import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:getNav/utils/get_timestamp.dart';
import 'package:getNav/models/data/post_model.dart';
import 'package:getNav/controllers/following_controller.dart';

class PostApi {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Stream<List<PostModel>> personalPostStream(String uid) {
    return _firestore
        .collection("users")
        .doc(uid)
        .collection("posts")
        .orderBy("timeStamp", descending: true)
        .snapshots()
        .map((QuerySnapshot query) {
      List<PostModel> retVal = List();
      query.docs.forEach((element) {
        retVal.add(PostModel.fromDocumentSnapshot(element));
      });

      return retVal;
    });
  }

  Stream<List<PostModel>> followingsPostStream() {
    return _firestore
        .collectionGroup("posts")
        .orderBy("timeStamp", descending: true)
        .snapshots()
        .map((QuerySnapshot query) {
      List<PostModel> retVal = List();

      query.docs.forEach((element) {
        if (followingExists(element["userId"]) == -1) {
          return retVal;
        } else {
          if (followingExists(element["userId"]) == 1) {
            retVal.add(PostModel.fromDocumentSnapshot(element));
          }
        }
      });
      return retVal;
    });
  }

  Stream<List<PostModel>> explorePostStream(String uid) {
    return _firestore
        .collectionGroup("posts")
        .orderBy("timeStamp", descending: true)
        .snapshots()
        .map((QuerySnapshot query) {
      List<PostModel> retVal = List();

      query.docs.forEach((element) {
        // print(followingExists(element["userId"]));

        if (followingExists(element["userId"]) == 0 &&
            element["userId"] != uid) {
          retVal.add(PostModel.fromDocumentSnapshot(element));
        }
      });
      return retVal;
    });
  }
  Future<List<PostModel>> getPostsFromUid(String uid) async {
    List<PostModel> retVal = List();
    await _firestore
        .collection("users")
        .doc(uid.trim())
        .collection("posts")
        .get()
        .then((value) {
      value.docs.forEach((element) {
        retVal.add(PostModel.fromDocumentSnapshot(element));
      });
    });

    // print(retVal);
    return retVal;
  }   
  Future<void> addPost(String uid, String userName, String postCaption,
      String postUrl, String thumbUrl, String category) async {
    try {
      await _firestore.collection("users").doc(uid).collection("posts").add({
        'userName': userName,
        'userId': uid,
        'postCaption': postCaption,
        'postUrl': postUrl,
        'thumbUrl': thumbUrl,
        'timeStamp': getTimeStamp(),
        'category': category,
        'comments': [],
        'likes': [],
      });
    } catch (e) {
      print(e);
      rethrow;
    }
  }

  Future<void> deletePost(String uid, String postId) async {
    try {
      await _firestore
          .collection("users")
          .doc(uid)
          .collection("posts")
          .doc(postId)
          .delete();
      print("Deleted Successfully");
    } catch (e) {
      print(e);
      rethrow;
    }
  }

  int followingExists(String idToCheck) {
    // print(FollowingController);
    // print("followingExists: FollowingController.to.followings: ${FollowingController.to.followings}");
    if (FollowingController.to.followings != null) {
      if ((FollowingController.to.followings.singleWhere(
              (element) => element.followingId.trim() == idToCheck,
              orElse: () => null)) !=
          null) {
        return 1;
      } else {
        return 0;
      }
    } else {
      return -1;
    }
  }
}

import 'package:get/get.dart';
import 'package:getNav/api/post_api.dart';
import 'package:getNav/controllers/auth_controller.dart';
import 'package:getNav/controllers/following_controller.dart';
import 'package:getNav/models/data/post_model.dart';

class PostController extends GetxController {
  static PostController get to => Get.find();

  Rx<List<PostModel>> entirePostsList = Rx<List<PostModel>>();
  Rx<List<PostModel>> personalPostsList = Rx<List<PostModel>>();
  Rx<List<PostModel>> followingsPostsList = Rx<List<PostModel>>();
  Rx<List<PostModel>> explorePostsList = Rx<List<PostModel>>();

  List<PostModel> get entirePosts => entirePostsList.value;
  List<PostModel> get personalPosts => personalPostsList.value;
  List<PostModel> get followingsPosts => followingsPostsList.value;
  List<PostModel> get explorePosts => explorePostsList.value;

  int get entirePostsCount => entirePostsList.value?.length ?? 0;
  int get personalPostsCount => personalPostsList.value?.length ?? 0;
  int get followingsPostsCount => followingsPostsList.value?.length ?? 0;
  int get explorePostsCount => explorePostsList.value?.length ?? 0;

  void setPersonalPosts() {
    // print("POST COUNT: $postCount");
    String uid = Get.find<AuthController>().user.uid;
    // print("$uid");

    personalPostsList.value =
        entirePostsList().where((e) => e.userId == uid).toList();
    print("PERSONAL POST COUNT: $personalPostsCount");
    // for (var i = 0; i < postsList.value.length; i++) {
    //   print(postsList.value[i].userId);
    // }
  }

  // void setFollowingsPosts() {
  //   followingsPostsList.value =
  //       entirePostsList().where((e) => followingExists(e.userId)).toList();
  //   print("FOLLOWING POST COUNT: $followingsPostsCount");
  // }

  void setExplorePosts() {
    print("EXPLORE POST COUNT: $explorePostsCount");

    explorePostsList.value = List<PostModel>.from(entirePostsList());
    for (var elem in followingsPostsList()) {
      explorePostsList().remove(elem);
    }
    for (var elem in personalPostsList()) {
      explorePostsList().remove(elem);
    }
    print("EXPLORE POST COUNT: $explorePostsCount");
  }

  @override
  void onInit() {
    //stream coming from firebase
    print("POST CONTROLLER ON INIT");
    String uid = AuthController.to.user.uid;
    personalPostsList.bindStream(PostApi().personalPostStream(uid));
    followingsPostsList.bindStream(PostApi().followingsPostStream());
    explorePostsList.bindStream(PostApi().explorePostStream(uid));
  }

  void rebindStream() {
    String uid = AuthController.to.user.uid;

    personalPostsList.bindStream(PostApi().personalPostStream(uid));
    followingsPostsList.bindStream(PostApi().followingsPostStream());
    explorePostsList.bindStream(PostApi().explorePostStream(uid));
  }

  void clear() {
    entirePostsList.value = List<PostModel>();
    personalPostsList.value = List<PostModel>();
    followingsPostsList.value = List<PostModel>();
  }
}

import 'package:get/get.dart';
import 'package:getNav/controllers/auth_controller.dart';
import 'package:getNav/controllers/follower_controller.dart';
import 'package:getNav/controllers/following_controller.dart';
import 'package:getNav/controllers/post_controller.dart';
import 'package:getNav/controllers/user_controller.dart';

class SessionBinding extends Bindings {
  @override
  void dependencies() {
    Get.put<FollowingController>(FollowingController(), permanent: true);
    Get.put<FollowerController>(FollowerController(), permanent: true);
    Get.put<PostController>(PostController(), permanent: true);
  }
}

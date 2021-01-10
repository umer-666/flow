import 'package:get/get.dart';
import 'package:getNav/controllers/auth_controller.dart';
import 'package:getNav/controllers/follower_controller.dart';
import 'package:getNav/controllers/following_controller.dart';
import 'package:getNav/controllers/post_controller.dart';
import 'package:getNav/controllers/user_controller.dart';

class AuthBinding extends Bindings {
  @override
  void dependencies() {
    Get.put<AuthController>(AuthController(), permanent: true);
    Get.put<UserController>(UserController(), permanent: true);
  }
}

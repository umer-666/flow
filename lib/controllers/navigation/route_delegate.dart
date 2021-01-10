import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/src/simple/get_view.dart';
import 'package:getNav/views/routes/login_screen.dart';
import '../auth_controller.dart';
import '../follower_controller.dart';
import '../following_controller.dart';
import 'main_bottom_nav_controller.dart';
import '../user_controller.dart';
import '../post_controller.dart';

class RouteDelegate extends GetWidget<AuthController> {
  @override
  Widget build(BuildContext context) {
    return

        // GetX(
        // initState: (_) async {
        //   Get.put<UserController>(UserController());
        //   Get.lazyPut<FollowerController>(()=>FollowerController());
        //   Get.lazyPut<FollowingController>(()=>FollowingController());
        //   Get.lazyPut<PostController>(()=>PostController());
        // },
        // builder: (_) {
        // print("USER ID: ${Get.find<AuthController>().user?.uid}");
        Obx(() => (AuthController.to.user?.uid != null)
            ?
            // print("SUCCESS USER ID: ${Get.find<AuthController>().user?.uid}");
            MainBottomNav()
            :
            // print("FAIL USER ID: ${Get.find<AuthController>().user?.uid}");
            LoginScreen());
    // },
    // );
  }
}

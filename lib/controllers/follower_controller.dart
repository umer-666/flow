import 'package:get/get.dart';
import 'package:getNav/api/follower_api.dart';
import 'package:getNav/controllers/auth_controller.dart';
import 'package:getNav/models/data/follower_model.dart';

class FollowerController extends GetxController {
  static FollowerController get to => Get.find();

  Rx<List<FollowerModel>> followersList = Rx<List<FollowerModel>>();

  List<FollowerModel> get followers => followersList.value;
  int get followerCount => followersList.value?.length ?? 0;
  @override
  void onInit() {
    String uid = Get.find<AuthController>().user.uid;
    followersList.bindStream(
        FollowerApi().followerStream(uid)); //stream coming from firebase
  }

  void clear() {
    followersList.value = List<FollowerModel>();
  }

  void rebindStream() {
    String uid = Get.find<AuthController>().user.uid;
    followersList.bindStream(FollowerApi().followerStream(uid));
  }
}

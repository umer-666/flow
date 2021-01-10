import 'package:get/get.dart';
import 'package:getNav/api/following_api.dart';
import 'package:getNav/controllers/auth_controller.dart';
import 'package:getNav/models/data/following_model.dart';

class FollowingController extends GetxController {
  static FollowingController get to => Get.find();

  Rx<List<FollowingModel>> followingsList = Rx<List<FollowingModel>>();

  List<FollowingModel> get followings => followingsList.value;
  int get followingCount => followingsList.value?.length ?? 0;

  @override
  void onInit() {
    String uid = Get.find<AuthController>().user.uid;
    followingsList.bindStream(
        FollowingApi().followingStream(uid)); //stream coming from firebase
  }

  void clear() {
    followingsList.value = List<FollowingModel>();
  }

  void rebindStream() {
    String uid = Get.find<AuthController>().user.uid;
    followingsList.bindStream(FollowingApi().followingStream(uid));
  }
}

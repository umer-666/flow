import 'package:get/get.dart';
import 'package:getNav/models/data/like_model.dart';

class LikeController extends GetxController {
  static LikeController get to => Get.find();

  Rx<List<LikeModel>> likesList = Rx<List<LikeModel>>();

  List<LikeModel> get likes => likesList.value;
  int get likesCount => likesList.value?.length ?? 0;
  // @override
  // void onInit() {
  //   String uid = Get.find<AuthController>().user.uid;
  //   likesList.bindStream(
  //       Database().followerStream(uid)); //stream coming from firebase
  // }
  void clear() {
    likesList.value = List<LikeModel>();
  }
}

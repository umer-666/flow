import 'package:get/get.dart';
import 'package:getNav/models/data/comment_model.dart';

class CommentController extends GetxController {
  static CommentController get to => Get.find();

  Rx<List<CommentModel>> commentsList = Rx<List<CommentModel>>();

  List<CommentModel> get comments => commentsList.value;
  int get commentCount => commentsList.value?.length ?? 0;
  // @override
  // void onInit() {
  //   String uid = Get.find<AuthController>().user.uid;
  //   commentsList.bindStream(
  //       Database().followerStream(uid)); //stream coming from firebase
  // }
  void clear() {
    commentsList.value = List<CommentModel>();
  }
}

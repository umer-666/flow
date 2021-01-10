import 'package:get/get.dart';
import 'package:getNav/models/data/user_model.dart';

class UserController extends GetxController {
  static UserController get to => Get.find();

  Rx<UserModel> _userModel = UserModel().obs;

  UserModel get user => _userModel.value;

  set user(UserModel value) => this._userModel.value = value;
  set fullName(String value) => this._userModel.value.fullName = value;
  set bio(String value) => this._userModel.value.bio = value;
  set profilePicUrl(String value) =>
      this._userModel.value.profilePicUrl = value;

  void clear() {
    _userModel.value = UserModel();
  }

  Future<void> editUser(
      String fullName, String bio, String profilePicUrl) async {
    this.fullName = fullName;
    this.bio = bio;
    this.profilePicUrl = profilePicUrl;
  }

  ///[FOR DEBUGGING PURPOSES]
  // void display() {
  //   print(_userModel.value.id);
  //   print(_userModel.value.userName);
  //   print(_userModel.value.email);
  //   print(_userModel.value.fullName);
  //   print(_userModel.value.profilePicUrl);
  //   print(_userModel.value.bio);
  // }
}

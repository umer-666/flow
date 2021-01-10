import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:getNav/api/user_api.dart';
import 'package:getNav/controllers/navigation/main_bottom_nav_controller.dart';
import 'package:getNav/controllers/user_controller.dart';
import 'package:getNav/global/globals.dart' as global;
import 'package:getNav/views/shared/profile_pic_uploader.dart';
import 'package:getNav/controllers/services/imagebb_upload.dart';
import 'package:getNav/global/constants/snackbar_style.dart' as SnackbarStyle;

class EditScreen extends StatefulWidget {
  @override
  _EditScreenState createState() => _EditScreenState();
}

class _EditScreenState extends State<EditScreen> {
  final TextEditingController _nameController =
      TextEditingController(text: Get.find<UserController>().user.fullName);
  final TextEditingController _bioController =
      TextEditingController(text: Get.find<UserController>().user.bio);
  String _profilePicUrl = global.defaultProfilePicUrl;
  final _editFormKey = GlobalKey<FormBuilderState>();

  ///[GLOBAL FORM KEY GETTER]
  /// Returns a bool depneding on the current state of the entire form.
  /// Returns [true] if all fields are valid else returns [false].
  bool validateCredentials() => _editFormKey.currentState.saveAndValidate();

  /// Processes the form data based on the value of type
  /// [bool] returnd from the [golbal form key getter]
  void _submitForm() async {
    if (validateCredentials()) {
      var response = await uploadImageFile(global.profilePicPath);
      //  String postUrl = response['displayUrl'];
      String thumbUrl = response['thumbUrl'];

      _profilePicUrl = thumbUrl;
      bool success = await UserApi()
          .editUser(_nameController.text, _bioController.text, _profilePicUrl);
      if (success) {
        Get.off(MainBottomNav(
          routeIndex: 4,
        ));
        Get.snackbar(
          'Success',
          'Profile details updated',
          colorText: SnackbarStyle.colorText,
          backgroundColor: SnackbarStyle.backgroundColor,
          margin: SnackbarStyle.margin,
          borderRadius: SnackbarStyle.borderRadius,
          snackStyle: SnackbarStyle.snackStyle,
          snackPosition: SnackbarStyle.snackPosition,
          forwardAnimationCurve: SnackbarStyle.forwardAnimationCurve,
          reverseAnimationCurve: SnackbarStyle.reverseAnimationCurve,
        );
      } else {
        Get.snackbar(
          'Error Updating Details',
          'There was an error updating details, please try again',
          colorText: SnackbarStyle.colorText,
          backgroundColor: SnackbarStyle.backgroundColor,
          margin: SnackbarStyle.margin,
          borderRadius: SnackbarStyle.borderRadius,
          snackStyle: SnackbarStyle.snackStyle,
          snackPosition: SnackbarStyle.snackPosition,
          forwardAnimationCurve: SnackbarStyle.forwardAnimationCurve,
          reverseAnimationCurve: SnackbarStyle.reverseAnimationCurve,
        );
      }
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _bioController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(48),
        child: AppBar(
          centerTitle: true,
          backgroundColor: Colors.black,
          title: Text(
            'Edit Profile',
          ),
          // leading: IconButton(
          //   icon: Icon(
          //     Icons.clear,
          //     color: Colors.white,
          //     size: 36,
          //   ),
          //   onPressed: () {
          //     Get.off(MainBottomNav(
          //       routeIndex: 4,
          //     ));
          //   },
          // ),

          leading: RawMaterialButton(
            onPressed: () {
              // Get.off(
              //   MainBottomNav(
              //     routeIndex: 4,
              //   ),
              // );
              ///[route changed]
              Get.back();
            },
            child: Icon(
              Icons.clear,
              size: 36,
            ),
          ),
          actions: <Widget>[
            Container(
              width: 56,
              child: RawMaterialButton(
                  child: Icon(
                    Icons.done,
                    color: Colors.pink,
                    size: 36,
                  ),
                  onPressed: _submitForm
                  // Get.off(MainBottomNav(routeIndex: 0));
                  ),
            ),
          ],
          bottom: PreferredSize(
            preferredSize: Size.fromHeight(0.4),
            child: Container(
              color: Colors.grey[700],
              height: 0.4,
            ),
          ),
        ),
      ),
      body: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: FormBuilder(
          key: _editFormKey,
          child: SafeArea(
            child: Container(
              margin: EdgeInsets.symmetric(vertical: 0, horizontal: 12),
              child: ListView(
                  physics: BouncingScrollPhysics(
                      parent: AlwaysScrollableScrollPhysics()),
                  children: [
                    Column(children: <Widget>[
                      SizedBox(height: 16),

                      ///[PROFILE PICTURE PICKER]
                      ProfilePicUploader(
                          confirmedProfilePic:
                              Get.find<UserController>().user.profilePicUrl),

                      ///[NAME]
                      FormBuilderTextField(
                        name: 'name',
                        controller: _nameController,
                        cursorColor: Colors.white,
                        cursorWidth: 1,
                        style: TextStyle(fontSize: 18, color: Colors.white),
                        decoration: InputDecoration(labelText: 'Name'),
                        valueTransformer: (text) => text.toString().trim(),
                        validator: FormBuilderValidators.compose([
                          FormBuilderValidators.required(context),
                          FormBuilderValidators.minLength(context, 4),
                          FormBuilderValidators.maxLength(context, 16),
                        ]),
                      ),
                      SizedBox(height: 16),

                      ///[BIO]
                      FormBuilderTextField(
                        name: 'bio',
                        controller: _bioController,
                        cursorColor: Colors.white,
                        cursorWidth: 1,
                        style: TextStyle(fontSize: 18, color: Colors.white),
                        decoration: InputDecoration(labelText: 'Bio'),
                        valueTransformer: (text) => text.toString().trim(),
                        validator: FormBuilderValidators.compose([
                          FormBuilderValidators.minLength(context, 1),
                          FormBuilderValidators.maxLength(context, 40),
                        ]),
                      ),
                      SizedBox(height: 16),

                      /// [BIRTHDATE]
                      FormBuilderDateTimePicker(
                        name: 'birthdate',
                        inputType: InputType.date,
                        style: TextStyle(color: Colors.white),
                        decoration: InputDecoration(labelText: 'Birthdate'),
                        initialValue: DateTime.now(),
                      ),
                      SizedBox(height: 16),

                      ///[USERNAME]
                      FormBuilderTextField(
                        initialValue: Get.find<UserController>().user.userName,
                        name: 'username',
                        readOnly: true,
                        cursorColor: Colors.white,
                        cursorWidth: 1,
                        style: TextStyle(fontSize: 18, color: Colors.white),
                        decoration: InputDecoration(
                          labelText: 'Username',
                          // hintText: 'lisa',
                        ),
                      ),
                      SizedBox(height: 16),

                      ///[EMAIL]
                      FormBuilderTextField(
                        initialValue: Get.find<UserController>().user.email,
                        name: 'email',
                        readOnly: true,
                        cursorColor: Colors.white,
                        cursorWidth: 1,
                        style: TextStyle(fontSize: 18, color: Colors.white),
                        decoration: InputDecoration(
                          labelText: 'Email',
                          // hintText: 'lisa@mail.com',
                        ),
                      ),
                      SizedBox(height: 16),
                    ])
                  ]),
            ),
          ),
        ),
      ),
    );
  }
}

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:getNav/controllers/auth_controller.dart';
import 'package:getNav/custom/morph_button.dart';
import 'package:getNav/views/shared/profile_pic_uploader.dart';
import 'package:getNav/controllers/services/imagebb_upload.dart';
import '../../global/globals.dart' as global;

//ignore: must_be_immutable
class SignUpScreen extends GetWidget<AuthController> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  String _profilePicUrl = global.defaultProfilePicUrl;
  final _signUpFormKey = GlobalKey<FormBuilderState>();

  ///[GLOBAL FORM KEY GETTER]
  /// Returns a bool depneding on the current state of the entire form.
  /// Returns [true] if all fields are valid else returns [false].
  bool validateCredentials() => _signUpFormKey.currentState.saveAndValidate();

  /// Processes the form data based on the value of type
  /// [bool] returnd from the [golbal form key getter]
  void _submitForm() async {
    const String _bio = "Going with the flow! 🤍";
    if (validateCredentials()) {
      var response = await uploadImageFile(global.profilePicPath);
      //  String postUrl = response['displayUrl'];
      String thumbUrl = response['thumbUrl'];

      _profilePicUrl = thumbUrl ?? global.defaultProfilePicUrl;
      // _profilePicUrl = await uploadImageFile(global.profilePicPath);

      Get.find<AuthController>().createUser(
          _usernameController.text,
          _emailController.text,
          _nameController.text,
          _profilePicUrl,
          _passwordController.text,
          _bio);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // backgroundColor: Colors.black,
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(48),
        child: AppBar(
          centerTitle: true,
          backgroundColor: Colors.black,
          title: Text('Sign Up'),
          leading: Container(),
          bottom: PreferredSize(
              child: Container(
                color: Colors.grey[700],
                height: 0.4,
              ),
              preferredSize: Size.fromHeight(0.4)),
        ),
      ),
      body: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: FormBuilder(
          key: _signUpFormKey,
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
                    ProfilePicUploader(),

                    ///[NAME]
                    FormBuilderTextField(
                      name: 'name',
                      controller: _nameController,
                      cursorWidth: 1,
                      style: TextStyle(fontSize: 18, color: Colors.white),
                      decoration: InputDecoration(labelText: 'Name'),
                      valueTransformer: (text) => text.toString().trim(),
                      validator: FormBuilderValidators.compose([
                        FormBuilderValidators.minLength(context, 4),
                        FormBuilderValidators.maxLength(context, 16),
                      ]),
                    ),
                    SizedBox(height: 16),

                    ///[USERNAME]
                    FormBuilderTextField(
                      name: 'username',
                      controller: _usernameController,
                      cursorWidth: 1,
                      style: TextStyle(fontSize: 18, color: Colors.white),
                      decoration: InputDecoration(labelText: 'Username'),
                      valueTransformer: (text) => text.toString().trim(),
                      validator: FormBuilderValidators.compose([
                        FormBuilderValidators.required(context),
                        FormBuilderValidators.match(
                            context, r"^[a-zA-Z0-9_.]*$",
                            errorText:
                                'username can only use letters, numbers, underscores and full stops'),
                        FormBuilderValidators.minLength(context, 8),
                        FormBuilderValidators.maxLength(context, 32),
                      ]),
                    ),
                    SizedBox(height: 16),

                    ///[EMAIL]
                    FormBuilderTextField(
                      name: 'email',
                      controller: _emailController,
                      cursorWidth: 1,
                      style: TextStyle(fontSize: 18, color: Colors.white),
                      decoration: InputDecoration(labelText: 'Email'),
                      valueTransformer: (text) => text.toString().trim(),
                      validator: FormBuilderValidators.compose([
                        FormBuilderValidators.required(context),
                        FormBuilderValidators.email(context),
                        FormBuilderValidators.minLength(context, 8),
                        FormBuilderValidators.maxLength(context, 32),
                      ]),
                    ),
                    SizedBox(height: 16),

                    ///[PASSWORD]
                    FormBuilderTextField(
                      name: 'password',
                      controller: _passwordController,
                      obscureText: true,
                      cursorWidth: 1,
                      style: TextStyle(fontSize: 18, color: Colors.white),
                      decoration: InputDecoration(labelText: 'Password'),
                      valueTransformer: (text) => text.toString().trim(),
                      validator: FormBuilderValidators.compose([
                        FormBuilderValidators.minLength(context, 8),
                        FormBuilderValidators.maxLength(context, 64),
                      ]),
                    ),
                    SizedBox(height: 16),

                    ///[SIGN UP BUTTON]

                    MorphButton(
                        text: 'SIGN UP',
                        textStyle: TextStyle(fontSize: 16),
                        width: double.infinity,
                        height: 32,
                        margin: EdgeInsets.fromLTRB(2, 2, 2, 2),
                        filled: true,
                        onClick: _submitForm),

                    SizedBox(height: 16),

                    ///[GO BACK TO LOGIN SCREEN]
                    RichText(
                      text: TextSpan(
                        recognizer: TapGestureRecognizer()
                          ..onTap = () => Navigator.pop(context),
                          // ..onTap = () => Get.back(canPop: true),
                        text: "Already have an account? ",
                        style: TextStyle(color: Colors.white),
                        children: <TextSpan>[
                          TextSpan(
                              text: "Log in.",
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white)),
                        ],
                      ),
                    ),
                  ])
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

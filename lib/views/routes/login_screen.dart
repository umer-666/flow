import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:getNav/controllers/auth_controller.dart';
import 'package:getNav/custom/morph_button.dart';
import 'package:getNav/views/routes/signup_screen.dart';

class LoginScreen extends GetWidget<AuthController> {
// class LoginScreen extends StatefulWidget {
//   @override
//   _LoginScreenState createState() => _LoginScreenState();
// }

// class _LoginScreenState extends State<LoginScreen> {
  final _loginFormKey = GlobalKey<FormBuilderState>();

  ///[GLOBAL FORM KEY GETTER]
  /// Returns a bool depneding on the current state of the entire form.
  /// Returns [true] if all fields are valid else returns [false].
  bool validateCredentials() => _loginFormKey.currentState.saveAndValidate();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  /// Processes the form data based on the value of type
  /// [bool] returnd from the [golbal form key getter]
  void _submitForm() {
    if (validateCredentials()) {
      Get.find<AuthController>()
          .login(_emailController.text, _passwordController.text);
    }
  }

  // @override
  // void dispose() {
  //   _emailController.dispose();
  //   _passwordController.dispose();
  //   super.dispose();
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // backgroundColor: Colors.black,
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(48),
        child: AppBar(
          leading: Container(),
          centerTitle: true,
          backgroundColor: Colors.black,
          title: Text('Login'),
          bottom: PreferredSize(
              child: Container(
                color: Colors.grey[700],
                height: 0.4,
              ),
              preferredSize: Size.fromHeight(0.4)),
        ),
      ),
      body: GestureDetector(
        //onTap: () => FocusScope.of(context).unfocus(),
        child: FormBuilder(
          key: _loginFormKey,
          child: Container(
            //color: Colors.white60,
            margin: EdgeInsets.symmetric(vertical: 0, horizontal: 12),
            child: ListView(
              physics: BouncingScrollPhysics(
                  parent: AlwaysScrollableScrollPhysics()),
              children: [
                Column(children: <Widget>[
                  SizedBox(height: 128),

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
                    valueTransformer: (text) => text.toString(),
                    validator: FormBuilderValidators.compose([
                      FormBuilderValidators.required(context),
                      FormBuilderValidators.minLength(context, 8),
                      FormBuilderValidators.maxLength(context, 64),
                    ]),
                  ),

                  SizedBox(height: 32),

                  ///[LOGIN BUTTON]

                  MorphButton(
                      text: 'LOGIN',
                      textStyle: TextStyle(fontSize: 16),
                      width: double.infinity,
                      height: 32,
                      margin: EdgeInsets.fromLTRB(2, 2, 2, 2),
                      filled: true,
                      onClick: _submitForm),
                  SizedBox(height: 16),

                  ///[GO TO SIGNUP SCREEN]
                  ///[GO BACK TO LOGIN SCREEN]
                  RichText(
                    text: TextSpan(
                      recognizer: TapGestureRecognizer()
                        ..onTap = () => Get.to(SignUpScreen(),
                            transition: Transition.cupertino),
                      text: "Don't have an account? ",
                      style: TextStyle(color: Colors.white),
                      children: <TextSpan>[
                        TextSpan(
                            text: "Sign up.",
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.white)),
                      ],
                    ),
                  ),

                  SizedBox(height: 16),
                ])
              ],
            ),
          ),
        ),
      ),
    );
  }
}

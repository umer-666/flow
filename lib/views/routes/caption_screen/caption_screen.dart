import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:get/get.dart';
import 'package:getNav/api/post_api.dart';
import 'package:getNav/controllers/auth_controller.dart';
import 'package:getNav/controllers/user_controller.dart';
import 'package:getNav/controllers/navigation/main_bottom_nav_controller.dart';
import 'package:getNav/controllers/services/imagebb_upload.dart';
import 'package:getNav/models/data/data.dart';
import 'package:getNav/views/routes/caption_screen/widgets/caption_bar.dart';
import 'dart:ui';

//ignore: must_be_immutable
class CaptionScreen extends StatefulWidget {
  File pickedFile;
  String category;
  CaptionScreen({this.pickedFile, this.category}) : assert(pickedFile != null);
  @override
  createState() => CaptionScreenState();
}

class CaptionScreenState extends State<CaptionScreen>
    with WidgetsBindingObserver {
  final _captionController = TextEditingController();

  final FocusNode _searchBarFocusNode = FocusNode();
  final _captionBarKey = GlobalKey<FormBuilderState>();

  ///[GLOBAL FORM KEY GETTER]
  /// Returns a bool depneding on the current state of the entire form.
  /// Returns [true] if all fields are valid else returns [false].
  bool validateCredentials() => _captionBarKey.currentState.saveAndValidate();

  void _submitForm() async {
    if (validateCredentials()) {
      var response = await uploadImageFile(widget.pickedFile);
      String postUrl = response['displayUrl'];
      String thumbUrl = response['thumbUrl'];
      Get.off(MainBottomNav(routeIndex: 0));
      await PostApi().addPost(
          Get.find<AuthController>().user.uid,
          UserController.to.user.userName,
          _captionController.text,
          postUrl,
          thumbUrl,
          widget.category);
    }
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void didChangeMetrics() {
    super.didChangeMetrics();
    final value = WidgetsBinding.instance.window.viewInsets.bottom;
    if (value == 0) {
      _searchBarFocusNode.unfocus();
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _searchBarFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    //SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.dark.copyWith(statusBarColor: Colors.black));
    // FocusScope.of(context).unfocus();
    return Scaffold(
      // backgroundColor: Colors.red,
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(48),
        child: AppBar(
          centerTitle: true,
          backgroundColor: Colors.black,
          title: Text(
            'New Post',
          ),
          leading: Container(
            // color: Colors.pink,
            child: RawMaterialButton(
              onPressed: () {
                Get.back();
              },
              child: Icon(
                Icons.arrow_back,
                color: Colors.white,
                size: 36,
              ),
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
                  onPressed: _submitForm),
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
      body: Column(
        children: [
          Container(
            // color: Colors.green,
            child: CaptionBar(
              captionController: _captionController,
              captionBarFocusNode: _searchBarFocusNode,
              captionBarKey: _captionBarKey,
            ),
          ),
          Expanded(
            child: GestureDetector(
              onTapDown: (details) => FocusScope.of(context).unfocus(),
              child: Container(
                color: Colors.black,
              ),
            ),
          ),
        ],
      ),
      // ),
    );
  }
}

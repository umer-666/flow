import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:getNav/custom/no_glowing_overscroll_indicator.dart';
import 'package:getNav/api/comment_api.dart';
import 'package:get/get.dart';
import 'package:getNav/api/follower_api.dart';
import 'package:getNav/api/following_api.dart';
import 'package:getNav/api/post_api.dart';
import 'package:getNav/controllers/auth_controller.dart';
import 'package:getNav/models/data/comment_model.dart';
import 'package:getNav/controllers/user_controller.dart';
import 'package:getNav/models/data/post_model.dart';
import 'package:getNav/global/globals.dart' as global;
import 'package:getNav/api/user_api.dart';
import 'package:getNav/views/routes/public_profile_screen/public_profile_screen.dart';
import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';

//ignore: must_be_immutable
class CommentsScreen extends StatefulWidget {
  final PostModel postObj;
  CommentsScreen({@required this.postObj});

  @override
  _CommentsScreenState createState() => _CommentsScreenState();
}

class _CommentsScreenState extends State<CommentsScreen> {
  final FocusNode _commentBarFocusNode = FocusNode();
  final _commentController = TextEditingController();
  final _commentBarKey = GlobalKey<FormBuilderState>();

  Future<void> _postComment() async {
    CommentApi().addComment(widget.postObj.userName, widget.postObj.postUrl,
        _commentController.text);
    widget.postObj.comments.add(CommentModel(
      AuthController.to.user.uid,
      _commentController.text,
      UserController.to.user.userName,
      UserController.to.user.profilePicUrl,
    ));
    _commentController.clear();
    FocusScope.of(context).unfocus();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(48),
        child: AppBar(
          title: Text('Comments'),
          elevation: 0,
          backgroundColor: Colors.black,
          leading: RawMaterialButton(
            onPressed: () => Navigator.pop(context),
            child: Icon(
              Icons.arrow_back,
              color: Colors.white,
              size: 28,
            ),
          ),
        ),
      ),
      body: Stack(
        children: [
          Positioned(
            top: 0,
            width: Get.width,
            height: 62,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 4),
              child: Text(widget.postObj.postCaption,
                  style: TextStyle(color: Colors.white) ?? 'CAPTION'),
            ),
          ),
          Positioned(
            top: 63,
            width: Get.width,
            height: 0.4,
            child: PreferredSize(
              preferredSize: Size.fromHeight(0.4),
              child: Container(
                color: Colors.grey[700],
                // color: Colors.green,
              ),
            ),
          ),
          Positioned(
            width: Get.width,
            height: Get.height - 48 * 3 - 40,
            top: 64,
            child: GestureDetector(
              onTapDown: (details) => FocusScope.of(context).unfocus(),
              onTap: () => FocusScope.of(context).unfocus(),
              onTapCancel: () => FocusScope.of(context).unfocus(),
              child: SafeArea(
                child: NoGlowingOverscrollIndicator(
                  child: ListView.builder(
                    itemCount: widget.postObj.comments?.length ?? 0,
                    itemBuilder: (context, index) {
                      return Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 4, vertical: 0),
                        child: ListTile(
                          // tileColor: Colors.purple,
                          leading: ClipOval(
                            child: Image.network(
                              widget.postObj.comments[index]
                                      .commenterProfilePicUrl ??
                                  global.defaultProfilePicUrl,
                              width: 40,
                              height: 40,
                              fit: BoxFit.cover,
                            ),
                          ),
                          title: Text(
                              widget.postObj.comments[index]
                                      .commenterUserName ??
                                  'Username',
                              style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16)),
                          subtitle: Text(
                              widget.postObj.comments[index].commentText ??
                                  'commentText',
                              style:
                                  TextStyle(color: Colors.white, fontSize: 16)),
                          onTap: () async {
                            var uid = await UserApi().getUidFromUsername(widget
                                .postObj.comments[index].commenterUserName);
                            var user = await UserApi().getUserFromUid(uid);
                            var posts = await PostApi().getPostsFromUid(uid);
                            var followers =
                                await FollowerApi().getFollowersFromUid(uid);
                            var followings =
                                await FollowingApi().getFollowingsFromUid(uid);

                            pushNewScreen(context,
                                screen: PublicProfileScreen(
                                  userObj: user,
                                  followerObj: followers,
                                  followingObj: followings,
                                  postObj: posts,
                                ),
                                withNavBar: true,
                                pageTransitionAnimation:
                                    PageTransitionAnimation.cupertino);
                          },
                        ),
                      );
                    },
                  ),
                ),
              ),
            ),
          ),
          Positioned(
            width: Get.width,
            height: 48,
            bottom: 0,
            child: FormBuilder(
              key: _commentBarKey,
              child: FormBuilderTextField(
                focusNode: _commentBarFocusNode,
                controller: _commentController,
                name: 'commentBar',
                cursorColor: Colors.white,
                cursorWidth: 1,
                style: TextStyle(fontSize: 18, color: Colors.white),
                decoration: InputDecoration(
                  suffix: GestureDetector(
                    onTap: () => _postComment(),
                    child: Text(
                      'Post',
                      style: TextStyle(color: Colors.pink[300]),
                    ),
                  ),
                  filled: true,
                  fillColor: Colors.grey[800],
                  focusedBorder: UnderlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(0)),
                    borderSide: BorderSide(color: Colors.transparent),
                  ),
                  enabledBorder: UnderlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(0)),
                    borderSide: BorderSide(color: Colors.transparent),
                  ),
                  hintText: 'Add a comment...',
                  hintStyle:
                      TextStyle(fontSize: 16, color: Colors.white, height: 1.5),
                ),
                valueTransformer: (text) => text.toString().trim(),
                validator: FormBuilderValidators.compose([
                  FormBuilderValidators.required(context),
                  //FormBuilderValidators.minLength(context, 4),
                  FormBuilderValidators.maxLength(context, 32),
                ]),
              ),
            ),
          )
        ],
      ),
    );
  }
}

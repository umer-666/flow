import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:getNav/controllers/follower_controller.dart';
import 'package:getNav/controllers/following_controller.dart';
import 'package:getNav/controllers/post_controller.dart';
import 'package:getNav/controllers/user_controller.dart';
import 'package:getNav/custom/no_glowing_overscroll_indicator.dart';
import 'package:getNav/views/shared/empty_list_indicator.dart';
import 'package:getNav/views/shared/null_Indicator.dart';
import 'package:getNav/views/shared/post.dart';

//ignore:must_be_immutable
class PersonalPostPageView extends StatelessWidget {
  PersonalPostPageView({
    @required this.postNumber,
  }) : assert(postNumber != null && postNumber >= 0);
  // assert(images != null);
  // final List<PostModel> images =  Get.find<PostController>().posts;
  int postNumber;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(48),
          child: AppBar(
            elevation: 0,
            backgroundColor: Colors.black,
            leading: RawMaterialButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Icon(
                Icons.arrow_back,
                size: 28,
              ),
            ),
            title: Text('Posts'),
            bottom: PreferredSize(
              preferredSize: Size.fromHeight(0.4),
              child: Container(
                color: Colors.grey[700],
                height: 0.4,
              ),
            ),
          ),
        ),
        body: (PostController.to != null)
            ? (PostController.to.personalPosts != null)
                ? Obx(
                    () => NoGlowingOverscrollIndicator(
                        child: PageView.builder(
                      pageSnapping: false,
                      scrollDirection: Axis.vertical,
                      controller: PageController(
                        viewportFraction: 0.95,
                        initialPage: postNumber,
                      ),
                      itemCount: PostController.to.personalPostsCount,
                      itemBuilder: (BuildContext context, int itemIndex) {
                        return Post(
                          profilePicUrl: UserController.to.user.profilePicUrl,
                          onClick: () {
                            Navigator.pop(context);
                          },
                          postObj: PostController.to.personalPosts[itemIndex],
                        );
                      },
                    )),
                  )
                : NullIndicator()
            : EmptyListIndicator(''));
  }
}

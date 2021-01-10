import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:get/get.dart';
import 'package:getNav/models/data/post_model.dart';
import 'package:getNav/views/shared/empty_list_indicator.dart';
import 'package:getNav/views/shared/build_post_grid.dart';
import 'package:getNav/controllers/user_controller.dart';
import 'package:getNav/controllers/post_controller.dart';
import 'package:getNav/controllers/follower_controller.dart';
import 'package:getNav/controllers/following_controller.dart';
import 'package:getNav/custom/no_glowing_overscroll_indicator.dart';
import 'package:getNav/views/routes/personal_profile_screen/widgets/personal_profile_head.dart';
import 'package:getNav/views/routes/personal_profile_screen/widgets/profile_drawer.dart';
import 'package:getNav/views/shared/null_Indicator.dart';

//ignore:must_be_immutable
class PersonalProfileScreen extends StatefulWidget {
  @override
  _PersonalProfileScreenState createState() => _PersonalProfileScreenState();
}

class _PersonalProfileScreenState extends State<PersonalProfileScreen> {
  List<PostModel> postList = PostController.to.personalPosts;
  int postCount = PostController.to.personalPostsCount;

  @override
  Widget build(BuildContext context) {
    return (UserController.to != null &&
            FollowerController.to != null &&
            FollowingController.to != null &&
            PostController.to != null)
        ? (postList.isEmpty != true)
            ? Scaffold(
                endDrawer: ProfileDrawer(),
                appBar: PreferredSize(
                  preferredSize: Size.fromHeight(48),
                  child: AppBar(
                    centerTitle: true,
                    elevation: 0,
                    backgroundColor: Colors.black,
                    title: Obx(() =>
                        Text(Get.find<UserController>().user.userName ?? '')),

                    /// Remove Back button on endDrawer on Main Scaffold
                    automaticallyImplyLeading: false,
                    leading: Container(),

                    ///[CUSTOM DIVIDER]
                    bottom: PreferredSize(
                      child: Container(
                        color: Colors.grey[700],
                        height: 0.4,
                      ),
                      preferredSize: Size.fromHeight(0.4),
                    ),
                  ),
                ),
                body: NoGlowingOverscrollIndicator(
                  child: CustomScrollView(
                    slivers: <Widget>[
                      SliverAppBar(
                        ///Remove endDrawer menu button appearing below the main app bar
                        actions: <Widget>[Container()],
                        leading: Container(),

                        ///[SETTINGS PARAMETER]
                        floating: false,

                        /// [PROFILE SCREEN HEAD]
                        flexibleSpace: PersonalProfileHead(),
                        expandedHeight: 210,
                        toolbarHeight: 210,
                      ),

                      ///[PERSONAL POST GRID]

                      buildPostGrid(
                          postList: postList,
                          postCount: postCount,
                          parent: 'personal_profile_screen'),
                    ],
                  ),
                ),
              )
            : NullIndicator()
        : EmptyListIndicator('');
  }
}

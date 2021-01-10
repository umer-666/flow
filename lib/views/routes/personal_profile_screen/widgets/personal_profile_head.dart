import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:getNav/controllers/follower_controller.dart';
import 'package:getNav/controllers/following_controller.dart';
import 'package:getNav/controllers/post_controller.dart';

import 'package:getNav/controllers/user_controller.dart';
import 'package:getNav/custom/morph_button.dart';
import 'package:getNav/controllers/navigation/follow_scroll_nav_controller.dart';
import 'package:getNav/views/routes/edit_screen.dart';
import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';
import '../../../shared/profile_button.dart';
import '../../../../global/globals.dart' as global;

class PersonalProfileHead extends StatelessWidget {
  // String userName;
  // String fullName;
  // String profilePicUrl;
  // String bio;
  // int postCount;
  // int followerCount;
  // int followingCount;

  // PersonalProfileHead(
  //     {this.userName = 'username',
  //     this.fullName = 'name goes here',
  //     this.profilePicUrl = global.defaultProfilePicUrl,
  //     this.bio = 'Going with the flow! 🤍',
  //     this.postCount = 0,
  //     this.followerCount = 0,
  //     this.followingCount = 0})
  //     : assert(userName != null);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body:
          // SingleChildScrollView(
          //   physics: NeverScrollableScrollPhysics(),
          //   child:

          GetX(
        builder: (_) => Container(
          // color: Colors.amber,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            // crossAxisAlignment: CrossAxisAlignment.baseline,
            // mainAxisSize: MainAxisSize.max,
            children: [
              /// First in three rows that make up the [PersonalProfileHead].
              Container(
                //  color: Colors.orange,
                padding: EdgeInsets.fromLTRB(5, 5, 5, 5),
                margin: EdgeInsets.fromLTRB(5, 5, 5, 5),
                child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      ///[PROFILE PICTURE] on personal profile head

                      // (Get.find<UserController>().user.profilePicUrl == null)
                      //     ? ClipOval(
                      //         child: Container(
                      //             // color: Colors.white.withOpacity(0.15),
                      //             color: Colors.amber,
                      //             height: 90,
                      //             width: 90),
                      //       ):
                      ClipOval(
                        child: Image.network(
                            Get.find<UserController>().user.profilePicUrl ??
                                global.defaultProfilePicUrl,
                            height: 90,
                            width: 90,
                            fit: BoxFit.cover),
                      ),

                      ///[POST BUTTON]
                      ProfileButton(
                        title: 'Posts',
                        count:
                            Get.find<PostController>().personalPostsCount ?? 0,
                        onClick: () {},
                      ),

                      ///[FOLLOWER BUTTON]
                      ProfileButton(
                        title: 'Followers',
                        count:
                            Get.find<FollowerController>().followerCount ?? 0,
                        onClick: () {
                          pushNewScreen(context,
                              screen: FollowNav(initialPage: 0),
                              withNavBar: true,
                              pageTransitionAnimation:
                                  PageTransitionAnimation.cupertino);
                        },
                      ),

                      ///[FOLLOWING BUTTON]
                      ProfileButton(
                        title: 'Following',
                        count:
                            Get.find<FollowingController>().followingCount ?? 0,
                        onClick: () {
                          pushNewScreen(
                            context,
                            screen: FollowNav(initialPage: 1),
                            withNavBar: true,
                            pageTransitionAnimation:
                                PageTransitionAnimation.cupertino,
                          );
                        },
                      ),
                    ]),
              ),

              /// [Second] in three rows that make up the [PersonalProfileHead].
              /// [FULLNAME] and [BIO]
              Container(
                width: double.infinity,
                // color: Colors.purple,
                // padding: EdgeInsets.fromLTRB(10, 8, 10, 8),
                margin: EdgeInsets.fromLTRB(10, 4, 10, 0),
                child: Column(
                  // mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ///[FULLNAME TEXT]
                    Padding(
                      padding: const EdgeInsets.fromLTRB(0, 0, 0, 2),
                      child: Text(
                          Get.find<UserController>().user.fullName ??
                              'Beautiful',
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.white)),
                    ),

                    ///[BIO TEXT]

                    Text(
                        Get.find<UserController>().user.bio ??
                            'Going with the flow! 🤍',
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1,
                        style: TextStyle(color: Colors.white)),
                  ],
                ),
              ),

              /// [Third] in three rows that make up the [PersonalProfileHead].
              /// [EDIT PROFILE BUTTON]

              Container(
                // color: Colors.green,
                child: MorphButton(
                    text: 'Edit Profile',
                    textStyle: TextStyle(fontSize: 15),
                    width: double.infinity,
                    height: 28,
                    margin: EdgeInsets.symmetric(horizontal: 10, vertical: 16),
                    onClick: () {
                      // Get.off(
                      //   EditScreen(),
                      //   transition: Transition.cupertino,
                      //   // duration: Duration(milliseconds: 200)
                      // );
                      ///[route changed]
                      Get.to(
                        EditScreen(),
                        transition: Transition.cupertino,
                        // duration: Duration(milliseconds: 200)
                      );
                    }),
              ),
            ],
          ),
        ),
      ),

      // ),
    );
  }
}

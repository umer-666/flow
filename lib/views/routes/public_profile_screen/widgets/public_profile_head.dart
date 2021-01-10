import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:getNav/api/follower_api.dart';
import 'package:getNav/api/following_api.dart';
import 'package:getNav/controllers/auth_controller.dart';
import 'package:getNav/controllers/follower_controller.dart';
import 'package:getNav/controllers/following_controller.dart';
import 'package:getNav/controllers/post_controller.dart';
import 'package:getNav/controllers/user_controller.dart';
import 'package:getNav/custom/morph_button.dart';
import 'package:getNav/controllers/navigation/follow_scroll_nav_controller.dart';
import 'package:getNav/models/data/follower_model.dart';
import 'package:getNav/models/data/following_model.dart';
import 'package:getNav/models/data/post_model.dart';
import 'package:getNav/models/data/user_model.dart';
import 'package:getNav/views/routes/edit_screen.dart';
import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';
import '../../../shared/profile_button.dart';
import '../../../../global/globals.dart' as global;

class PublicProfileHead extends StatelessWidget {
  bool isFollowing;
  final UserModel userObj;
  final List<PostModel> postObj;
  final List<FollowerModel> followerObj;
  final List<FollowingModel> followingObj;
  PublicProfileHead({
    @required this.userObj,
    @required this.postObj,
    @required this.followerObj,
    @required this.followingObj,
    @required this.isFollowing,
  }) : assert(userObj != null &&
            postObj != null &&
            followerObj != null &&
            followingObj != null &&
            isFollowing != null);

  Future<void> _unFollow() async {
    await FollowerApi().removeThisFromFollowersList(
        AuthController.to.user.uid, userObj.userName);

    await FollowingApi().removeThemFromFollowingsList(
        AuthController.to.user.uid, userObj.userName);
    FollowerController.to.rebindStream();
    FollowingController.to.rebindStream();
  }

  Future<void> _follow() async {
    await FollowerApi()
        .addThisToFollowersList(AuthController.to.user.uid, userObj.userName);

    await FollowingApi()
        .addThemToFollowingsList(AuthController.to.user.uid, userObj.userName);
    FollowerController.to.rebindStream();
    FollowingController.to.rebindStream();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        // color: Colors.amber,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            /// First in three rows that make up the [publicProfileHead].
            Container(
              //  color: Colors.orange,
              padding: EdgeInsets.fromLTRB(5, 5, 5, 5),
              margin: EdgeInsets.fromLTRB(5, 5, 5, 5),
              child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    ///[PROFILE PICTURE] on public profile head

                    ClipOval(
                      child: Image.network(
                          userObj.profilePicUrl ?? global.defaultProfilePicUrl,
                          height: 90,
                          width: 90,
                          fit: BoxFit.cover),
                    ),

                    ///[POST BUTTON]
                    ProfileButton(
                      title: 'Posts',
                      count: postObj.length ?? 0,
                      onClick: () {},
                    ),

                    ///[FOLLOWER BUTTON]
                    ProfileButton(
                      title: 'Followers',
                      count: followerObj.length ?? 0,
                      onClick: () {},
                    ),

                    ///[FOLLOWING BUTTON]
                    ProfileButton(
                      title: 'Following',
                      count: followingObj.length ?? 0,
                      onClick: () {},
                    ),
                  ]),
            ),

            /// [Second] in three rows that make up the [PublicProfileHead].
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
                    child: Text(userObj.fullName ?? 'null',
                        style: TextStyle(
                            fontWeight: FontWeight.bold, color: Colors.white)),
                  ),

                  ///[BIO TEXT]

                  Text(userObj.bio ?? 'Going with the flow! 🤍',
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1,
                      style: TextStyle(color: Colors.white)),
                ],
              ),
            ),

            /// [Third] in three rows that make up the [PublicPersonalProfileHead].
            /// [FOLLOW / UNFOLLOW BUTTON]

            Container(
              child: MorphButton(
                text: isFollowing ? 'Following' : 'Follow',
                morphText: isFollowing ? 'Follow' : 'Following',
                morph: true,
                textStyle: TextStyle(fontSize: 15),
                width: double.infinity,
                height: 28,
                margin: EdgeInsets.symmetric(horizontal: 10, vertical: 16),
                onClick: isFollowing ? _unFollow : _follow,
                onMorphClick: isFollowing ? _follow : _unFollow,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:get/get.dart';
import 'package:getNav/models/data/follower_model.dart';
import 'package:getNav/models/data/following_model.dart';
import 'package:getNav/models/data/post_model.dart';
import 'package:getNav/models/data/user_model.dart';
import 'package:getNav/views/routes/public_profile_screen/widgets/public_profile_head.dart';
import 'package:getNav/views/shared/empty_list_indicator.dart';
import 'package:getNav/views/shared/build_post_grid.dart';
import 'package:getNav/controllers/user_controller.dart';
import 'package:getNav/controllers/post_controller.dart';
import 'package:getNav/controllers/follower_controller.dart';
import 'package:getNav/controllers/following_controller.dart';
import 'package:getNav/custom/no_glowing_overscroll_indicator.dart';
import 'package:getNav/views/shared/null_Indicator.dart';

//ignore:must_be_immutable
class PublicProfileScreen extends StatefulWidget {
  final UserModel userObj;
  final List<PostModel> postObj;
  final List<FollowerModel> followerObj;
  final List<FollowingModel> followingObj;

  PublicProfileScreen(
      {@required this.userObj,
      @required this.postObj,
      @required this.followerObj,
      @required this.followingObj})
      : assert(userObj != null &&
            postObj != null &&
            followerObj != null &&
            followingObj != null);
  @override
  _PublicProfileScreenState createState() => _PublicProfileScreenState();
}

class _PublicProfileScreenState extends State<PublicProfileScreen> {
  bool _setIsFollowing() {
    var following;
    for (following in FollowingController.to.followings) {
      if (following.followingId == widget.userObj.id) {
        return true;
      }
    }
    return false;
  }
  // List<PostModel> postList = PostController.to.personalPosts;
  // int postCount = PostController.to.personalPostsCount;

  @override
  Widget build(BuildContext context) {
    return (widget.userObj != null && widget.postObj != null)
        ? (widget.postObj.isEmpty != true)
            ? Scaffold(
                appBar: PreferredSize(
                  preferredSize: Size.fromHeight(48),
                  child: AppBar(
                    centerTitle: true,
                    elevation: 0,
                    backgroundColor: Colors.black,
                    title: Text(widget.userObj.userName ?? 'null'),

                    /// Remove Back button on endDrawer on Main Scaffold
                    // automaticallyImplyLeading: false,
                    // leading: Container(),

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
                        flexibleSpace: PublicProfileHead(
                            userObj: widget.userObj,
                            postObj: widget.postObj,
                            followerObj: widget.followerObj,
                            followingObj: widget.followingObj,
                            isFollowing: _setIsFollowing(),
                            ),
                        expandedHeight: 210,
                        toolbarHeight: 210,
                      ),

                      ///[PUBLIC POST GRID]

                      buildPostGrid(
                        postList: widget.postObj,
                        postCount: widget.postObj.length,
                        parent: 'public_profile_screen',
                        userObj: widget.userObj,
                      ),
                    ],
                  ),
                ),
              )
            : NullIndicator()
        : EmptyListIndicator('');
  }
}

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:getNav/api/follower_api.dart';
import 'package:getNav/api/following_api.dart';
import 'package:getNav/api/post_api.dart';
import 'package:getNav/controllers/auth_controller.dart';
import 'package:getNav/controllers/follower_controller.dart';
import 'package:getNav/controllers/following_controller.dart';
import 'package:getNav/custom/morph_button.dart';
import 'package:getNav/global/globals.dart' as global;
import 'package:getNav/models/data/user_model.dart';
import 'package:getNav/api/user_api.dart';
import 'package:getNav/custom/no_glowing_overscroll_indicator.dart';
import 'package:getNav/views/routes/public_profile_screen/public_profile_screen.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:getNav/views/shared/null_Indicator.dart';
import 'package:getNav/views/shared/empty_list_indicator.dart';

//ignore: must_be_immutable
class FollowingScreen extends StatefulWidget {
  List<UserModel> followingUsers = List<UserModel>();
  @override
  _FollowingScreenState createState() => _FollowingScreenState();
}

class _FollowingScreenState extends State<FollowingScreen> {
  RefreshController _refreshController =
      RefreshController(initialRefresh: false);

  // void _onLoading() async {
  //   if (mounted) setState(() {});
  //   _refreshController.loadComplete();
  // }

  @override
  void initState() {
    _buildFollowingList();

    super.initState();
  }

  Future<void> _buildFollowingList() async {
    var followingUser;
    widget.followingUsers = [];
    for (int i = 0; i < FollowingController.to.followingCount; i++) {
      followingUser = await UserApi()
          .getUserFromUid(FollowingController.to.followings[i].followingId);
      setState(() {
        widget.followingUsers.add(followingUser);
      });
    }
    _refreshController.refreshCompleted();
  }

  @override
  Widget build(BuildContext context) {
    return (widget.followingUsers != null)
        ? (widget.followingUsers?.isEmpty != true)
            ? NoGlowingOverscrollIndicator(
                child: SmartRefresher(
                  header: ClassicHeader(
                    refreshingIcon: Center(
                      child: Column(
                        children: [
                          SizedBox(
                            height: 16.0,
                          ),
                          SizedBox(
                            width: 30.0,
                            height: 30.0,
                            child: CircularProgressIndicator(
                                strokeWidth: 2.0,
                                backgroundColor: Colors.grey,
                                valueColor: AlwaysStoppedAnimation<Color>(
                                    Colors.grey[350])),
                          ),
                        ],
                      ),
                    ),
                    failedIcon:
                        const Icon(Icons.error, color: Colors.transparent),
                    completeIcon:
                        const Icon(Icons.done, color: Colors.transparent),
                    idleIcon: const Icon(Icons.arrow_downward,
                        color: Colors.transparent),
                    releaseIcon:
                        const Icon(Icons.refresh, color: Colors.transparent),
                    completeText: '',
                    refreshingText: '',
                    releaseText: '',
                    idleText: '',
                  ),

                  controller: _refreshController,
                  onRefresh: _buildFollowingList,
                  // onLoading: _onLoading,
                  child: ListView.builder(
                    itemCount: widget.followingUsers.length,
                    itemBuilder: (context, index) {
                      return Padding(
                        padding: const EdgeInsets.all(4.0),
                        child: ListTile(
                          leading: ClipOval(
                              child: Image.network(
                            widget.followingUsers[index].profilePicUrl ??
                                global.defaultProfilePicUrl,
                            width: 50,
                            height: 50,
                            fit: BoxFit.cover,
                          )),
                          title: Text(
                              widget.followingUsers[index].userName ??
                                  'Username',
                              style: TextStyle(color: Colors.white)),
                          subtitle: Text(
                              widget.followingUsers[index].fullName ??
                                  'fullName',
                              style: TextStyle(color: Colors.white)),
                          trailing: MorphButton(
                            text: 'Following',
                            morphText: 'Follow',
                            morph: true,
                            width: 100,
                            height: 28,
                            onClick: () async {
                              await FollowerApi().removeThisFromFollowersList(
                                  AuthController.to.user.uid,
                                  widget.followingUsers[index].userName);

                              await FollowingApi().removeThemFromFollowingsList(
                                  AuthController.to.user.uid,
                                  widget.followingUsers[index].userName);
                              FollowerController.to.rebindStream();
                              FollowingController.to.rebindStream();
                            },
                            onMorphClick: () async {
                              await FollowerApi().addThisToFollowersList(
                                  AuthController.to.user.uid,
                                  widget.followingUsers[index].userName);

                              await FollowingApi().addThemToFollowingsList(
                                  AuthController.to.user.uid,
                                  widget.followingUsers[index].userName);
                              FollowerController.to.rebindStream();
                              FollowingController.to.rebindStream();
                            },
                          ),
                          onTap: () async {
                            var uid = await UserApi().getUidFromUsername(
                                widget.followingUsers[index].userName);
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
              )
            : EmptyListIndicator("Follow some people to see them here !")
        : NullIndicator();
  }
}

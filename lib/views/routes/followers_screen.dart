import 'package:flutter/material.dart';
import 'package:getNav/api/follower_api.dart';
import 'package:getNav/api/following_api.dart';
import 'package:getNav/controllers/auth_controller.dart';
import 'package:getNav/controllers/follower_controller.dart';
import 'package:getNav/controllers/following_controller.dart';
import 'package:getNav/custom/morph_button.dart';
import 'package:getNav/global/globals.dart' as global;
import 'package:getNav/models/data/user_model.dart';
import 'package:getNav/api/user_api.dart';
import 'package:getNav/custom/no_glowing_overscroll_indicator.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:getNav/views/shared/null_Indicator.dart';
import 'package:getNav/views/shared/empty_list_indicator.dart';

//ignore: must_be_immutable
class FollowersScreen extends StatefulWidget {
  List<UserModel> followerUsers = List<UserModel>();

  @override
  _FollowersScreenState createState() => _FollowersScreenState();
}

class _FollowersScreenState extends State<FollowersScreen> {
  RefreshController _refreshController =
      RefreshController(initialRefresh: false);

  void _removeFollower() async {}

  // void _onLoading() async {
  //   if (mounted) setState(() {});
  //   _refreshController.loadComplete();
  // }

  @override
  void initState() {
    _buildFollowerList();

    super.initState();
  }

  Future<void> _buildFollowerList() async {
    var followingUser;
    widget.followerUsers = [];
    for (int i = 0; i < FollowerController.to.followerCount; i++) {
      followingUser = await UserApi()
          .getUserFromUid(FollowerController.to.followers[i].followerId);
      setState(() {
        widget.followerUsers.add(followingUser);
      });
    }
    _refreshController.refreshCompleted();
  }

  @override
  Widget build(BuildContext context) {
    return (widget.followerUsers != null)
        ? (widget.followerUsers?.isEmpty != true)
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
                    // refreshStyle: RefreshStyle.Behind,
                    // outerBuilder: (child) {
                    //   return Container(
                    //     color: Colors.grey[900],
                    //     child: child,
                    //     height: 100.0,
                    //   );
                    // },
                  ),

                  controller: _refreshController,
                  onRefresh: _buildFollowerList,
                  // onLoading: _onLoading,
                  child: ListView.builder(
                    itemCount: widget.followerUsers.length,
                    itemBuilder: (context, index) {
                      return Padding(
                        padding: const EdgeInsets.all(4.0),
                        child: ListTile(
                            leading: ClipOval(
                                child: Image.network(
                                    widget.followerUsers[index].profilePicUrl ??
                                        global.defaultProfilePicUrl)),
                            title: Text(
                                widget.followerUsers[index].userName ??
                                    'Username',
                                style: TextStyle(color: Colors.white)),
                            subtitle: Text(
                                widget.followerUsers[index].fullName ??
                                    'fullName',
                                style: TextStyle(color: Colors.white)),
                            trailing: MorphButton(
                              text: 'Remove',
                              height: 28,
                              width: 100,
                              onClick: () async {
                                print(widget.followerUsers[index].userName);
                                await FollowerApi().removeThemFromFollowersList(
                                    AuthController.to.user.uid,
                                    widget.followerUsers[index].userName
                                        .trim());

                                await FollowingApi()
                                    .removeThisFromFollowingsList(
                                        AuthController.to.user.uid,
                                        widget.followerUsers[index].userName
                                            .trim());
                                _buildFollowerList();
                              },
                            ),
                            // RemoveButton(
                            //   onClick: _removeFollower),
                            onTap: () {}),
                      );
                    },
                  ),
                ),
              )
            : EmptyListIndicator(
                "You don't have any followers right now.\n We hope you inspire many \n")
        : NullIndicator();
  }
}

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:getNav/api/user_api.dart';
import 'package:getNav/controllers/follower_controller.dart';
import 'package:getNav/controllers/following_controller.dart';
import 'package:getNav/controllers/post_controller.dart';
import 'package:getNav/controllers/user_controller.dart';
import 'package:getNav/global/globals.dart' as global;
import 'package:getNav/models/data/user_model.dart';
import 'package:getNav/views/routes/dm_screen.dart';
import 'package:getNav/views/shared/post.dart';
import 'package:getNav/views/routes/ar_screen.dart';
import 'package:getNav/views/shared/null_Indicator.dart';
import 'package:getNav/views/shared/empty_list_indicator.dart';
import 'package:getNav/custom/no_glowing_overscroll_indicator.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

//ignore: must_be_immutable
class HomeScreen extends StatefulWidget {
  List<UserModel> followingUsers = List<UserModel>();

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  RefreshController _refreshController =
      RefreshController(initialRefresh: true);
  @override
  void initState() {
    _buildUserList();

    super.initState();
  }

  Future<void> _buildUserList() async {
    print("start");

    var followingUser;
    widget.followingUsers = [];

    for (int i = 0; i < PostController.to.followingsPostsCount; i++) {
      followingUser = await UserApi()
          .getUserFromUid(PostController.to.followingsPosts[i].userId);

      setState(() {
        widget.followingUsers.add(followingUser);
      });
    }
    _refreshController.refreshCompleted();
    print("WTF followingsPostsCount ${PostController.to.followingsPostsCount}");
    print("WTF followingUsers ${widget.followingUsers}");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        leadingWidth: 120,
        leading: RawMaterialButton(
          onPressed: () {
            Get.to(ArScreen());
          },
          child: Container(
            // color: Colors.red,
            margin: EdgeInsets.symmetric(vertical: 0, horizontal: 8),
            // child:
            child: Image(
              image: AssetImage('assets/images/flow_w.png'),
            ),
          ),
        ),
        actions: <Widget>[
          Container(
            width: 56,
            child: RawMaterialButton(
                child: Icon(
                  Icons.near_me,
                  color: Colors.white,
                  size: 32,
                ),
                onPressed: () async {
                  // _buildUserList();
                     Get.to(DmScreen());
                }),
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
      body: Obx(
        () => (UserController.to != null &&
                FollowerController.to != null &&
                FollowingController.to != null &&
                PostController.to != null &&
                PostController.to.followingsPosts != null)
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
                onRefresh: _buildUserList,
                child: (PostController.to.followingsPostsCount == 0)
                    ? EmptyListIndicator(
                        'FOLLOW PEOPLE TO SEE THEIR POSTS HERE')
                    : ListView.builder(
                        scrollDirection: Axis.vertical,
                        itemCount: widget.followingUsers.length,
                        itemBuilder: (BuildContext context, int itemIndex) {
                          return Post(
                            profilePicUrl: widget.followingUsers.isNotEmpty
                                ? widget.followingUsers[itemIndex].profilePicUrl
                                : global.defaultProfilePicUrl,
                            onClick: () {
                              print('FromHomeScreen');
                            },
                            postObj:
                                PostController.to.followingsPosts[itemIndex],
                          );
                        }),
              ))
            : NullIndicator(),
      ),
    );
  }
}

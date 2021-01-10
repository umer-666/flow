import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:getNav/models/data/user_model.dart';
import 'package:getNav/controllers/post_controller.dart';
import 'package:getNav/custom/no_glowing_overscroll_indicator.dart';
import 'package:getNav/views/shared/empty_list_indicator.dart';
import 'package:getNav/views/shared/null_Indicator.dart';
import 'package:getNav/views/shared/post.dart';
import 'package:getNav/api/user_api.dart';
import 'package:getNav/global/globals.dart' as global;

//ignore:must_be_immutable
class ExplorePostPageView extends StatefulWidget {
  List<UserModel> exploreUsers = List<UserModel>();

  ExplorePostPageView({
    @required this.postNumber,
  }) : assert(postNumber != null && postNumber >= 0);

  int postNumber;
  _goToProfile() {
    /* TODO */
  }

  @override
  _ExplorePostPageViewState createState() => _ExplorePostPageViewState();
}

class _ExplorePostPageViewState extends State<ExplorePostPageView> {
  @override
  void initState() {
    _buildUserList();

    super.initState();
  }

  Future<void> _buildUserList() async {
    var exploreUser;
    widget.exploreUsers = [];
    for (int i = 0; i < PostController.to.explorePostsCount; i++) {
      exploreUser = await UserApi()
          .getUserFromUid(PostController.to.explorePosts[i].userId);
      setState(() {
        widget.exploreUsers.add(exploreUser);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // extendBodyBehindAppBar: true,
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(48),
        child: AppBar(
          elevation: 0,
          backgroundColor: Colors.black,
          leading: RawMaterialButton(
            onPressed: () {
              widget._goToProfile;
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
                    child: (widget.exploreUsers.length ==
                            PostController.to.explorePostsCount)
                        ? PageView.builder(
                            pageSnapping: true,
                            scrollDirection: Axis.vertical,
                            controller: PageController(
                              initialPage: widget.postNumber,
                              // keepPage: false,
                              viewportFraction: 0.95,
                            ),
                            itemCount: widget.exploreUsers.length,
                            itemBuilder: (BuildContext context, int itemIndex) {
                              return Post(
                                profilePicUrl: widget.exploreUsers.isNotEmpty
                                    ? widget
                                        .exploreUsers[itemIndex].profilePicUrl
                                    : global.defaultProfilePicUrl,
                                onClick: () {
                                  print('from explore screen');
                                },
                                postObj:
                                    PostController.to.explorePosts[itemIndex],
                              );
                            },
                          )

                        ///Used as a [PLACEHOLDER] for [_buildUserList]
                        : NullIndicator(),
                  ),
                )
              : NullIndicator()
          : EmptyListIndicator(''),
    );
  }
}

import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:get/get.dart';
import 'package:getNav/custom/no_glowing_overscroll_indicator.dart';
import 'package:getNav/views/routes/explore_screen/search_screen.dart';
import 'package:getNav/views/routes/explore_screen/widgets/search_bar.dart';
import 'package:getNav/views/routes/explore_screen/widgets/tag_chips_list.dart';
import 'package:getNav/controllers/post_controller.dart';
import 'package:flutter/rendering.dart';
import 'package:getNav/models/data/post_model.dart';
import 'package:getNav/views/shared/build_post_grid.dart';
import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';

//ignore: must_be_immutable
class ExploreScreen extends StatefulWidget {
  @override
  createState() => ExploreScreenState();
}

class ExploreScreenState extends State<ExploreScreen>
    with WidgetsBindingObserver {
  final FocusNode searchBarFocusNode = FocusNode();
  List<PostModel> postList = PostController.to.explorePosts;
  int postCount = PostController.to.explorePostsCount;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void didChangeMetrics() {
    super.didChangeMetrics();
    final value = WidgetsBinding.instance.window.viewInsets.bottom;
    if (value == 0) {
      searchBarFocusNode.unfocus();
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    searchBarFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    //SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.dark.copyWith(statusBarColor: Colors.black));
    // FocusScope.of(context).unfocus();
    return Scaffold(
      body: GestureDetector(
        onTapDown: (details) => FocusScope.of(context).unfocus(),
        onTap: () => FocusScope.of(context).unfocus(),
        onTapCancel: () => FocusScope.of(context).unfocus(),
        child: SafeArea(
          child: NoGlowingOverscrollIndicator(
            child: CustomScrollView(
              // physics: BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
              slivers: <Widget>[
                SliverAppBar(
                  flexibleSpace: GestureDetector(
                    onTap: () => pushNewScreen(context,
                        screen: SearchScreen(
                            searchBarFocusNode: searchBarFocusNode),
                        withNavBar: true,
                        pageTransitionAnimation:
                            PageTransitionAnimation.cupertino),
                    child: Container(
                      color: Colors.black,
                      child: Container(
                        margin:
                            EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                        child: Container(
                          width: Get.width,
                          height: Get.height,
                          child: Padding(
                            padding: const EdgeInsets.fromLTRB(12,12,0,0),
                            child: Text(
                              'Search',
                              style: TextStyle(fontSize: 16, color: Colors.white),
                            ),
                          ),
                          decoration: BoxDecoration(
                            color: Colors.grey[800],
                            borderRadius: BorderRadius.all(Radius.circular(8)),
                          ),
                        ),
                      ),
                    ),
                  ),
                  pinned: false,
                  floating: true,
                  elevation: 0.0,
                ),
                SliverPersistentHeader(
                  pinned: true,
                  delegate: _SliverAppBarDelegate(
                    child: PreferredSize(
                      preferredSize: Size.fromHeight(50.0),
                      child: Container(
                        color: Colors.black,
                        child: Padding(
                          /// DISTANCE FOROM THE THE SIDES ON THE SLIVERHEADER
                          padding: const EdgeInsets.symmetric(
                              vertical: 0, horizontal: 10),

                          ///[TAG CHIPS LIST]
                          child: TagChipList(),
                        ),
                      ),
                    ),
                  ),
                ),

                ///[EXPLORE POST GRID]
                buildPostGrid(
                    postList: postList,
                    postCount: postCount,
                    parent: 'explore_screen'),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _SliverAppBarDelegate extends SliverPersistentHeaderDelegate {
  final PreferredSize child;

  _SliverAppBarDelegate({this.child});

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    return child;
  }

  @override
  double get maxExtent => child.preferredSize.height;

  @override
  double get minExtent => child.preferredSize.height;

  @override
  bool shouldRebuild(SliverPersistentHeaderDelegate oldDelegate) {
    return false;
  }
}

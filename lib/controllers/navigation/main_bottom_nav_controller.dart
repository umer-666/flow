import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:getNav/api/user_api.dart';
import 'package:getNav/views/routes/activity_screen.dart';
import 'package:getNav/views/routes/explore_screen/explore_screen.dart';
import 'package:getNav/views/routes/picker_screen.dart';
import 'package:getNav/views/routes/personal_profile_screen/personal_profile_screen.dart';
import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';
import 'package:get/get.dart';
import 'package:getNav/controllers/user_controller.dart';
import 'package:getNav/controllers/follower_controller.dart';
import 'package:getNav/controllers/following_controller.dart';
import 'package:getNav/controllers/post_controller.dart';
import 'package:getNav/controllers/auth_controller.dart';
import '../../models/ui/bot_nav_items.dart';
import 'home_pageview_controller.dart';

//ignore: must_be_immutable
class MainBottomNav extends StatefulWidget {
  // const MyHomePage({Key key}) : super(key: key);

  int routeIndex;
  MainBottomNav({this.routeIndex = 0});

  @override
  _MainBottomNavState createState() => _MainBottomNavState();
}

class _MainBottomNavState extends State<MainBottomNav> {
  PersistentTabController _controller;

  List<Widget> _buildScreens() {
    return [
      HomePageNav(),
      ExploreScreen(),
      PickerScreen(),
      ActivityScreen(),
      PersonalProfileScreen()
    ];
  }

  List<PersistentBottomNavBarItem> _navBarsItems() {
    return bottomNavItems;
  }

  @override
  void initState() {
    setUser();

    try {
      if (FollowerController.to == null) {
        print("FollowerController not initialized");
      } else {
        Get.find<FollowerController>().rebindStream();
      }
    } catch (e) {
      Get.put<FollowerController>(FollowerController(), permanent: true);
    }

    try {
      if (FollowingController.to == null) {
        print("FollowingController not initialized");
      } else {
        Get.find<FollowingController>().rebindStream();
      }
    } catch (e) {
      Get.put<FollowingController>(FollowingController(), permanent: true);
    }

    try {
      if (PostController.to == null) {
        print("PostController not initialized");
      } else {
        Get.find<PostController>().rebindStream();
      }
    } catch (e) {
      Get.lazyPut<PostController>(() => PostController(), fenix: true);
    }

    super.initState();
  }

  void setUser() async {
    Get.find<UserController>().user =
        await UserApi().getUserFromUid(Get.find<AuthController>().user.uid);
    // String username = Get.find<UserController>().user.userName;
  }

  @override
  Widget build(BuildContext context) {
    _controller = PersistentTabController(initialIndex: widget.routeIndex ?? 0);
    // print("GET ARGUMENTS ${Get.arguments}");
    return PersistentTabView(
      this.context,
      padding: NavBarPadding.symmetric(vertical: null, horizontal: 0),
      controller: _controller,
      screens: _buildScreens(),
      items: _navBarsItems(),
      confineInSafeArea: true,
      backgroundColor: Colors.black,
      // iconSize: 28,
      navBarHeight: 58,
      handleAndroidBackButtonPress: true,
      // This needs to be true if you want to move up the screen when keyboard appears.
      resizeToAvoidBottomInset: true,
      stateManagement: true,
      // Recommended to set 'resizeToAvoidBottomInset' as true while using this argument.
      hideNavigationBarWhenKeyboardShows: true,
      decoration: NavBarDecoration(
        colorBehindNavBar: Colors.black,
      ),
      popAllScreensOnTapOfSelectedTab: true,
      popActionScreens: PopActionScreensType.all,
      itemAnimationProperties: ItemAnimationProperties(
        // Navigation Bar's items animation properties.
        duration: Duration(milliseconds: 200),
        curve: Curves.fastLinearToSlowEaseIn,
      ),
      screenTransitionAnimation: ScreenTransitionAnimation(
        // Screen transition animation on change of selected tab.
        animateTabTransition: true,
        curve: Curves.ease,
        duration: Duration(milliseconds: 200),
      ),
      navBarStyle:
          NavBarStyle.style7, // Choose the nav bar style with this property.
    );
  }
}

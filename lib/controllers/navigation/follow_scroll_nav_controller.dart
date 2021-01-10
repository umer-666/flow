import 'package:flutter/material.dart';
import 'package:getNav/controllers/user_controller.dart';
import 'package:getNav/views/routes/followers_screen.dart';
import 'package:getNav/views/routes/following_screen.dart';

class FollowNav extends StatelessWidget {
  final int initialPage;
  final List followList;

  FollowNav({@required this.initialPage, this.followList});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      initialIndex: initialPage,
      length: 2,
      child: Scaffold(
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(100),
          child: AppBar(
            backgroundColor: Colors.black,
            leading: RawMaterialButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Icon(
                Icons.arrow_back,
                size: 28,
              ),
            ),
            title: Text(UserController.to.user.userName ?? "username"),
            bottom: TabBar(tabs: [
              Tab(
                  child:
                      Text('followers', style: TextStyle(color: Colors.white))),
              Tab(
                  child:
                      Text('following', style: TextStyle(color: Colors.white))),
            ]),
          ),
        ),
        body: TabBarView(
            physics:
                BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
            children: [
              FollowersScreen(),
              FollowingScreen(),
            ]),
      ),
    );
  }
}

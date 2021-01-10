import 'dart:io';

import 'package:flutter/material.dart';
import 'package:getNav/custom/no_glowing_overscroll_indicator.dart';
import 'package:getNav/views/routes/ar_screen.dart';
import 'package:getNav/views/routes/dm_screen.dart';
import 'package:getNav/views/routes/home_screen.dart';

class HomePageNav extends StatefulWidget {
  @override
  _HomePageNavState createState() => _HomePageNavState();
}

class _HomePageNavState extends State<HomePageNav> {
  PageController _pageController = PageController(
    initialPage: 1,
  );
  @override
  Widget build(BuildContext context) {
    return NoGlowingOverscrollIndicator(
      child: PageView.builder(
          controller: _pageController,
          itemCount: 3,
          // ignore: missing_return
          itemBuilder: (BuildContext context, int pageIndex) {
            if (pageIndex == 0) {
              return DmScreen();
            } else if (pageIndex == 1) {
              return HomeScreen();
            } else if (pageIndex == 2) {
              return DmScreen();
            }
          }
          // children: [
          //   Get.to(ArScreen()),
          //   HomeScreen(),
          //   DmScreen(),
          // ],
          ),
    );
  }
}

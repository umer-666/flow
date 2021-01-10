import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';
import 'package:flutter/rendering.dart';
import 'dart:ui';

final double titleFontSize = 15;
final Color activeColor = Colors.white.withOpacity(0.2);
final Color inactiveColor = Colors.grey[200];
final double iconSize = 28;
final Color white = Colors.white;

final bottomNavItems = [
  PersistentBottomNavBarItem(
    icon: Icon(
      Icons.home,
      color: white,
    ),
    title: ('Home'),
    textStyle: TextStyle(fontSize: 15),
    activeColor: activeColor,
    inactiveColor: inactiveColor,
    activeColorAlternate: white,

    // titleFontSize: titleFontSize,
    iconSize: iconSize,
  ),
  PersistentBottomNavBarItem(
    icon: Icon(
      Icons.search,
      color: white,
    ),
    title: ('Explore'),
    activeColor: activeColor,
    inactiveColor: inactiveColor,
    activeColorAlternate: white,
    textStyle: TextStyle(fontSize: 15),
    iconSize: iconSize,
    // titleFontSize: titleFontSize,
  ),
  PersistentBottomNavBarItem(
    icon: Icon(
      Icons.sports_volleyball_rounded,
      color: white,
    ),
    title: ('Flow'),
    activeColor: activeColor,
    inactiveColor: inactiveColor,
    activeColorAlternate: white,
    textStyle: TextStyle(fontSize: 15),
    iconSize: iconSize,
    // titleFontSize: titleFontSize,
  ),
  PersistentBottomNavBarItem(
    icon: Icon(
      Icons.favorite_border,
      color: white,
    ),
    title: ('Activity'),
    activeColor: activeColor,
    inactiveColor: inactiveColor,
    activeColorAlternate: white,
    textStyle: TextStyle(fontSize: 15),
    iconSize: iconSize,
    // titleFontSize: titleFontSize,
  ),
  PersistentBottomNavBarItem(
    icon: Icon(
      Icons.supervised_user_circle,
      color: Colors.pink[200],
    ),
    title: ('Profile'),
    // titleStyle: TextStyle(fontSize: 19, color: Colors.redAccent[400]),
    activeColor: activeColor,
    inactiveColor: inactiveColor,
    activeColorAlternate: white,
    textStyle: TextStyle(fontSize: 15),
    iconSize: iconSize,
    // titleFontSize: titleFontSize,
  ),
];

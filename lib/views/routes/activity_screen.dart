import 'package:flutter/material.dart';
import 'dart:ui';
import 'package:flutter/rendering.dart';
import 'package:get/get.dart';
import 'package:getNav/views/routes/public_profile_screen/widgets/public_profile_head.dart';
import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';
import 'package:getNav/controllers/user_controller.dart';
import 'package:getNav/controllers/post_controller.dart';
import 'package:getNav/controllers/follower_controller.dart';
import 'package:getNav/controllers/following_controller.dart';
import 'package:getNav/custom/no_glowing_overscroll_indicator.dart';
import 'package:getNav/views/routes/personal_profile_screen/widgets/personal_post_pageview.dart';
import 'package:getNav/views/shared/null_Indicator.dart';
import 'package:flutter/material.dart';
import 'package:grouped_list/grouped_list.dart';

//ignore:must_be_immutable
class ActivityScreen extends StatelessWidget {
  List _elements = [
    {'name': 'John', 'group': 'Earlier'},
    {'name': 'Will', 'group': 'This Week'},
    {'name': 'Beth', 'group': 'Earlier'},
    {'name': 'Miranda', 'group': 'This Week'},
    {'name': 'Mike', 'group': 'Today'},
    {'name': 'Danny', 'group': 'Today'},
    {'name': 'Pen', 'group': 'Today'},
    {'name': 'Pen', 'group': 'This Week'},
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(48),
        child: AppBar(
          centerTitle: true,
          elevation: 0,
          backgroundColor: Colors.black,
          title: Text("Activity"),
          leading: Container(),

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
      body: GroupedListView<dynamic, String>(
        groupBy: (element) => element['group'],
        elements: _elements,
        // sort: true,
        reverse: true,
        groupSeparatorBuilder: (String value) => Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
            value,
            style: TextStyle(
                fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
          ),
        ),
        itemBuilder: (c, element) {
          return Card(
            margin: EdgeInsets.symmetric(horizontal: 10.0, vertical: 6.0),
            child: Container(
              child: ListTile(
                leading: Icon(Icons.account_circle),
                title: Text(element['name']),
              ),
            ),
          );
        },
      ),
    );
  }
}

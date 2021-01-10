import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:getNav/controllers/auth_controller.dart';
import 'package:getNav/custom/no_glowing_overscroll_indicator.dart';
import 'package:getNav/views/routes/settings_screen.dart';
import 'package:getNav/global/constants/about_app.dart' as about;

class ProfileDrawer extends GetWidget<AuthController> {
  _launchURL() async {
  const url = 'https://github.com/duke-666';
  if (await canLaunch(url)) {
    await launch(url);
  } else {
    throw 'Could not launch $url';
  }
}
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Container(
        color: Colors.black,
        child: NoGlowingOverscrollIndicator(
          child: ListView(
            padding: EdgeInsets.zero,
            children: <Widget>[
              // Material(
              //   color: Colors.black,
              //   child: InkWell(
              //     child: DrawerHeader(
              //       decoration: BoxDecoration(
              //           //color: Colors.pink,
              //           ),
              //   child: Container(),
              //     ),
              //     onTap: () {},
              //   ),
              // ),
              ListTile(
                leading: Icon(Icons.settings, color: Colors.transparent),
                title: Text('',
                    style: TextStyle(
                      color: Colors.white,
                    )),
                onTap: () {},
              ),
              Material(
                color: Colors.transparent,
                child: InkWell(
                  child: ListTile(
                    leading: Icon(Icons.settings, color: Colors.white),
                    title: Text('Settings',
                        style: TextStyle(
                          color: Colors.white,
                        )),
                    onTap: () {
                      Get.to(SettingsScreen(),
                          transition: Transition.cupertino);
                    },
                  ),
                ),
              ),
              Material(
                color: Colors.transparent,
                child: InkWell(
                  child: ListTile(
                    onTap: () {
                      showAboutDialog(
                          context: context,
                          applicationName: about.applicationName,
                          applicationIcon: Image(
                            image: AssetImage(about.applicationLogo),
                            height: about.applicationLogoDimension,
                            width: about.applicationLogoDimension,
                          ),
                          applicationVersion: about.applicationVersion,
                          children: [
                            Text(about.applicationRights),
                          ]);
                    },
                    leading: Icon(Icons.info, color: Colors.white),
                    title: Text('About',
                        style: TextStyle(
                          color: Colors.white,
                        )),
                  ),
                  onTap: () {},
                ),
              ),
              Material(
                color: Colors.transparent,
                child: InkWell(
                  child: ListTile(
                    leading: Padding(
                      padding: const EdgeInsets.fromLTRB(4.0, 0, 0, 0),
                      child: Image.asset(
                          "assets/images/GitHub-Mark-Light-120px-plus.png",
                          width: Get.width / 19),
                    ),
                    title: Text('Flow GitHub',
                        style: TextStyle(
                          color: Colors.white,
                        )),
                    onTap: _launchURL,
                  ),
                ),
              ),
              PreferredSize(
                child: Container(
                  color: Colors.grey[600],
                  height: 0.4,
                ),
                preferredSize: Size.fromHeight(0.4),
              ),
              Material(
                color: Colors.transparent,
                child: InkWell(
                  child: ListTile(
                    leading: Icon(Icons.logout, color: Colors.redAccent[400]),
                    title: Text('Logout',
                        style: TextStyle(
                          color: Colors.redAccent[400],
                        )),
                    onTap: () async {
                      controller.signOut();
                    },
                  ),
                ),
              ),
              PreferredSize(
                child: Container(
                  color: Colors.grey[600],
                  height: 0.4,
                ),
                preferredSize: Size.fromHeight(0.4),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

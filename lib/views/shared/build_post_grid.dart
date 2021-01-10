import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:get/get.dart';
import 'package:getNav/models/data/post_model.dart';
import 'package:getNav/models/data/user_model.dart';
import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';
import 'package:getNav/views/routes/personal_profile_screen/widgets/personal_post_pageview.dart';
import 'package:getNav/views/routes/public_profile_screen/widgets/public_post_pageview.dart';
import 'package:getNav/views/routes/explore_screen/widgets/explore_post_pageview.dart';
import 'package:getNav/views/shared/null_Indicator.dart';

///[OVERLAY CONSTANTS]
OverlayEntry _postOverlay;
final double _sigmaX = 10; // from 0-10
final double _sigmaY = 10; // from 0-10
// opacity for color overlay on Long Press
// double _opacity = 0.2; // from 0-1.0

///[DISPLAYS THE OVERLAY] widget retured from the [createOverlay function]
///Size of the overlay is controlled here, [Positioned widget] is used
///as other sizing methods appear to have no effect.
_displayOverlay(String postUrl) {
  return OverlayEntry(builder: (context) => _createOverlay(postUrl));
}

///[CREATES THE OVERLAY WIDGET TO BE DISPLAYED]
///Sizing this widget has no effect, refer to the [displayOverlay function]
Widget _createOverlay(String postUrl) {
  return BackdropFilter(
    filter: ImageFilter.blur(sigmaX: _sigmaX, sigmaY: _sigmaY),
    // child: Image.network(postUrl, fit: BoxFit.cover,width: 200, height: 400),

    // child: ClipRRect(
    //     borderRadius: BorderRadius.circular(8.0),
    //     child: Image.network(postUrl,
    //         fit: BoxFit.cover, width: 200, height: 400)),
    child: Stack(
      ///[height of bottom nav bar is 85px]
      children: <Widget>[
        // Positioned(
        //   top: Get.height / 7 + 58,
        //   bottom: Get.height / 7,
        //   right: 8,
        //   left: 8,
        //   child: Container(
        //     decoration: BoxDecoration(
        //       color: Colors.grey[800],
        //       border: Border.all(color: Colors.grey[800], width: 8.0),
        //       borderRadius: BorderRadius.all(Radius.circular(16.0)),
        //     ),
        //   ),
        // ),
        Positioned(
          ///[32px] is to [added] increase the [edgeinsets] as to make the image appear smaller [vertically] than the [container]
          top: Get.height / 6 + 58,
          bottom: Get.height / 6,
          right: 8,
          left: 8,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(16.0),
            child: Image.network(postUrl,
                fit: BoxFit.cover, width: Get.width, height: Get.height),
          ),
        ),
      ],
    ),
  );
}

SliverGrid buildPostGrid(
    {@required List<PostModel> postList,
    @required int postCount,
    @required String parent,
    UserModel userObj}) {
  return SliverGrid(
    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3, crossAxisSpacing: 1, mainAxisSpacing: 1),
    delegate: SliverChildBuilderDelegate(
      (BuildContext context, int index) {
        return Stack(
          children: <Widget>[
            Positioned.fill(
              child: Material(color: Colors.white.withOpacity(0.15)),
            ),
            GestureDetector(
              onLongPress: () {
                _postOverlay = _displayOverlay(postList[index].postUrl);
                Overlay.of(context).insert(_postOverlay);
              },
              onLongPressEnd: (details) => _postOverlay?.remove(),

              ///[TOUCHABLE OPACITY] without image fade in
              child: Material(
                color: Colors.transparent,
                child: Ink.image(
                  image: NetworkImage(postList[index].thumbUrl),
                  // image: NetworkImage(images[index].thumbUrl),
                  // postsList.value[0].thumbUrl
                  fit: BoxFit.cover,
                  child: InkWell(
                    splashColor: Colors.transparent,
                    highlightColor: Colors.black54,
                    splashFactory: InkSplash.splashFactory,
                    onTap: () {
                      pushNewScreen(context,
                          screen: (parent == 'personal_profile_screen')
                              ? PersonalPostPageView(postNumber: index)
                              : (parent == 'explore_screen')
                                  ? ExplorePostPageView(postNumber: index)
                                  : (parent == 'public_profile_screen')
                                      ? PublicPostPageView(postNumber: index, postList: postList,userObj: userObj )
                                      : NullIndicator(),
                          withNavBar: true,
                          pageTransitionAnimation:
                              PageTransitionAnimation.cupertino);
                    },
                  ),
                ),
              ),
            ),
          ],
        );
      },
      childCount: postCount,
    ),
  );
}

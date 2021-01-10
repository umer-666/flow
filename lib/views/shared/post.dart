import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:getNav/controllers/auth_controller.dart';
import 'package:getNav/utils/timestamp_converter.dart';
import 'package:getNav/controllers/user_controller.dart';
import 'package:getNav/api/like_api.dart';
import 'package:photo_view/photo_view.dart';
import 'package:like_button/like_button.dart';
import 'package:get/get.dart';
import '../../global/globals.dart' as global;
import 'package:getNav/models/data/post_model.dart';
import 'package:getNav/models/data/like_model.dart';
import 'package:getNav/views/routes/comments_screen.dart';

// String tallImage =
//     'https://external-content.duckduckgo.com/iu/?u=https%3A%2F%2Ftse4.mm.bing.net%2Fth%3Fid%3DOIP.d78kBM6PWJQ01c1YKjumwAHaJ4%26pid%3DApi&f=1';
// String squareImage =
//     'https://edm.com/.image/ar_1:1%2Cc_fill%2Ccs_srgb%2Cfl_progressive%2Cq_auto:good%2Cw_1200/MTcyMTA5MTA4NDUzODQ0MjI3/charlotte-de-witte.jpg';
// String wideImage =
//     'https://images1.miaminewtimes.com/imager/u/original/11571403/cdw_credit_marie_wynants.jpg';
// String tinyImage =
//     'https://i1.wp.com/dance4mation.com/wp-content/uploads/2019/10/charlotte-de-witte.jpg?resize=50%2C50&ssl=1';
// String profilePicture =
//     'https://i1.sndcdn.com/avatars-000730092496-deopd2-t500x500.jpg';
// String bigImage =
//     'https://www.clubbingtv.com/wp-content/uploads/2020/04/charlotte-de-witte--scaled.jpeg';

class Post extends StatefulWidget {
  final PostModel postObj;
  final Function onClick;
  final String profilePicUrl;

  Post({
    @required this.postObj,
    @required this.onClick,
    @required this.profilePicUrl,
  }) : assert(postObj != null);

  @override
  _PostState createState() => _PostState();
}

class _PostState extends State<Post> with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  final double buttonSize = 32;

  Future<bool> onLikeButtonTapped(bool isLiked) async {
    print(" onLikeButtonTapped");

    /// send your request here
    bool success;
    if (!isLiked) {
      print("ADDING LIKE");
      success = await LikeApi()
          .addLike(widget.postObj.userName, widget.postObj.postUrl);
      widget.postObj.likes.add(
        LikeModel(AuthController.to.user.uid, UserController.to.user.userName,
            UserController.to.user.profilePicUrl),
      );
    } else {
      print("REMOVING LIKE");

      success = await LikeApi()
          .removeLike(widget.postObj.userName, widget.postObj.postUrl);
      for (var item in widget.postObj.likes) {
        if (item.likerId == AuthController.to.user.uid) {
          widget.postObj.likes.remove(item);
          break;
        }
      }
    }
    return success ? !isLiked : isLiked;
    // var success = true;
    // return success ? !isLiked : isLiked;
  }

  bool setIsLiked() {
    print("DEBUG STATMENT");

    /// send your request here
    if (widget.postObj.likes.any((element) =>
        element.likerId?.trim() == AuthController.to.user.uid.trim())) {
      return true;
    } else {
      return false;
    }
  }

  @override
  // ignore: must_call_super
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        ///[First row] in posts.dart [widget]
        ///Required argument(s) [profilePicUrl] and [userName]
        Container(
          // color: Colors.green,
          margin: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
          child: Row(children: [
            GestureDetector(
              onTap: widget.onClick,
              child: CircleAvatar(
                radius: 16.0, // 20 Default
                backgroundImage: NetworkImage(
                    widget.profilePicUrl ?? global.defaultProfilePicUrl),
                backgroundColor: Colors.transparent,
              ),
            ),
            GestureDetector(
              onTap: widget.onClick,
              child: Padding(
                  padding: EdgeInsets.symmetric(vertical: 0, horizontal: 10),
                  child: Text(widget.postObj.userName,
                      style: TextStyle(
                        fontSize: 16.0,
                        color: Colors.white,
                        fontWeight: FontWeight.w500,
                        height: 1.1,
                      ))),
            ),
          ]),
        ),

        ///[Second row] in posts.dart [widget]
        ///Required argument(s) [postUrl]
        Container(
          //margin: EdgeInsets.fromLTRB(0, 0, 0, 5),
          height: (Get.height) / 2,
          width: Get.width,
          child: AspectRatio(
            aspectRatio: 1 / 1,
            child: ClipRect(
              child: PhotoView(
                minScale: PhotoViewComputedScale.contained,
                maxScale: PhotoViewComputedScale.covered,
                initialScale: PhotoViewComputedScale.covered,
                imageProvider: NetworkImage(widget.postObj.postUrl),
                backgroundDecoration:
                    BoxDecoration(color: Color.fromARGB(100, 41, 41, 41)),
                loadingBuilder: (context, progress) => Center(
                  child: Container(
                    width: 100.0,
                    height: 100.0,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),

        ///[Third row] in posts.dart [widget]
        ///Required argument(s) [isLiked], [likesCount] and [commentsList]
        Container(
          //color: Colors.amber,
          margin: EdgeInsets.fromLTRB(12, 12, 12, 8),
          child: Row(children: [
            LikeButton(
              onTap: onLikeButtonTapped,
              size: buttonSize,
              circleColor:
                  CircleColor(start: Color(0xffffd319), end: Color(0xffff901f)),
              bubblesColor: BubblesColor(
                dotPrimaryColor: Color(0xfff222ff),
                dotSecondaryColor: Color(0xff8c1eff),
              ),
              isLiked: setIsLiked(),
              likeBuilder: (bool isLiked) {
                return Icon(
                  Icons.favorite_sharp,
                  color: isLiked ? Color(0xffff2975) : Colors.grey,
                  size: buttonSize,
                );
              },
              // likeCount: likes.toInt(),
              // countBuilder: (int count, bool isLiked, String text) {
              //   var color = isLiked ? Colors.white : Colors.grey;
              //   Widget result;
              //   if (count == 0) {
              //     result = Text(
              //       "love",
              //       style: TextStyle(color: color),
              //     );
              //   } else
              //     result = Text(
              //       text,
              //       style: TextStyle(color: color),
              //     );
              //   return result;
              // },
            ),
            SizedBox(width: 20),
            InkWell(
              child: Icon(
                Icons.comment_rounded,
                color: Colors.grey[300],
                size: 30.0,
              ),
              onTap: () => Get.to(CommentsScreen(postObj: widget.postObj),
                  transition: Transition.cupertino),
            ),
          ]),
        ),

        ///[Fourth row] in posts.dart [widget]
        ///Required argument(s) [postCaption] and [timeStamp]

        Container(
          // color: Colors.amber,
          margin: EdgeInsets.symmetric(vertical: 0, horizontal: 12),
          child: Column(
            //mainAxisSize: MainAxisSize.max,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            // mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Text('${widget.postObj.likes.length} likes',
                  style: TextStyle(
                    fontSize: 14.0,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  )),
              SizedBox(
                height: 4,
              ),
              Text(widget.postObj.postCaption ?? 'caption is null',
                  overflow: TextOverflow.ellipsis,
                  maxLines: 2,
                  style: TextStyle(
                    fontSize: 14.0,
                    color: Colors.white,
                  )),
              SizedBox(
                height: 6,
              ),
              Text(
                  timeStampConverter(DateTime.fromMillisecondsSinceEpoch(
                      int.parse(widget.postObj.timeStamp))),
                  style: TextStyle(
                    fontSize: 10.0,
                    color: Colors.grey[400],
                  )),
            ],
          ),
        ),
      ],
    );
  }
}

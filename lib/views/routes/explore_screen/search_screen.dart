import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:getNav/custom/no_glowing_overscroll_indicator.dart';
import 'package:getNav/views/routes/explore_screen/widgets/search_bar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:getNav/api/follower_api.dart';
import 'package:getNav/api/following_api.dart';
import 'package:getNav/api/post_api.dart';
import 'package:getNav/controllers/auth_controller.dart';
import 'package:getNav/controllers/follower_controller.dart';
import 'package:getNav/controllers/following_controller.dart';
import 'package:getNav/custom/morph_button.dart';
import 'package:getNav/global/globals.dart' as global;
import 'package:getNav/models/data/user_model.dart';
import 'package:getNav/api/user_api.dart';
import 'package:getNav/custom/no_glowing_overscroll_indicator.dart';
import 'package:getNav/views/routes/public_profile_screen/public_profile_screen.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:getNav/views/shared/null_Indicator.dart';
import 'package:getNav/views/shared/empty_list_indicator.dart';

//ignore: must_be_immutable
class SearchScreen extends StatefulWidget {
  final FocusNode searchBarFocusNode;
  List<UserModel> searchedUsersList = List<UserModel>();
  SearchScreen({@required this.searchBarFocusNode});

  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final _searchBarKey = GlobalKey<FormBuilderState>();
  final _searchController = TextEditingController();

  Future<void> _buildsearchedUsersList() async {
    // print("SEARCH CONTROLLER TEXT ${_searchController.text}");
    if (_searchController.text.isNotEmpty || _searchController.text != '') {
      var searchUser;
      widget.searchedUsersList = [];
      var uid = await UserApi().getUidFromUsername(_searchController.text);
      if (uid != 'null' && uid != AuthController.to.user.uid) {
        searchUser = await UserApi().getUserFromUid(uid);
        setState(() {
          widget.searchedUsersList.add(searchUser);
        });
      } else {
        setState(() {
          widget.searchedUsersList = [];
        });
      }
    } else {
      setState(() {
        widget.searchedUsersList = [];
      });
    }
  }

  _printText() {
    print("Second text field: ${_searchController.text}");
  }

  @override
  void initState() {
    super.initState();

    _searchController.addListener(_buildsearchedUsersList);
  }

  @override
  Widget build(BuildContext context) {
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
                  bottom: PreferredSize(
                    preferredSize: Size.fromHeight(0.4),
                    child: Container(
                      color: Colors.grey[700],
                      height: 0.4,
                    ),
                  ),
                  leading: RawMaterialButton(
                    onPressed: () => Navigator.pop(context),
                    child: Icon(
                      Icons.arrow_back,
                      color: Colors.white,
                      size: 28,
                    ),
                  ),
                  flexibleSpace: Container(
                      color: Colors.black,
                      child: SearchBar(
                          searchBarFocusNode: widget.searchBarFocusNode,
                          searchBarKey: _searchBarKey,
                          searchController: _searchController)),
                  pinned: false,
                  floating: true,
                  elevation: 0.0,
                ),
                SliverList(
                  delegate: SliverChildBuilderDelegate(
                      (BuildContext context, int index) {
                    return Padding(
                      padding: const EdgeInsets.all(4.0),
                      child: ListTile(
                        leading: ClipOval(
                            child: Image.network(
                          widget.searchedUsersList[index].profilePicUrl ??
                              global.defaultProfilePicUrl,
                          width: 50,
                          height: 50,
                          fit: BoxFit.cover,
                        )),
                        title: Text(
                            widget.searchedUsersList[index].userName ??
                                'Username',
                            style: TextStyle(color: Colors.white)),
                        subtitle: Text(
                            widget.searchedUsersList[index].fullName ??
                                'fullName',
                            style: TextStyle(color: Colors.white)),
                        onTap: () async {
                          var uid = await UserApi().getUidFromUsername(
                              widget.searchedUsersList[index].userName);
                          var user = await UserApi().getUserFromUid(uid);
                          var posts = await PostApi().getPostsFromUid(uid);
                          var followers =
                              await FollowerApi().getFollowersFromUid(uid);
                          var followings =
                              await FollowingApi().getFollowingsFromUid(uid);

                          pushNewScreen(context,
                              screen: PublicProfileScreen(
                                userObj: user,
                                followerObj: followers,
                                followingObj: followings,
                                postObj: posts,
                              ),
                              withNavBar: true,
                              pageTransitionAnimation:
                                  PageTransitionAnimation.cupertino);
                        },
                      ),
                    );
                  }, childCount: widget.searchedUsersList.length ?? 0),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

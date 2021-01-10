import 'package:flutter/material.dart';
import 'package:getNav/controllers/user_controller.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:get/get.dart';
import '../../global/globals.dart' as global;

class ProfilePicUploader extends StatefulWidget {
  // const ProfilePicUploader({Key key}) : super(key: key);
  String confirmedProfilePic;
  ProfilePicUploader({this.confirmedProfilePic});

  @override
  _ProfilePicUploaderState createState() => _ProfilePicUploaderState();
}

class _ProfilePicUploaderState extends State<ProfilePicUploader> {
  //File _image;
  final picker = ImagePicker();
  Image profilePic;

  @override
  void initState() {
    super.initState();
    profilePic = Image(image: AssetImage('assets/images/default_simple.png'));
    //profilePic = Image(image: NetworkImage(global.defaultProfilePicUrl));
  }

  Future getGalleryImage() async {
    final pickedFile = await picker.getImage(source: ImageSource.gallery);

    setState(() {
      if (pickedFile != null) {
        global.profilePicPath = File(pickedFile.path);
        profilePic = Image(image: FileImage(global.profilePicPath));
        widget.confirmedProfilePic = null;
      } else {
        print('No image selected.');
      }
    });
  }

  Future getCameraImage() async {
    final pickedFile = await picker.getImage(source: ImageSource.camera);

    setState(() {
      if (pickedFile != null) {
        global.profilePicPath = File(pickedFile.path);
        profilePic = Image(image: FileImage(global.profilePicPath));
        widget.confirmedProfilePic = null;
      } else {
        print('No image selected.');
      }
    });
  }

  Future removeProfileImage() async {
    setState(() {
      global.profilePicPath = null;

      profilePic = Image(image: AssetImage('assets/images/default_simple.png'));
      widget.confirmedProfilePic = null;
    });
  }

  void _showBottomSheet() {
    print("${global.profilePicPath}  XXX global.profilePicPath");
    print("${global.defaultProfilePicUrl} XXX global.defaultProfilePicUrl");
    Get.bottomSheet(
      Wrap(
        children: <Widget>[
          ListTile(
            leading: Icon(Icons.camera_enhance, color: Colors.white),
            title: Text('Camera', style: TextStyle(color: Colors.white)),
            onTap: () async {
              getCameraImage();
              Get.back();
            },
          ),
          PreferredSize(
              child: Container(
                color: Colors.grey[700],
                height: 0.4,
              ),
              preferredSize: Size.fromHeight(0.4)),
          ListTile(
            leading: Icon(Icons.image, color: Colors.white),
            title: Text('Gallery', style: TextStyle(color: Colors.white)),
            onTap: () async {
              getGalleryImage();
              Get.back();
            },
          ),
          PreferredSize(
              child: Container(
                color: Colors.grey[700],
                height: 0.4,
              ),
              preferredSize: Size.fromHeight(0.4)),
          ListTile(
            leading: Icon(Icons.clear, color: Colors.redAccent[400]),
            title:
                Text('Remove', style: TextStyle(color: Colors.redAccent[400])),
            onTap: () async {
              removeProfileImage();
              Get.back();
            },
          ),
        ],
      ),
      backgroundColor: Colors.grey[900],
      // shape: ShapeBorder (),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          color: Colors.white54,
          shape: BoxShape.circle,
          border: Border.all(color: Colors.white, width: 2)),
      child: Material(
        elevation: 1.0,
        shape: CircleBorder(),
        clipBehavior: Clip.antiAlias,
        color: Colors.transparent,
        child: (widget.confirmedProfilePic != null)
            ? ClipOval(
                child: Ink.image(
                  image: Image.network(
                          Get.find<UserController>().user.profilePicUrl)
                      .image,
                  fit: BoxFit.cover,
                  width: 100.0,
                  height: 100.0,
                  child: InkWell(
                    onTap: _showBottomSheet,
                  ),
                ),
              )
            : Ink.image(
                image: profilePic.image,
                fit: BoxFit.cover,
                width: 100.0,
                height: 100.0,
                child: InkWell(
                  onTap: _showBottomSheet,
                ),
              ),
      ),
    );
  }
}

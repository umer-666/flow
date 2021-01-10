import 'dart:io';
import 'dart:ui';
import 'package:ext_storage/ext_storage.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/material.dart';
import 'package:arcore_flutter_plugin/arcore_flutter_plugin.dart';
import 'package:get/get.dart';
import 'package:getNav/api/post_api.dart';
import 'package:getNav/controllers/auth_controller.dart';
import 'package:getNav/controllers/user_controller.dart';
import 'package:getNav/controllers/navigation/main_bottom_nav_controller.dart';
import 'package:getNav/controllers/services/imagebb_upload.dart';
import 'package:native_screenshot/native_screenshot.dart';
import 'package:getNav/utils/get_timestamp.dart';
import 'package:image/image.dart' as imageLib;
import 'package:path_provider/path_provider.dart';

class ArScreen extends StatefulWidget {
  @override
  _ArScreenState createState() => _ArScreenState();
}

class _ArScreenState extends State<ArScreen> {
  ArCoreController arCoreController;
  String objectSelected;

  // File _imageFile;
  // var _repaintBoundaryKey = GlobalKey();
  Future<String> _getPath() {
    return ExtStorage.getExternalStoragePublicDirectory(
        ExtStorage.DIRECTORY_PICTURES);
  }

  ///[Screeshot using flutters RepaintBoundary ]
  // void _captureScreehShot() async {
  //   RenderRepaintBoundary boundary =
  //       _repaintBoundaryKey.currentContext.findRenderObject();
  //   if (boundary.debugNeedsPaint) {
  //     print("Waiting for boundary to be painted.");
  //     await Future.delayed(const Duration(milliseconds: 20));
  //     return _captureScreehShot();
  //   }

  //   var image = await boundary.toImage();
  //   // final directory = (await getExternalStorageDirectory()).path;
  //   final directory = (await getTemporaryDirectory()).path;

  //   print("\n************ directory : $directory ************ \n");
  //   // print((await getApplicationDocumentsDirectory()).path);
  //   // print((await getExternalStorageDirectory()).path);
  //   ByteData byteData = await image.toByteData(format: ImageByteFormat.png);
  //   Uint8List pngBytes = byteData.buffer.asUint8List();

  //   print(pngBytes);
  //   String uid = getTimeStamp();
  //   File imgFile = File('$directory/ar_screenshot_$uid.png');
  //   await imgFile.writeAsBytes(pngBytes);
  //   // print("imgFile: $imgFile");
  //   print("imgFile RUNTIMETYPE: ${imgFile.runtimeType}");
  //   print(getTemporaryDirectory());
  //   var response = await uploadImageFile(imgFile);

  //   String postUrl = response['displayUrl'];
  //   String thumbUrl = response['thumbUrl'];

  //   await PostApi().addPost(Get.find<AuthController>().user.uid, 'flow ar !',
  //       postUrl, thumbUrl, 'AR');
  //   Get.off(MainBottomNav(routeIndex: 0));
  // }
  ///[Screeshot using flutters RepaintBoundary ]
  ///
  Future<void> _captureScreehShot() async {
    String pathFromNativeScr = await NativeScreenshot.takeScreenshot();
    File filefromNativeScr = File(pathFromNativeScr);

    print("********* NATIVE PATH: $pathFromNativeScr *********");
    print("********* NATIVE FILE: $filefromNativeScr *********");

    ///[IMAGE LIBRARY CROPPING]
    // imageLib.Image imageToCrop =
    //     imageLib.decodeImage(File(path).readAsBytesSync());
    // imageLib.Image croppedImage =
    //     imageLib.copyCrop(imageToCrop, 0, 0, 256, 256);
    // final directory = (await getTemporaryDirectory()).path;
    // String uid = getTimeStamp();
    // File croppedImageFile = File('$directory/ar_screenshot_$uid.png')
    //   ..writeAsBytesSync(imageLib.encodePng(croppedImage));
    // ;
    // // File croppedImageFile = File('${directory}thumbnail.png')

    // print("********* croppedImageFile: $croppedImageFile *********");

    ///[IMAGE LIBRARY CROPPING]
    var response = await uploadImageFile(filefromNativeScr);
    print("********* RESPONSE: $response *********");
    String postUrl = response['displayUrl'];
    String thumbUrl = response['thumbUrl'];

    await PostApi().addPost(Get.find<AuthController>().user.uid,
        UserController.to.user.userName, 'flow ar !', thumbUrl, thumbUrl, 'AR');
  }

  @override
  Widget build(BuildContext context) {
    return

        ///[repaint]
        // RepaintBoundary(
        //   key: _repaintBoundaryKey,
        //   child:
        Scaffold(
      backgroundColor: Colors.red,
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        // title: const Text('Flow AR'),
        centerTitle: true,
        actions: <Widget>[
          Container(
            width: 56,
            child: RawMaterialButton(
                child: Icon(
                  Icons.done,
                  color: Colors.white,
                  size: 32,
                ),
                onPressed: () async {
                  await _captureScreehShot();
                  Get.offAll(MainBottomNav(routeIndex: 4));
                }),
          ),
        ],
      ),
      body: Stack(
        children: <Widget>[
          ArCoreView(
            onArCoreViewCreated: _onArCoreViewCreated,
            enableTapRecognizer: true,
          ),
          Align(
            alignment: Alignment.bottomLeft,
            child: ListObjectSelection(
              onTap: (value) {
                objectSelected = value;
              },
            ),
          ),
        ],
      ),

      ///[repaint]// ),
    );
  }

  void _onArCoreViewCreated(ArCoreController controller) {
    arCoreController = controller;
    arCoreController.onNodeTap = (name) => onTapHandler(name);
    arCoreController.onPlaneTap = _handleOnPlaneTap;
  }

  void _addToucano(ArCoreHitTestResult plane) {
    if (objectSelected != null) {
      //"https://github.com/KhronosGroup/glTF-Sample-Models/raw/master/2.0/Duck/glTF/Duck.gltf"
      final toucanoNode = ArCoreReferenceNode(
          name: objectSelected,
          object3DFileName: objectSelected,
          position: plane.pose.translation,
          rotation: plane.pose.rotation);
      print("selected: $objectSelected");
      arCoreController.addArCoreNodeWithAnchor(toucanoNode);
    } else {
      showDialog<void>(
        context: context,
        builder: (BuildContext context) =>
            AlertDialog(content: Text('Select an object!')),
      );
    }
  }

  void _handleOnPlaneTap(List<ArCoreHitTestResult> hits) {
    print(hits);
    final hit = hits.first;
    _addToucano(hit);
  }

  void onTapHandler(String name) {
    print("Flutter: onNodeTap");
    showDialog<void>(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        content: Row(
          children: <Widget>[
            Text('Remove $name?'),
            IconButton(
                icon: Icon(
                  Icons.delete,
                ),
                onPressed: () {
                  arCoreController.removeNode(nodeName: name);
                  Navigator.pop(context);
                })
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    arCoreController.dispose();
    super.dispose();
  }
}

class ListObjectSelection extends StatefulWidget {
  final Function onTap;

  ListObjectSelection({this.onTap});

  @override
  _ListObjectSelectionState createState() => _ListObjectSelectionState();
}

class _ListObjectSelectionState extends State<ListObjectSelection> {
  List<String> gifs = [
    "assets/TocoToucan.gif",
    "assets/AndroidRobot.gif",
    "assets/ArcticFox.gif",
    "assets/PurplePaperPlane.gif",
    "assets/CubeRoom.gif",
  ];

  List<String> objectsFileName = [
    "toucan.sfb",
    "andy.sfb",
    "artic_fox.sfb",
    "paper_plane.sfb",
    "cube_room.sfb"
  ];

  String selected;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 100.0,
      child: ListView.builder(
        itemCount: gifs.length,
        scrollDirection: Axis.horizontal,
        itemBuilder: (context, index) {
          return GestureDetector(
            onTap: () {
              setState(() {
                selected = gifs[index];
                widget.onTap(objectsFileName[index]);
              });
            },
            child: Card(
              elevation: 4.0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(
                  Radius.circular(4),
                ),
              ),
              child: Container(
                height: 100.0,
                width: 100.0,
                color:
                    selected == gifs[index] ? Colors.pink : Colors.transparent,
                padding: selected == gifs[index] ? EdgeInsets.all(4.0) : null,
                child: Image.asset(
                  gifs[index],
                  fit: BoxFit.cover,
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

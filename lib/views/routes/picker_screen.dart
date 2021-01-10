import 'dart:convert';
import 'dart:io';
import 'package:getNav/controllers/services/classifier.dart';
import 'package:getNav/controllers/services/imagebb_upload.dart';
import 'package:getNav/models/ui/file.dart';
import 'package:getNav/views/routes/caption_screen/caption_screen.dart';
import 'package:path/path.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:storage_path/storage_path.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:photofilters/photofilters.dart';
import 'package:image/image.dart' as imageLib;
import 'package:getNav/utils/image_size_getter.dart';

class PickerScreen extends StatefulWidget {
  @override
  _PickerScreenState createState() => _PickerScreenState();
}

class _PickerScreenState extends State<PickerScreen> {
  ///[FILTER LOADING INDICATOR]
  final loadingIndicatorPulse = SpinKitCubeGrid(
    color: Colors.white12,
    size: 80.0,
  );

  ///[CAMERA IMAGE]
  File _cameraImage;
  String category;
  final picker = ImagePicker();
  List<FileModel> files;
  FileModel selectedModel;
  String image;
  Future _getImagesPath;
  List<Filter> filters = [
    NoFilter(),
    AdenFilter(),
    CremaFilter(),
    F1977Filter(),
    HelenaFilter(),
    HudsonFilter(),
    InkwellFilter(),
    LoFiFilter(),
    PerpetuaFilter(),
  ];
  @override
  void initState() {
    super.initState();
    _getImagesPath = getImagesPath();
  }

  Future getCameraImage() async {
    final pickedFile =
        await picker.getImage(source: ImageSource.camera, maxWidth: 512);

    if (pickedFile != null) {
      _cameraImage = File(pickedFile.path);
      setState(() {
        image = _cameraImage.path;
        // print("\nIMAGE : $image\n");
      });
      print('Image selected.');
    } else {
      print('No image selected.');
    }
    await processImage();
  }

  Future getItems() async {
    return files
            .map((e) => DropdownMenuItem(
                  child: Text(
                    "  ${e.folder}",
                    style: TextStyle(color: Colors.white, fontSize: 20),
                  ),
                  value: e,
                ))
            .toList() ??
        <DropdownMenuItem<FileModel>>[];
  }

  getImagesPath() async {
    var imagePath = await StoragePath.imagesPath;
    var images = jsonDecode(imagePath) as List;

    files = images.map<FileModel>((e) => FileModel.fromJson(e)).toList();

    if (files != null && files.length > 0)
      setState(() {
        selectedModel = files[0];
        image = files[0].files[0];
      });

    return await getItems();
  }

  Future<void> processImage() async {
    String label;

    ///[STEP 1: CLASSIFY]
    // classify(File(this.image)).then((String value) {
    //   category = value;
    // });
    label = await classify(File(this.image));

    setState(() {
      category = label;
    });
    applyFilter();
  }

  applyFilter() async {
    String fileName = basename(File(this.image).path);

    // print("IMAGE SIZE: ${await sizeGetter(fileName)}");
    var image = imageLib.decodeImage(File(this.image).readAsBytesSync());

    ///[resize images before applying filter]
    image = imageLib.copyResize(image, width: 512);

    ///[PHOTOL FILTER SELECTOR WIDGET]
    Map imageFile = await Get.to(
      PhotoFilterSelector(
        title: Text("Photo Filter"),
        image: image,
        filters: filters,
        filename: fileName,
        loader: Center(child: loadingIndicatorPulse),
        fit: BoxFit.contain,
      ),
      transition: Transition.cupertino,
    );
    if (imageFile != null) {
      Get.to(
          CaptionScreen(
            pickedFile: File(imageFile["image_filtered"]),
            category: this.category,
          ),
          duration: Duration(milliseconds: 0));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: Container(
        width: 45,
        height: 45,
        child: FloatingActionButton(
          backgroundColor: Colors.pink,
          onPressed: getCameraImage,
          tooltip: 'Camera',
          child: Icon(Icons.camera, size: 30),
        ),
      ),
      body: SafeArea(
        child: FutureBuilder(
            future: _getImagesPath,
            builder: (context, snapshot) {
              if (snapshot.data == null) {
                return Center(child: loadingIndicatorPulse);
              } else {
                return Column(
                  children: <Widget>[
                    Container(
                      // color: Colors.red,
                      ///[CUSTOM APP BAR]
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Row(children: <Widget>[
                            SizedBox(width: 10),

                            ///[DROPDOWN MENU]
                            DropdownButtonHideUnderline(
                              child: Material(
                                color: Colors.transparent,
                                child: InkWell(
                                  onTap: () {},
                                  child: DropdownButton<FileModel>(
                                    icon: Icon(Icons.arrow_drop_down,
                                        color: Colors.pink),
                                    dropdownColor: Colors.black54,
                                    items: snapshot.data,
                                    onChanged: (FileModel d) {
                                      assert(d.files.length > 0);
                                      image = d.files[0];
                                      setState(() {
                                        selectedModel = d;
                                      });
                                    },
                                    value: selectedModel,
                                  ),
                                ),
                              ),
                            ),
                          ]),

                          ///[CONFIRM BUTTON]
                          Material(
                            color: Colors.transparent,
                            child: IconButton(
                              icon: Icon(
                                Icons.arrow_forward,
                                color: Colors.pink,
                                size: 36,
                              ),
                              onPressed: processImage,
                            ),
                          ),
                        ],
                      ),
                    ),
                    PreferredSize(
                        child: Container(
                          color: Colors.grey[700],
                          height: 0.4,
                        ),
                        preferredSize: Size.fromHeight(0.4)),
                    SizedBox(height: 2),

                    ///[IMAGE PREVIEW]
                    Container(

                        /// height of the contair that holds the image
                        height: MediaQuery.of(context).size.height * 0.45,
                        child: image != null
                            ? Image.file(
                                File(image),
                                height:
                                    MediaQuery.of(context).size.height * 0.45,
                                //width: MediaQuery.of(context).size.width * 0.45,
                                //fit: BoxFit.contain,
                              )
                            : Container()),
                    SizedBox(height: 2),
                    selectedModel == null && selectedModel.files.length < 1
                        ? Container()
                        : Expanded(
                            child: Container(
                              // color: Colors.green,
                              /// height of the entire thumbnail selection grid
                              height: MediaQuery.of(context).size.height * 0.38,
                              child: GridView.builder(
                                  physics: const BouncingScrollPhysics(
                                      parent: AlwaysScrollableScrollPhysics()),
                                  padding: const EdgeInsets.only(
                                      bottom: kFloatingActionButtonMargin + 47),
                                  gridDelegate:
                                      SliverGridDelegateWithFixedCrossAxisCount(
                                          crossAxisCount: 4,
                                          crossAxisSpacing: 1,
                                          mainAxisSpacing: 1),
                                  itemBuilder: (_, i) {
                                    var file = selectedModel.files[i];
                                    // print("\n Get WIDTH IN GRID ${(Get.width * 0.4).round()}" +
                                    //     "\nGet HEIGHT IN GRID ${(Get.height * 0.4).round()}\n");

                                    return GestureDetector(
                                      ///Width of each thumbnail image
                                      child: Image(
                                        image: ResizeImage(
                                          FileImage(File(file)),
                                          height: (Get.height * 0.32).round(),
                                        ),
                                        fit: BoxFit.cover,
                                      ),
                                      onTap: () {
                                        setState(() {
                                          image = file;
                                          // print("\nIMAGE : $image\n");
                                        });
                                      },
                                    );
                                  },
                                  itemCount: selectedModel.files.length),
                            ),
                          ),
                  ],
                );
              }
            }),
      ),
    );
  }
}

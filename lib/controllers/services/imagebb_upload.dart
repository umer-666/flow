import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:dio/dio.dart';
import 'package:getNav/models/data/imgbb_response_model.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import '../../global/globals.dart' as global;

///[IMGBB UPLOAD]
final imgBBkey = 'ba761fa3f46fa8dbbbe2821fd24b1179';
Dio dio = Dio();
ImgbbResponseModel imgbbResponse;

Future<Map<String,String>> uploadImageFile(File _image) async {
  //RETURN DEFAULT PROFILE PICTURE IN CASE IT IS NOT PROVIDED (NULL CHECK)
   
  if (_image == null) {
    
    return ({'displayUrl':global.defaultProfilePicUrl});
  }

//  ByteData bytes ;
  Uint8List bytes;
    //  print("AR!: ${_image.runtimeType}");
  try {
    //  bytes = await rootBundle.load(_image.path);
    bytes = _image.readAsBytesSync();
  } catch (e) {
    print(e);
  }
// var buffer = bytes.buffer;
//   var m = base64.encode(Uint8List.view(buffer));
  String m = base64Encode(bytes);
  FormData formData = FormData.fromMap({"key": imgBBkey, "image": m});

  Response response = await dio.post(
    "https://api.imgbb.com/1/upload",
    data: formData,
  );
  print(response.data);
  if (response.statusCode != 400) {
    imgbbResponse = ImgbbResponseModel.fromJson(response.data);
    // var result = json.encode(response.data.toJson());
    return ({'displayUrl':imgbbResponse.data.displayUrl,'thumbUrl':imgbbResponse.data.thumbUrl});
  } else {
    return ({'displayUrl':global.defaultProfilePicUrl});
  }
}

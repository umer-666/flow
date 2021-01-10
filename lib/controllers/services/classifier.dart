import 'dart:io';
import 'dart:convert';

import 'package:firebase_ml_vision/firebase_ml_vision.dart';

Future<String> classify(File image) async {
  // File image;

  // String text = '';

  FirebaseVisionImage visionImage = FirebaseVisionImage.fromFile(image);

  final ImageLabeler cloudLabeler = FirebaseVision.instance.imageLabeler();

  final List<ImageLabel> cloudLabels =
      await cloudLabeler.processImage(visionImage);

  // print(cloudLabels);
  // text = '';

  // for (ImageLabel label in cloudLabels) {
  //   final double confidence = label.confidence;
  //   final String currentLabel = label.text;

  //   text += currentLabel + " " + confidence.toStringAsFixed(2) + "\n";

  //  text += "$label.text   $confidence.toStringAsFixed(2) \n";
  // text = "'$label\.text'   '$confidence' \n";
  // text += label.text+"\n";
  print("Inside Classifier: ${cloudLabels[0].text}");
// } FOR LOOP BRACKET CLOSING
  cloudLabeler.close();
  String label = cloudLabels[0].text;
  return (label);
}

/// STARTES HERE
// import 'dart:io';
// import 'package:flutter/material.dart';
// import 'package:image_picker/image_picker.dart';
// import 'package:firebase_ml_vision/firebase_ml_vision.dart';

// class Classifier extends StatefulWidget {
//   @override
//   _ClassifierState createState() => _ClassifierState();
// }

// class _ClassifierState extends State<Classifier> {
//   File _image;
//   final picker = ImagePicker();
//   var text = '';
//   bool imageLoaded = false;

//   Future getImage() async {
//     final pickedFile = await picker.getImage(source: ImageSource.gallery);

//     setState(() {
//       if (pickedFile != null) {
//         imageLoaded = true;
//         _image = File(pickedFile.path);
//       } else {
//         print('No image selected.');
//       }
//     });
//     FirebaseVisionImage visionImage = FirebaseVisionImage.fromFile(_image);

//     final ImageLabeler cloudLabeler = FirebaseVision.instance.imageLabeler();

//     final List<ImageLabel> cloudLabels =
//         await cloudLabeler.processImage(visionImage);
//     text = '';

//     for (ImageLabel label in cloudLabels) {
//       final double confidence = label.confidence;
//       final String currentLabel = label.text;
//       setState(() {
//         text += currentLabel + " " + confidence.toStringAsFixed(2) + "\n";
//         //  text += "$label.text   $confidence.toStringAsFixed(2) \n";
//         // text = "'$label\.text'   '$confidence' \n";
//         // text += label.text+"\n";
//         print(text);
//       });
//     }

//     cloudLabeler.close();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Column(
//         children: <Widget>[
//           SizedBox(height: 100.0),
//           imageLoaded
//               ? Center(
//                   child: Container(
//                   decoration: BoxDecoration(
//                     color: Colors.white,
//                     boxShadow: const [
//                       BoxShadow(blurRadius: 20),
//                     ],
//                   ),
//                   margin: EdgeInsets.fromLTRB(0, 0, 0, 8),
//                   height: 250,
//                   child: Image.file(
//                     _image,
//                     fit: BoxFit.cover,
//                   ),
//                 ))
//               : Container(),
//           SizedBox(height: 10.0),
//           Center(
//             child: FlatButton.icon(
//               icon: Icon(
//                 Icons.photo_camera,
//                 size: 100,
//               ),
//               label: Text(''),
//               textColor: Theme.of(context).primaryColor,
//               onPressed: getImage,
//             ),
//           ),
//           SizedBox(height: 10.0),
//           SizedBox(height: 10.0),
//           text == ''
//               ? Text('Text will display here')
//               : Expanded(
//                   child: SingleChildScrollView(
//                     child: Padding(
//                       padding: const EdgeInsets.all(15.0),
//                       child: Text(
//                         text,
//                       ),
//                     ),
//                   ),
//                 ),
//         ],
//       ),
//     );
//   }
// }

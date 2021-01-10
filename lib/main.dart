import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:get/get.dart';
import 'package:getNav/controllers/navigation/route_delegate.dart';
import 'controllers/bindings/auth_binding.dart';
import 'package:arcore_flutter_plugin/arcore_flutter_plugin.dart'
    show ArCoreController;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  print('ARCORE IS AVAILABLE?');
  print(await ArCoreController.checkArCoreAvailability());
  await Firebase.initializeApp();
  runApp(FlowApp());
}

class FlowApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Flow',
      initialBinding:  AuthBinding(),
      theme: ThemeData(
        backgroundColor: Colors.black,
        scaffoldBackgroundColor: Colors.black,
        primarySwatch: Colors.pink,
        splashFactory: InkRipple.splashFactory,
        visualDensity: VisualDensity.adaptivePlatformDensity,
        cursorColor: Colors.white,
        inputDecorationTheme: InputDecorationTheme(
          filled: false,
          fillColor: Colors.grey[900],
          errorBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: Colors.redAccent[400])),
          errorStyle: TextStyle(color: Colors.redAccent[400]),
          focusedBorder:
              UnderlineInputBorder(borderSide: BorderSide(color: Colors.pink)),
          enabledBorder:
              UnderlineInputBorder(borderSide: BorderSide(color: Colors.white)),
          floatingLabelBehavior: FloatingLabelBehavior.always,
          labelStyle: TextStyle(fontSize: 16, color: Colors.white, height: 0.5),
          hintStyle: TextStyle(fontSize: 18, color: Colors.white),
        ),
      ),
      home: RouteDelegate(),
      // home: Classifier(),
      debugShowCheckedModeBanner: false,
    );
  }
}

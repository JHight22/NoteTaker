import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:notetaker/controllers/bindings/authBinding.dart';
import 'package:notetaker/utils/root.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'NoteTaker',
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark(),
      initialBinding: AuthBinding(),
      home: Root(),
    );
  }
}

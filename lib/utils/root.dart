import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:notetaker/Widgets/BottomNavigationBar.dart';
import 'package:notetaker/controllers/authController.dart';
import 'package:notetaker/controllers/userController.dart';
import 'package:notetaker/screens/login.dart';

class Root extends GetWidget<AuthController> {
  @override
  Widget build(BuildContext context) {
    return GetX(
      initState: (_) async {
        Get.put<UserController>(UserController());
      },
      builder: (_) {
        if (Get.find<AuthController>().user?.uid != null) {
          return HomeScreen();
        } else {
          return Login();
        }
      },
    );
  }
}

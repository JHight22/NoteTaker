import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:notetaker/controllers/authController.dart';
import 'package:notetaker/controllers/userController.dart';
import 'package:notetaker/services/firebaseDatabase.dart';

class NavigationDrawer extends GetWidget<AuthController> {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          DrawerHeader(
            decoration: BoxDecoration(
              color: Colors.orangeAccent[700],
            ),
            child: Text(
              'NoteTaker',
              style: TextStyle(
                color: Colors.black,
                fontSize: 24,
              ),
            ),
          ),
          ListTile(
            title: GetX<UserController>(
              initState: (_) async {
                Get.find<UserController>().user = await FirebaseDatabase()
                    .getUser(Get.find<AuthController>().user.uid);
              },
              builder: (_) {
                if (_.user.name != null) {
                  return Text("Welcome " + _.user.name);
                } else {
                  return Text("loading");
                }
              },
            ),
          ),
          ListTile(
            title: Text('Sign Out'),
            trailing: Icon(
              Icons.exit_to_app_sharp,
            ),
            onTap: () {
              controller.signOutUser();
            },
          ),
        ],
      ),
    );
  }
}

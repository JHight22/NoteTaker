import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:notetaker/Widgets/navigation_drawer.dart';
import 'package:notetaker/controllers/authController.dart';

class AllNotesScreen extends GetWidget<AuthController> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        heroTag: null,
        child: Icon(Icons.note),
        backgroundColor: Colors.orangeAccent[700],
        onPressed: () {
          //Get.to(() => AddTaskScreen());
        },
      ),
      appBar: AppBar(
        title: Text("All Notes"),
      ),
      drawer: NavigationDrawer(),
    );
  }
}

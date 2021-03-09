import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:notetaker/controllers/authController.dart';
import 'package:notetaker/services/firebaseDatabase.dart';

class AddTaskScreen extends GetWidget<AuthController> {
  final TextEditingController _taskController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Create Task"),
      ),
      body: Container(
        padding: EdgeInsets.all(12.0),
        child: Column(
          children: [
            Expanded(
              child: TextField(
                controller: _taskController,
                autofocus: true,
                decoration: InputDecoration(
                    hintText: 'What do you want to accomplish?',
                    border: InputBorder.none,
                    focusedBorder: InputBorder.none),
                style: TextStyle(
                  fontSize: 20,
                ),
                keyboardType: TextInputType.multiline,
                maxLines: 999,
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    primary: Colors.orangeAccent[700],
                    onPrimary: Colors.black,
                  ),
                  child: Text('Cancel'),
                  onPressed: () {
                    Get.back();
                  },
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    primary: Colors.orangeAccent[700],
                    onPrimary: Colors.black,
                  ),
                  child: Text("Create"),
                  onPressed: () {
                    if (_taskController.text != "") {
                      FirebaseDatabase().createTask(
                          _taskController.text, controller.user.uid);
                      _taskController.clear();
                      Get.back();
                    }
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

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
        actions: [
          IconButton(
            icon: Icon(Icons.add),
            onPressed: () {
              if (_taskController.text != "") {
                FirebaseDatabase()
                    .createTask(_taskController.text, controller.user.uid);
                _taskController.clear();
                Get.back();
              }
            },
          )
        ],
      ),
      body: Column(
        children: <Widget>[
          SizedBox(
            height: 20,
          ),
          TextFormField(
            controller: _taskController,
          ),
        ],
      ),
    );
  }
}

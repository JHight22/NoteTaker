import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:notetaker/Widgets/navigation_drawer.dart';
import 'package:notetaker/Widgets/taskCard.dart';
import 'package:notetaker/controllers/authController.dart';
import 'package:notetaker/controllers/taskController.dart';
import 'addTaskScreen.dart';

class AllTasksScreen extends GetWidget<AuthController> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.note),
        backgroundColor: Colors.orangeAccent[700],
        onPressed: () {
          Get.to(() => AddTaskScreen());
        },
      ),
      appBar: AppBar(
        title: Text("Task Screen"),
      ),
      drawer: NavigationDrawer(),
      body: Column(
        children: <Widget>[
          SizedBox(
            height: 5,
          ),
          GetX<TaskController>(
            init: Get.put<TaskController>(TaskController()),
            builder: (TaskController taskController) {
              if (taskController != null && taskController.tasks != null) {
                return Expanded(
                  child: ListView.builder(
                    itemCount: taskController.tasks.length,
                    itemBuilder: (_, index) {
                      return TaskCard(
                          uid: controller.user.uid,
                          task: taskController.tasks[index]);
                    },
                  ),
                );
              } else {
                return CircularProgressIndicator(
                  valueColor:
                      AlwaysStoppedAnimation<Color>(Colors.orangeAccent[700]),
                );
              }
            },
          )
        ],
      ),
    );
  }
}

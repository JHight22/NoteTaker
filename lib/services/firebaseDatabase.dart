import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:notetaker/models/task.dart';
import 'package:notetaker/models/user.dart';
import 'package:notetaker/screens/editTaskScreen.dart';

class FirebaseDatabase extends GetxService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<bool> createNewUser(UserModel user) async {
    try {
      await _firestore.collection("users").doc(user.userId).set({
        "name": user.name,
        "email": user.email,
      });
      return true;
    } catch (e) {
      print(e);
      return false;
    }
  }

  Future<void> createTask(String title, String uid) async {
    try {
      await _firestore.collection("users").doc(uid).collection("tasks").add({
        'date': Timestamp.now(),
        'title': title,
        'complete': false,
      });
      Get.snackbar("Success!", "Task Created!",
          snackPosition: SnackPosition.TOP);
    } catch (e) {
      Get.snackbar("Can't create task!", e.message,
          snackPosition: SnackPosition.TOP);
      rethrow;
    }
  }

  Future<void> deleteTask(String uid, String taskId) async {
    try {
      await _firestore
          .collection("users")
          .doc(uid)
          .collection("tasks")
          .doc(taskId)
          .delete();
      Get.snackbar("Success!", "Task Deleted!",
          snackPosition: SnackPosition.TOP);
    } catch (e) {
      Get.snackbar("Can't delete task!", e.message,
          snackPosition: SnackPosition.TOP);
    }
  }

  Future<void> updateTaskCheckbox(
      bool newValue, String uid, String taskId) async {
    try {
      await _firestore
          .collection("users")
          .doc(uid)
          .collection("tasks")
          .doc(taskId)
          .update({"complete": newValue});
    } catch (e) {
      print(e);
      rethrow;
    }
  }

  Future<void> updateTask(
      String textController, String uid, String taskId) async {
    try {
      await _firestore
          .collection("users")
          .doc(uid)
          .collection("tasks")
          .doc(taskId)
          .update({"title": textController});
      Get.snackbar("Success!", "Task Updated!",
          snackPosition: SnackPosition.TOP);
    } catch (e) {
      Get.snackbar("Can't update task!", e.message,
          snackPosition: SnackPosition.TOP);
      rethrow;
    }
  }

  Future<UserModel> getUser(String uid) async {
    try {
      DocumentSnapshot _doc =
          await _firestore.collection("users").doc(uid).get();
      return UserModel.fromDocumentSnapShot(documentSnapshot: _doc);
    } catch (e) {
      print(e);
      rethrow;
    }
  }

  Future<TaskModel> getTask(String uid, String taskId) async {
    try {
      DocumentSnapshot _doc = await _firestore
          .collection("users")
          .doc(uid)
          .collection("tasks")
          .doc(taskId)
          .get();
      Get.to(() => EditTaskScreen());
      return TaskModel.fromDocumentSnapshot(_doc);
    } catch (e) {
      print(e);
      rethrow;
    }
  }

  Stream<List<TaskModel>> taskStream(String uid) {
    return _firestore
        .collection("users")
        .doc(uid)
        .collection("tasks")
        .orderBy("date", descending: true)
        .snapshots()
        .map((query) {
      List<TaskModel> retVal = [];
      query.docs.forEach((element) {
        retVal.add(TaskModel.fromDocumentSnapshot(element));
      });
      return retVal;
    });
  }
}

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:notetaker/models/task.dart';
import 'package:notetaker/models/user.dart';

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
      print(e);

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
    } catch (e) {
      Get.snackbar("Can't delete task!", e.message,
          snackPosition: SnackPosition.TOP);
    }
  }

  Future<void> updateTask(bool newValue, String uid, String taskId) async {
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

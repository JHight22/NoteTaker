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
    } catch (e) {
      print(e);
      rethrow;
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
        .doc("uid")
        .collection("tasks")
        .orderBy("date", descending: true)
        .snapshots()
        .map((query) {
      List<TaskModel> tasks = <TaskModel>[];
      for (final DocumentSnapshot doc in query.docs) {
        tasks.add(TaskModel.fromDocumentSnapshot(documentSnapshot: doc));
      }

      print(_firestore);
      if (tasks.isNotEmpty) {
        print("tasks not empty");
      }

      if (tasks.isEmpty) {
        print("tasks empty");
      }

      return tasks;
    });
  }
}

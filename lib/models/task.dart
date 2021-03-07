import 'package:cloud_firestore/cloud_firestore.dart';

class TaskModel {
  String title;
  String taskId;
  Timestamp date;
  bool complete;

  TaskModel({
    this.title,
    this.taskId,
    this.date,
    this.complete,
  });

  TaskModel.fromDocumentSnapshot({DocumentSnapshot documentSnapshot}) {
    taskId = documentSnapshot.id;
    title = documentSnapshot.data()['title'];
    date = documentSnapshot.data()['date'];
    complete = documentSnapshot.data()['complete'];
  }
}

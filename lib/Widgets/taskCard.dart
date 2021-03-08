import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:notetaker/models/task.dart';
import 'package:notetaker/services/firebaseDatabase.dart';

class TaskCard extends StatelessWidget {
  final String uid;
  final TaskModel task;

  const TaskCard({Key key, this.uid, this.task}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var dateTime = task.date.toDate();

    String formattedDate = DateFormat('MM-dd-yyyy').format(dateTime);

    return Card(
      elevation: 0,
      margin: EdgeInsets.symmetric(horizontal: 10, vertical: 3),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          ListTile(
            onTap: () {},
            leading: Checkbox(
              checkColor: Colors.black,
              activeColor: Colors.orangeAccent[700],
              value: task.complete,
              onChanged: (newValue) {
                FirebaseDatabase().updateTask(newValue, uid, task.taskId);
              },
            ),
            title: Text(task.title),
            subtitle: Text(formattedDate),
            trailing: GestureDetector(
              child: Icon(
                Icons.delete,
                color: Colors.orangeAccent[700],
              ),
              onTap: () {
                FirebaseDatabase().deleteTask(uid, task.taskId);
              },
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: <Widget>[],
          )
        ],
      ),
    );
  }
}

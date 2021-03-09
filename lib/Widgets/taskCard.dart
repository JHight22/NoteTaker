import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:notetaker/models/task.dart';
import 'package:notetaker/screens/editTaskScreen.dart';
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
      margin: EdgeInsets.symmetric(horizontal: 4, vertical: 1),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          ExpansionTile(
            leading: Checkbox(
              checkColor: Colors.black,
              activeColor: Colors.orangeAccent[700],
              value: task.complete,
              onChanged: (newValue) {
                FirebaseDatabase()
                    .updateTaskCheckbox(newValue, uid, task.taskId);
              },
            ),
            title: Text(task.title),
            subtitle: Text(formattedDate),
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Container(
                    height: 40,
                    child: IconButton(
                      icon: Icon(
                        Icons.edit,
                        color: Colors.orangeAccent[700],
                      ),
                      onPressed: () {
                        FirebaseDatabase().getTask(uid, task.taskId);
                      },
                    ),
                  ),
                  Container(
                    height: 40,
                    child: IconButton(
                      icon: Icon(
                        Icons.delete,
                        color: Colors.orangeAccent[700],
                      ),
                      onPressed: () {
                        FirebaseDatabase().deleteTask(uid, task.taskId);
                      },
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:notetaker/models/task.dart';
import 'package:notetaker/services/firebaseDatabase.dart';

class TaskCard extends StatelessWidget {
  final String uid;
  final TaskModel task;

  const TaskCard({Key key, this.uid, this.task}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      color: Color.fromRGBO(21, 32, 43, 1.0),
      margin: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
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
            subtitle: Text(task.date.toString()),
            trailing: GestureDetector(
              child: Icon(
                Icons.delete,
                color: Colors.orangeAccent[700],
              ),
              onTap: () {},
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

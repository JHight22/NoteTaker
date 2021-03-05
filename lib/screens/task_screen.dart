import 'package:flutter/material.dart';
import 'package:notetaker/Widgets/navigation_drawer.dart';
import 'package:notetaker/screens/add_task_screen.dart';
import 'package:notetaker/Models/task.dart';
import 'package:sqflite/sqflite.dart';
import 'dart:async';
import 'package:notetaker/Data/DatabaseHelper.dart';
import 'package:notetaker/Data/constants.dart';

class TaskScreen extends StatefulWidget {
  static const String id = 'task_screen';

  @override
  State<StatefulWidget> createState() {
    return TaskScreenState();
  }
}

class TaskScreenState extends State<TaskScreen> {
  DatabaseHelper helper = DatabaseHelper();
  List<Task> taskList;
  int count = 0;
  Task task;

  @override
  Widget build(BuildContext context) {
    if (taskList == null) {
      taskList = <Task>[];
      updateListView();
    }

    return Scaffold(
      backgroundColor: Color.fromRGBO(21, 32, 43, 1.0),
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.orangeAccent[700]),
        backgroundColor: Color.fromRGBO(21, 32, 43, 1.0),
        title: const Text(
          'Agenda',
          style: TextStyle(
            fontSize: 20.0,
          ),
        ),
      ),
      drawer: NavigationDrawer(),
      body: Builder(
        builder: (BuildContext innerContext) => getTaskListView(),
      ),
      floatingActionButton: FloatingActionButton(
        foregroundColor: Colors.black,
        backgroundColor: Colors.orangeAccent[700],
        child: Icon(Icons.content_paste),
        onPressed: () {
          navigateToAddTaskScreen(Task(), 'Create Task');
        },
      ),
    );
  }

  ListView getTaskListView() {
    return ListView.builder(
      itemCount: count,
      itemBuilder: (BuildContext context, int position) {
        return ListTile(
          leading: Checkbox(
            checkColor: Colors.black,
            activeColor: Colors.orangeAccent[700],
            value: this.taskList[position].checkbox,
            onChanged: (bool newValue) {
              setState(() {
                this.taskList[position].checkbox = newValue;
              });
              _save(context, this.taskList[position]);
            },
          ),
          title: Text(
            this.taskList[position].description,
          ),
          subtitle: Text(
            this.taskList[position].date,
          ),
          trailing: PopupMenuButton<EditAndDeletePopupMenuButton>(
            color: Color.fromRGBO(21, 32, 43, 1.0),
            icon: Icon(
              Icons.more_vert,
              color: Colors.orangeAccent[700],
            ),
            onSelected: (choice) => choiceAction(choice, position),
            //captureInheritedThemes: true,
            itemBuilder: (BuildContext context) {
              return EditAndDeletePopupMenuButton.choices.map(
                  (EditAndDeletePopupMenuButton editAndDeletePopupMenuButton) {
                return PopupMenuItem<EditAndDeletePopupMenuButton>(
                  value: editAndDeletePopupMenuButton,
                  child: ListTile(
                    leading: CircleAvatar(
                      backgroundColor: Color.fromRGBO(21, 32, 43, 1.0),
                      foregroundColor: Colors.orangeAccent[700],
                      child: editAndDeletePopupMenuButton.icon,
                    ),
                    title: Text(
                      editAndDeletePopupMenuButton.title,
                      style: TextStyle(
                        color: Colors.orangeAccent[700],
                      ),
                    ),
                  ),
                );
              }).toList();
            },
          ),
        );
      },
    );
  }

  //Displays delete confirmation dialog so that the user has a choice to cancel their action or go through with it
  Future<void> _displayDeleteConfirmationDialog(
      BuildContext context, Task task) {
    return showDialog<void>(
        context: context,
        barrierDismissible: true, // Allow dismiss when tapping away from dialog
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text("Delete Task"),
            content: Text("Are you sure you want to delete this task?"),
            actions: <Widget>[
              TextButton(
                child: Text("Cancel"),
                onPressed: Navigator.of(context).pop, // Close dialog
              ),
              TextButton(
                child: Text("Delete"),
                onPressed: () {
                  _delete(context, task);
                  Navigator.of(context).pop(); // Close dialog
                  updateListView();
                },
              ),
            ],
          );
        });
  }

  //Gives the PopupMenuButton Widget functionality
  void choiceAction(EditAndDeletePopupMenuButton choice, int position) {
    setState(() {
      if (choice == EditAndDeletePopupMenuButton.choices[0]) {
        navigateToAddTaskScreen(taskList[position], 'Edit Task');
        updateListView();
      } else if (choice == EditAndDeletePopupMenuButton.choices[1]) {
        _displayDeleteConfirmationDialog(context, this.taskList[position]);
        updateListView();
      }
    });
  }

  //this function is called whenever a task is deleted
  void _delete(BuildContext context, Task task) async {
    int result = await helper.deleteTask(task.id);
    if (result != 0) {
      _presentSnackBar(context, 'Task Deleted Successfully!');
      updateListView();
    }
  }

  //This function is to specifically save the checkbox data!
  void _save(BuildContext context, Task task) async {
    int result;
    //update operation
    if (task.id != null) {
      result = await helper.updateTask(task);
    } else {
      result = await helper.insertTask(task);
    }

    if (result != 0) {
      //_showAlertDialog('Task Saved Successfully!');
    } else {
      _showAlertDialog('Issue with Saving Task! Please Try again!');
    }
  }

  //This function will be called when someone tries to save or delete a task
  void _showAlertDialog(String message) {
    AlertDialog alertDialog = AlertDialog(
      content: Text(message),
    );
    showDialog(context: context, builder: (_) => alertDialog);
  }

  void _presentSnackBar(BuildContext context, String message) {
    final snackBar = SnackBar(content: Text(message));
  }

  //When this function is called, it navigates the task screen to the add task screen
  void navigateToAddTaskScreen(Task task, String title) async {
    bool result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) {
          return TaskDetail(task, title);
        },
      ),
    );
    if (result == true) {
      updateListView();
    }
  }

  void updateListView() {
    final Future<Database> dbFuture = helper.initializeNoteTakerDatabase();
    dbFuture.then((database) {
      Future<List<Task>> taskListFuture = helper.getTaskList();
      taskListFuture.then((taskList) {
        setState(() {
          this.taskList = taskList;
          this.count = taskList.length;
        });
      });
    });
  }
}

import 'package:flutter/material.dart';
import 'package:notetaker/Widgets/navigation_drawer.dart';
import 'package:notetaker/screens/add_task_screen.dart';
import 'package:notetaker/Models/task.dart';
import 'package:notetaker/Data/DatabaseHelper.dart';
import 'package:sqflite/sqflite.dart';
import 'dart:async';

class AllTasksScreen extends StatefulWidget {
  static const String id = 'all_tasks_screen';

  @override
  State<StatefulWidget> createState() {
    return AllTasksScreenState();
  }
}

class AllTasksScreenState extends State<AllTasksScreen> {
  DatabaseHelper taskDatabaseHelper = DatabaseHelper();
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
      floatingActionButton: FloatingActionButton(
        foregroundColor: Colors.black,
        backgroundColor: Colors.orangeAccent[700],
        child: Icon(Icons.content_paste),
        onPressed: () {
          navigateToAddTaskScreen(Task(), 'Create Task');
        },
      ),
      appBar: AppBar(
        elevation: 1,
        iconTheme: IconThemeData(color: Colors.orangeAccent[700]),
        backgroundColor: Color.fromRGBO(21, 32, 43, 1.0),
        title: const Text(
          'All Tasks',
          style: TextStyle(
            fontSize: 20.0,
          ),
        ),
      ),
      //drawer: NavigationDrawer(),
      body: Builder(
        builder: (BuildContext innerContext) => getTaskListView(),
      ),
    );
  }

  ListView getTaskListView() {
    return ListView.builder(
      itemCount: count,
      itemBuilder: (BuildContext context, int position) {
        return Card(
          elevation: 0,
          //shadowColor: Colors.orangeAccent[700],
          color: Color.fromRGBO(21, 32, 43, 1.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              ListTile(
                onTap: () {
                  navigateToAddTaskScreen(this.taskList[position], 'Edit Task');
                },
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
                trailing: GestureDetector(
                  child: Icon(
                    Icons.delete,
                    color: Colors.orangeAccent[700],
                  ),
                  onTap: () {
                    _displayDeleteConfirmationDialog(
                        context, this.taskList[position]);
                    updateListView();
                  },
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: <Widget>[],
              ),
            ],
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
            backgroundColor: Color.fromRGBO(21, 32, 43, 1.0),
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

  void _delete(BuildContext context, Task task) async {
    int result = await taskDatabaseHelper.deleteTask(task.id);
    if (result != 0) {
      _presentSnackBar(context, 'Task Deleted Successfully!');
      updateListView();
    }
  }

  void _presentSnackBar(BuildContext context, String message) {
    final snackBar = SnackBar(content: Text(message));
  }

  //When this function is called, it navigates the note screen to the add note screen
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
    final Future<Database> dbFuture =
        taskDatabaseHelper.initializeNoteTakerDatabase();
    dbFuture.then((database) {
      Future<List<Task>> taskListFuture = taskDatabaseHelper.getTaskList();
      taskListFuture.then((taskList) {
        setState(() {
          this.taskList = taskList;
          this.count = taskList.length;
        });
      });
    });
  }

  //This function will be called when someone tries to save or delete a task
  void _showAlertDialog(String message) {
    AlertDialog alertDialog = AlertDialog(
      content: Text(message),
    );
    showDialog(context: context, builder: (_) => alertDialog);
  }

  //This function is to specifically save the checkbox data!
  void _save(BuildContext context, Task task) async {
    int result;
    //update operation
    if (task.id != null) {
      result = await taskDatabaseHelper.updateTask(task);
    }

    if (result != 0) {
      //_showAlertDialog('Task Saved Successfully!');
    } else {
      _showAlertDialog('Issue with Saving Task! Please Try again!');
    }
  }
}

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:notetaker/Widgets/navigation_drawer.dart';
import 'package:notetaker/UI/add_task_screen.dart';
import 'dart:async';
import 'package:notetaker/Data/constants.dart';
import 'package:notetaker/Data/moor_database.dart';
import 'package:provider/provider.dart';

class AllTasksScreen extends StatefulWidget {
  static const String id = 'all_tasks_screen';

  @override
  State<StatefulWidget> createState() {
    return AllTasksScreenState();
  }
}

class AllTasksScreenState extends State<AllTasksScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromRGBO(21, 32, 43, 1.0),
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.orangeAccent[700]),
        backgroundColor: Color.fromRGBO(21, 32, 43, 1.0),
        title: const Text(
          'All Tasks',
          style: TextStyle(
            fontSize: 20.0,
          ),
        ),
      ),
      drawer: NavigationDrawer(),
      body: Builder(
        builder: (BuildContext innerContext) => _buildTaskList(context),
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

  StreamBuilder<List<Task>> _buildTaskList(BuildContext context) {
    final taskDao = Provider.of<TaskDao>(context);
    return StreamBuilder(
      stream: taskDao.watchAllTasks(),
      builder: (context, AsyncSnapshot<List<Task>> snapshot) {
        final tasks = snapshot.data ?? List();
        return ListView.builder(
          itemCount: tasks.length,
          itemBuilder: (_, index) {
            final itemTask = tasks[index];
            return _buildListItem(itemTask, taskDao);
          },
        );
      },
    );
  }

  Widget _buildListItem(Task itemTask, TaskDao taskDao) {
    var newFormat = DateFormat("MM-dd-yyyy");
    String updatedDt = newFormat.format(itemTask.date);

    return ListTile(
      leading: Checkbox(
        checkColor: Colors.black,
        activeColor: Colors.orangeAccent[700],
        value: itemTask.checkbox,
        onChanged: (newValue) {
          taskDao.updateTask(itemTask.copyWith(checkbox: newValue));
        },
      ),
      title: Text(itemTask.description),
      subtitle: Text(
        updatedDt,
      ),
      trailing: PopupMenuButton<EditAndDeletePopupMenuButton>(
        color: Color.fromRGBO(21, 32, 43, 1.0),
        icon: Icon(
          Icons.more_vert,
          color: Colors.orangeAccent[700],
        ),
        onSelected: (choice) => choiceAction(taskDao, choice, itemTask),
        captureInheritedThemes: true,
        itemBuilder: (BuildContext context) {
          return EditAndDeletePopupMenuButton.choices
              .map((EditAndDeletePopupMenuButton editAndDeletePopupMenuButton) {
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
  }

  //Displays delete confirmation dialog so that the user has a choice to cancel their action or go through with it
  Future<void> _displayDeleteConfirmationDialog(
      TaskDao taskDao, BuildContext context, Task itemTask) {
    return showDialog<void>(
        context: context,
        barrierDismissible: true, // Allow dismiss when tapping away from dialog
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text("Delete Task"),
            content: Text("Are you sure you want to delete this task?"),
            actions: <Widget>[
              FlatButton(
                child: Text("Cancel"),
                onPressed: Navigator.of(context).pop, // Close dialog
              ),
              FlatButton(
                child: Text("Delete"),
                onPressed: () {
                  final taskDao = Provider.of<TaskDao>(context);
                  taskDao.deleteTask(itemTask);
                  Navigator.of(context).pop(); // Close dialog
                },
              ),
            ],
          );
        });
  }

  //Gives the PopupMenuButton Widget functionality
  void choiceAction(TaskDao taskDao, choice, Task itemTask) {
    setState(() {
      if (choice == EditAndDeletePopupMenuButton.choices[0]) {
        navigateToAddTaskScreen(itemTask, 'Edit Task');
      } else if (choice == EditAndDeletePopupMenuButton.choices[1]) {
        _displayDeleteConfirmationDialog(taskDao, context, itemTask);
      }
    });
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
    if (result == true) {}
  }
}

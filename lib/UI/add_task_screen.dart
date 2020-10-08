import 'package:flutter/material.dart';
import 'dart:async';
import 'package:intl/intl.dart';
import 'package:moor/moor.dart';
import 'package:notetaker/Data/moor_database.dart';
import 'package:notetaker/UI/all_tasks_screen.dart';
import 'package:notetaker/UI/task_screen.dart';
import 'package:provider/provider.dart';
import 'package:notetaker/UI/task_folder_screen.dart';

class TaskDetail extends StatefulWidget {
  final String appBarTitle;
  final Task task;

  TaskDetail(this.task, this.appBarTitle);

  @override
  State<StatefulWidget> createState() {
    return AddTaskScreenState(this.task, this.appBarTitle);
  }
}

class AddTaskScreenState extends State<TaskDetail> {
  String appBarTitle;
  Task task;
  TextEditingController descriptionController = TextEditingController();
  TextEditingController taskFolderController = TextEditingController();

  TaskDao taskDao;
  TaskFolder selectedTaskFolder;

  AddTaskScreenState(this.task, this.appBarTitle);

  @override
  Widget build(BuildContext context) {
    TextStyle textStyle = Theme.of(context).textTheme.title;

    descriptionController.text = task.description;
    taskFolderController.text = task.folder;

    return Scaffold(
      backgroundColor: Color.fromRGBO(21, 32, 43, 1.0),
      appBar: AppBar(
        backgroundColor: Color.fromRGBO(21, 32, 43, 1.0),
        title: Text(appBarTitle),
        iconTheme: IconThemeData(
          color: Colors.orangeAccent[700],
        ),
        actions: <Widget>[
          _buildTaskFolderSelector(context),
          FlatButton(
            color: Color.fromRGBO(21, 32, 43, 1.0),
            child: Text(
              'Save',
              textScaleFactor: 1.5,
            ),
            textColor: Colors.orangeAccent[700],
            onPressed: () {
              setState(() {
                final taskDao = Provider.of<TaskDao>(context, listen: false);
                final task = TasksCompanion(
                  description: Value(descriptionController.text),
                  date: Value(DateTime.now()),
                  folder: Value(taskFolderController.text),
                );
                debugPrint('Save button clicked');
                taskDao.insertTask(task);
                moveToPreviousScreen();
              });
            },
          ),
          IconButton(
            icon: Icon(Icons.delete_outline),
            color: Colors.orangeAccent[900],
            tooltip: 'Delete your task!',
            onPressed: () {
              setState(() {
                _displayDeleteConfirmationDialog(taskDao, task, context);
              });
            },
          ),
        ],
      ),
      body: Container(
        child: Padding(
          padding: EdgeInsets.only(top: 15.0, left: 10.0, right: 10.0),
          child: ListView(
            children: <Widget>[
              Padding(
                padding: EdgeInsets.only(top: 15.0, bottom: 15.0),
                child: TextField(
                  controller: descriptionController,
                  maxLength: 100,
                  textCapitalization: TextCapitalization.sentences,
                  maxLines: null,
                  style: TextStyle(
                    fontSize: 17.0,
                    color: Colors.white,
                  ),
                  cursorColor: Colors.orangeAccent[700],
                  autocorrect: true,
//                    onChanged: (value) {
//                      debugPrint(
//                          'Something changed in description TextFormField');
//                      //updateTaskDescription();
//                      descriptionController.text = task.description;
//                    },
                  decoration: InputDecoration(
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: Color.fromRGBO(21, 32, 43, 1.0),
                      ),
                    ),
                    fillColor: Color.fromRGBO(21, 32, 43, 1.0),
                    filled: true,
                    labelText: 'Add to Your Agenda',
                    //labelStyle: textStyle,
                    labelStyle: TextStyle(
                      fontSize: 20.0,
                      color: Colors.grey,
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(5.0),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: Color.fromRGBO(21, 32, 43, 1.0),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void moveToPreviousScreen() {
    Navigator.pop(context, true);
  }

//  //Update the description of task object
//  void updateTaskDescription() {
//    task.description = descriptionController.text;
//  }

  //Displays delete confirmation dialog so that the user has a choice to cancel their action or go through with it
  Future<void> _displayDeleteConfirmationDialog(
      TaskDao taskDao, Task task, BuildContext context) {
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
                final taskDao = Provider.of<TaskDao>(context, listen: false);
                taskDao.deleteTask(task);
                Navigator.of(context).pop();
                moveToPreviousScreen();
              },
            ),
          ],
        );
      },
    );
  }

  //This function will be called when someone tries to save or delete a task
  void _showAlertDialog(String message) {
    AlertDialog alertDialog = AlertDialog(
      backgroundColor: Color.fromRGBO(21, 32, 43, 1.0),
      content: Text(message),
    );
    showDialog(
        context: context,
        builder: (context) {
          Future.delayed(Duration(seconds: 1), () {
            Navigator.of(context).pop(true);
          });
          return alertDialog;
        });
  }

  StreamBuilder<List<TaskFolder>> _buildTaskFolderSelector(
      BuildContext context) {
    return StreamBuilder<List<TaskFolder>>(
      stream: Provider.of<TaskFolderDao>(context).watchAllTaskFolders(),
      builder: (context, snapshot) {
        final taskFolders = snapshot.data ?? List();
        DropdownMenuItem<TaskFolder> dropdownFromTaskFolder(
            TaskFolder taskFolder) {
          return DropdownMenuItem(
            value: taskFolder,
            child: Row(
              children: <Widget>[
                CircleAvatar(
                  backgroundColor: Color.fromRGBO(21, 32, 43, 1.0),
                  foregroundColor: Colors.orangeAccent[700],
                  child: Icon(Icons.folder),
                ),
                Text(taskFolder.title)
              ],
            ),
          );
        }

        final dropdownMenuItems = taskFolders
            .map((taskFolder) => dropdownFromTaskFolder(taskFolder))
            .toList()
              ..insert(
                0,
                DropdownMenuItem(
                  value: null,
                  child: Text('All Tasks'),
                ),
              );
        return Expanded(
          flex: 3,
          child: DropdownButton(
            icon: Icon(
              Icons.arrow_drop_down,
              color: Colors.orangeAccent[700],
            ),
            iconSize: 30,
            elevation: 16,
            dropdownColor: Color.fromRGBO(21, 32, 43, 1.0),
            style: TextStyle(color: Colors.orangeAccent[700]),
            onChanged: (taskFolder) {
              setState(() {
                selectedTaskFolder = taskFolder;
                taskFolder = taskFolderController;
              });
            },
            isExpanded: true,
            value: selectedTaskFolder,
            items: dropdownMenuItems,
          ),
        );
      },
    );
  }
}

import 'package:flutter/material.dart';
import 'dart:async';
import 'package:notetaker/Models/task.dart';
import 'package:intl/intl.dart';
import 'package:notetaker/Data/DatabaseHelper.dart';
import 'package:notetaker/screens/task_screen.dart';

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
  DatabaseHelper helper = DatabaseHelper();

  var _taskFormKey = GlobalKey<FormState>();

  String appBarTitle;
  Task task;

  TextEditingController titleController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();

  AddTaskScreenState(this.task, this.appBarTitle);

  @override
  Widget build(BuildContext context) {
    TextStyle textStyle = Theme.of(context).textTheme.title;

    descriptionController.text = task.description;

    return Scaffold(
      backgroundColor: Color.fromRGBO(21, 32, 43, 1.0),
      appBar: AppBar(
        backgroundColor: Color.fromRGBO(21, 32, 43, 1.0),
        title: Text(appBarTitle),
        iconTheme: IconThemeData(
          color: Colors.orangeAccent[700],
        ),
        actions: <Widget>[
          FlatButton(
            color: Color.fromRGBO(21, 32, 43, 1.0),
            child: Text(
              'Save',
              textScaleFactor: 1.5,
            ),
            textColor: Colors.orangeAccent[700],
            onPressed: () {
              setState(() {
                debugPrint('Save button clicked');
                if (_taskFormKey.currentState.validate()) {
                  _save();
                } else {
                  moveToPreviousScreen();
                  _showAlertDialog('Task must have a title. Task discarded');
                }
              });
            },
          ),
          IconButton(
            icon: Icon(Icons.delete_outline),
            color: Colors.orangeAccent[900],
            tooltip: 'Delete your task!',
            onPressed: () {
              setState(() {
                _displayDeleteConfirmationDialog(context);
              });
            },
          ),
        ],
      ),
      body: Form(
        key: _taskFormKey,
        child: Padding(
          padding: EdgeInsets.only(top: 15.0, left: 10.0, right: 10.0),
          child: ListView(
            children: <Widget>[
              Padding(
                padding: EdgeInsets.only(top: 15.0, bottom: 15.0),
                child: TextFormField(
                  validator: (String value) {
                    if (value.isEmpty) {
                      return 'Please enter a description';
                    }
                    return null;
                  },
                  controller: descriptionController,
                  maxLength: 100,
                  textCapitalization: TextCapitalization.sentences,
                  maxLines: null,
                  //style: textStyle,
                  style: TextStyle(
                    fontSize: 17.0,
                    color: Colors.white,
                  ),
                  cursorColor: Colors.orangeAccent[700],
                  autocorrect: true,
                  onChanged: (value) {
                    debugPrint(
                        'Something changed in description TextFormField');
                    updateTaskDescription();
                  },
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

  //Update the description of task object
  void updateTaskDescription() {
    task.description = descriptionController.text;
  }

  //Displays delete confirmation dialog so that the user has a choice to cancel their action or go through with it
  Future<void> _displayDeleteConfirmationDialog(BuildContext context) {
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
                _delete();
                Navigator.of(context).pop();
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => TaskScreen(),
                  ),
                ); // Close dialog
              },
            ),
          ],
        );
      },
    );
  }

  //Save data to database
  void _save() async {
    moveToPreviousScreen();
    task.date = DateFormat.yMMMd().format(DateTime.now());
    int result;
    //update operation
    if (task.id != null) {
      result = await helper.updateTask(task);
      //insert operation
    } else {
      result = await helper.insertTask(task);
    }

    if (result != 0) {
      _showAlertDialog('Task Saved Successfully!');
    } else {
      _showAlertDialog('Issue with Saving Task! Please Try again!');
    }
  }

  //Delete data from database
  void _delete() async {
    moveToPreviousScreen();
    //User tries to delete a new task which they have arrived at via pressing the FAB
    if (task.id == null) {
      _showAlertDialog('Successfully Discarded!');
      return;
    }

    //User tries to delete an old task that already has a valid ID and has been previously saved on the task screen
    int result = await helper.deleteTask(task.id);
    if (result != 0) {
      _showAlertDialog('Task Deleted Successfully!');
    } else {
      _showAlertDialog("Task Wasn't Successfully Deleted!");
    }
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
}

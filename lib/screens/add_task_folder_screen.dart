import 'package:flutter/material.dart';
import 'dart:async';
import 'package:notetaker/Models/taskFolder.dart';
import 'package:notetaker/Data/DatabaseHelper.dart';
import 'package:intl/intl.dart';
import 'package:sqflite/sqflite.dart';
import 'package:notetaker/screens/task_folder_screen.dart';

class FolderDetail extends StatefulWidget {
  final String appBarTitle;
  final TaskFolder folder;

  FolderDetail(this.folder, this.appBarTitle);

  @override
  State<StatefulWidget> createState() {
    return AddFolderScreenState(this.folder, this.appBarTitle);
  }
}

class AddFolderScreenState extends State<FolderDetail> {
  DatabaseHelper helper = DatabaseHelper();

  var _folderFormKey = GlobalKey<FormState>();

  String appBarTitle;
  TaskFolder folder;
  List<TaskFolder> folderList;
  int count = 0;

  TextEditingController titleController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();

  AddFolderScreenState(this.folder, this.appBarTitle);

  @override
  Widget build(BuildContext context) {
    TextStyle textStyle = Theme.of(context).textTheme.title;

    titleController.text = folder.title;

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
                if (_folderFormKey.currentState.validate()) {
                  _save();
                } else {
                  moveToPreviousScreen();
                  _showAlertDialog(
                      'Folder must have a title. Folder discarded');
                }
              });
            },
          ),
          IconButton(
            icon: Icon(Icons.delete_outline),
            color: Colors.orangeAccent[900],
            tooltip: 'Delete your folder!',
            onPressed: () {
              setState(() {
                _displayDeleteConfirmationDialog(context);
              });
            },
          ),
        ],
      ),
      body: Form(
        key: _folderFormKey,
        child: Padding(
          padding: EdgeInsets.only(top: 15.0, left: 10.0, right: 10.0),
          child: ListView(
            children: <Widget>[
              Padding(
                padding: EdgeInsets.only(top: 15.0, bottom: 15.0),
                child: TextFormField(
                  validator: (String value) {
                    if (value.isEmpty) {
                      return 'Please enter a Title';
                    }
                    return null;
                  },
                  controller: titleController,
                  maxLength: 100,
                  //style: textStyle,
                  style: TextStyle(
                    fontSize: 17.0,
                    color: Colors.white,
                  ),
                  textCapitalization: TextCapitalization.words,
                  maxLines: 1,
                  autocorrect: true,
                  onChanged: (value) {
                    debugPrint('Something change in Title TextField');
                    updateFolderTitle();
                  },
                  cursorColor: Colors.orangeAccent[700],
                  decoration: InputDecoration(
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: Color.fromRGBO(21, 32, 43, 1.0),
                      ),
                    ),
                    alignLabelWithHint: true,
                    fillColor: Color.fromRGBO(21, 32, 43, 1.0),
                    filled: true,
                    labelText: 'Folder Title',
                    labelStyle: TextStyle(
                      fontSize: 20.0,
                      color: Colors.grey,
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(1.0),
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

  //Update the title of Folder object
  void updateFolderTitle() {
    folder.title = titleController.text;
  }

  //Displays delete confirmation dialog so that the user has a choice to cancel their action or go through with it
  Future<void> _displayDeleteConfirmationDialog(BuildContext context) {
    return showDialog<void>(
      context: context,
      barrierDismissible: true, // Allow dismiss when tapping away from dialog
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Delete Folder"),
          content: Text("Are you sure you want to delete this folder?"),
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
                    builder: (context) => TaskFolderScreen(),
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
    folder.date = DateFormat.yMMMd().format(DateTime.now());
    int result;
    //update operation
    if (folder.id != null) {
      result = await helper.updateTaskFolder(folder);
      //insert operation
    } else {
      result = await helper.insertTaskFolder(folder);
    }

    if (result != 0) {
      _showAlertDialog('Folder Saved Successfully!');
    } else {
      _showAlertDialog('Issue with Saving Folder! Please Try again!');
    }
  }

  //Delete data from database
  void _delete() async {
    moveToPreviousScreen();
    //User tries to delete a new folder which they have arrived at via pressing the FAB
    if (folder.id == null) {
      _showAlertDialog('Folder Deleted!');
      return;
    }
    //User tries to delete an old folder that already has a valid ID and has been previously saved on the folder screen
    int result = await helper.deleteTaskFolder(folder.id);
    if (result != 0) {
      _showAlertDialog('Folder Deleted Successfully!');
    } else {
      _showAlertDialog("Folder Wasn't Successfully Deleted!");
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
        Future.delayed(
          Duration(seconds: 1),
          () {
            Navigator.of(context).pop(true);
          },
        );
        return alertDialog;
      },
    );
  }

  //When this function is called, it updates the list view so the user sees an updated screens
  void updateListView() {
    final Future<Database> dbFuture = helper.initializeNoteTakerDatabase();
    dbFuture.then((database) {
      Future<List<TaskFolder>> folderListFuture = helper.getTaskFolderList();
      folderListFuture.then((folderList) {
        setState(() {
          this.folderList = folderList;
          this.count = folderList.length;
        });
      });
    });
  }
}

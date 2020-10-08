import 'package:flutter/material.dart';
import 'dart:async';
import 'package:intl/intl.dart';
import 'package:notetaker/UI/note_folder_screen.dart';
import 'package:notetaker/Data/moor_database.dart';
import 'package:provider/provider.dart';

class NoteFolderDetail extends StatefulWidget {
  final String appBarTitle;
  final NoteFolder noteFolder;

  NoteFolderDetail(this.noteFolder, this.appBarTitle);

  @override
  State<StatefulWidget> createState() {
    return AddFolderScreenState(this.noteFolder, this.appBarTitle);
  }
}

class AddFolderScreenState extends State<NoteFolderDetail> {
  var _folderFormKey = GlobalKey<FormState>();
  NoteFolder noteFolder;
  NoteFolderDao noteFolderDao;

  String appBarTitle;
  int count = 0;

  TextEditingController titleController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();

  AddFolderScreenState(this.noteFolder, this.appBarTitle);

  @override
  Widget build(BuildContext context) {
    TextStyle textStyle = Theme.of(context).textTheme.title;

    titleController.text = noteFolder.title;

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
                _displayDeleteConfirmationDialog(
                    noteFolderDao, context, noteFolder);
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
//                  onChanged: (value) {
//                    debugPrint('Something change in Title TextField');
//                    updateFolderTitle();
//                  },
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

//  //Update the title of Folder object
//  void updateFolderTitle() {
//    noteFolder.title = titleController.text;
//  }

  //Displays delete confirmation dialog so that the user has a choice to cancel their action or go through with it
  Future<void> _displayDeleteConfirmationDialog(NoteFolderDao noteFolderDao,
      BuildContext context, NoteFolder noteFolder) {
    return showDialog<void>(
      context: context,
      barrierDismissible: true, // Allow dismiss when tapping away from dialog
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Delete Folder"),
          content: Text("Are you sure you want to delete this folder?"),
          actions: <Widget>[
            FlatButton(
              child: Text("Cancel"),
              onPressed: Navigator.of(context).pop, // Close dialog
            ),
            FlatButton(
              child: Text("Delete"),
              onPressed: () {
                _delete(noteFolderDao);
                Navigator.of(context).pop();
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => NoteFolderScreen(),
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
    int result;
    //update operation
    if (noteFolder.id != null) {
      result = await noteFolderDao.updateNoteFolder(noteFolder);
      //insert operation
    } else {
      result = await noteFolderDao.insertNoteFolder(noteFolder);
    }

    if (result != 0) {
      _showAlertDialog('Folder Saved Successfully!');
    } else {
      _showAlertDialog('Issue with Saving Folder! Please Try again!');
    }
  }

  //Delete data from database
  void _delete(NoteFolderDao noteFolderDao) async {
    moveToPreviousScreen();
    final noteFolderDao = Provider.of<NoteFolderDao>(context);
    //User tries to delete a new folder which they have arrived at via pressing the FAB
    if (noteFolder.id == null) {
      _showAlertDialog('Folder Deleted!');
      return;
    }
    //User tries to delete an old folder that already has a valid ID and has been previously saved on the folder screen
    int result = await noteFolderDao.deleteNoteFolder(noteFolder);
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
}

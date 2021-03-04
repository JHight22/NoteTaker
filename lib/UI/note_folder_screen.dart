import 'package:flutter/material.dart';
import 'package:notetaker/Widgets/navigation_drawer.dart';
import 'package:notetaker/UI/add_note_folder_screen.dart';
import 'package:notetaker/Models/noteFolder.dart';
import 'package:notetaker/Data/DatabaseHelper.dart';
import 'package:sqflite/sqflite.dart';
import 'dart:async';
import 'package:notetaker/Data/constants.dart';
import 'package:notetaker/UI/note_screen.dart';

class NoteFolderScreen extends StatefulWidget {
  static const String id = 'note_folder_screen';

  @override
  State<StatefulWidget> createState() {
    return NoteFolderScreenState();
  }
}

class NoteFolderScreenState extends State<NoteFolderScreen> {
  DatabaseHelper folderDatabaseHelper = DatabaseHelper();
  List<NoteFolder> folderList;
  int count = 0;

  @override
  Widget build(BuildContext context) {
    if (folderList == null) {
      folderList = <NoteFolder>[];
      updateListView();
    }

    return Scaffold(
      backgroundColor: Color.fromRGBO(21, 32, 43, 1.0),
      floatingActionButton: FloatingActionButton(
        foregroundColor: Colors.black,
        backgroundColor: Colors.orangeAccent[700],
        child: Icon(Icons.create_new_folder),
        onPressed: () {
          navigateToAddNoteFolderScreen(
              NoteFolder('', ''), 'Create Note Folder');
        },
      ),
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.orangeAccent[700]),
        backgroundColor: Color.fromRGBO(21, 32, 43, 1.0),
        title: const Text(
          'Note Folders',
          style: TextStyle(
            fontSize: 20.0,
          ),
        ),
      ),
      //drawer: NavigationDrawer(),
      body: Builder(
        builder: (BuildContext innerContext) => getNoteFolderListView(),
      ),
    );
  }

  ListView getNoteFolderListView() {
    return ListView.builder(
      itemCount: count,
      itemBuilder: (BuildContext context, int position) {
        return ListTile(
          leading: CircleAvatar(
            backgroundColor: Colors.orangeAccent[700],
            child: Icon(
              Icons.folder,
              color: Colors.black,
            ),
          ),
          title: Text(
            this.folderList[position].title,
          ),
          subtitle: Text(
            this.folderList[position].date,
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
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => NoteScreen(),
                settings: RouteSettings(arguments: folderList[position].id),
              ),
            );
          },
        );
      },
    );
  }

  //Gives the PopupMenuButton Widget functionality
  void choiceAction(EditAndDeletePopupMenuButton choice, int position) {
    setState(() {
      if (choice == EditAndDeletePopupMenuButton.choices[0]) {
        navigateToAddNoteFolderScreen(folderList[position], 'Edit Folder');
        updateListView();
      } else if (choice == EditAndDeletePopupMenuButton.choices[1]) {
        _displayDeleteConfirmationDialog(context, this.folderList[position]);
        updateListView();
      }
    });
  }

  //Displays delete confirmation dialog so that the user has a choice to cancel their action or go through with it
  Future<void> _displayDeleteConfirmationDialog(
      BuildContext context, NoteFolder noteFolder) {
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
                _delete(context, noteFolder);
                Navigator.of(context).pop(); // Close dialog
                updateListView();
              },
            ),
          ],
        );
      },
    );
  }

  //This function actually deletes folder from database
  void _delete(BuildContext context, NoteFolder noteFolder) async {
    int result = await folderDatabaseHelper.deleteNoteFolder(noteFolder.id);
    if (result != 0) {
      _presentSnackBar(context, 'Folder Deleted Successfully!');
      updateListView();
    }
  }

  void _presentSnackBar(BuildContext context, String message) {
    final snackBar = SnackBar(content: Text(message));
  }

  //When this function is called, it navigates the Folder screen to the Add Folder Screen
  void navigateToAddNoteFolderScreen(
      NoteFolder noteFolder, String title) async {
    bool result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) {
          return FolderDetail(noteFolder, title);
        },
      ),
    );
    if (result == true) {
      updateListView();
    }
  }

  //When this function is called, it updates the list view so the user sees an updated UI
  void updateListView() {
    final Future<Database> dbFuture =
        folderDatabaseHelper.initializeNoteTakerDatabase();
    dbFuture.then((database) {
      Future<List<NoteFolder>> noteFolderListFuture =
          folderDatabaseHelper.getNoteFolderList();
      noteFolderListFuture.then((folderList) {
        setState(() {
          this.folderList = folderList;
          this.count = folderList.length;
        });
      });
    });
  }
}

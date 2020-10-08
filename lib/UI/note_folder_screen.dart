import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:notetaker/Widgets/navigation_drawer.dart';
import 'package:notetaker/UI/add_note_folder_screen.dart';
import 'dart:async';
import 'package:notetaker/Data/constants.dart';
import 'package:notetaker/UI/note_screen.dart';
import 'package:notetaker/Data/moor_database.dart';
import 'package:provider/provider.dart';

class NoteFolderScreen extends StatefulWidget {
  static const String id = 'note_folder_screen';

  @override
  State<StatefulWidget> createState() {
    return NoteFolderScreenState();
  }
}

class NoteFolderScreenState extends State<NoteFolderScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromRGBO(21, 32, 43, 1.0),
      floatingActionButton: FloatingActionButton(
        foregroundColor: Colors.black,
        backgroundColor: Colors.orangeAccent[700],
        child: Icon(Icons.create_new_folder),
        onPressed: () {
          navigateToAddNoteFolderScreen(NoteFolder(), 'Create Folder');
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
      drawer: NavigationDrawer(),
      body: Builder(
        builder: (BuildContext innerContext) => _buildNoteFolderList(context),
      ),
    );
  }

  StreamBuilder<List<NoteFolder>> _buildNoteFolderList(BuildContext context) {
    final noteFolderDao = Provider.of<NoteFolderDao>(context);
    return StreamBuilder(
      stream: noteFolderDao.watchAllNoteFolders(),
      builder: (context, AsyncSnapshot<List<NoteFolder>> snapshot) {
        final noteFolders = snapshot.data ?? List();
        return ListView.builder(
          itemCount: noteFolders.length,
          itemBuilder: (_, index) {
            final itemNoteFolder = noteFolders[index];
            return _buildListItem(itemNoteFolder, noteFolderDao);
          },
        );
      },
    );
  }

  Widget _buildListItem(NoteFolder noteFolder, NoteFolderDao noteFolderDao) {
    var newFormat = DateFormat("MM-dd-yyyy");
    String updatedDt = newFormat.format(noteFolder.date);

    return ListTile(
      leading: CircleAvatar(
        backgroundColor: Colors.orangeAccent[700],
        child: Icon(
          Icons.folder,
          color: Colors.black,
        ),
      ),
      title: Text(
        noteFolder.title,
      ),
      subtitle: Text(
        updatedDt,
      ),
      trailing: PopupMenuButton<EditAndDeletePopupMenuButton>(
        color: Color.fromRGBO(21, 32, 43, 1.0),
        icon: Icon(
          Icons.more_vert,
          color: Colors.orangeAccent[700],
        ),
        onSelected: (choice) => choiceAction(noteFolderDao, choice, noteFolder),
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
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => NoteScreen(),
          ),
        );
      },
    );
  }

  //Gives the PopupMenuButton Widget functionality
  void choiceAction(
      NoteFolderDao noteFolderDao, choice, NoteFolder noteFolder) {
    setState(() {
      if (choice == EditAndDeletePopupMenuButton.choices[0]) {
        navigateToAddNoteFolderScreen(noteFolder, 'Edit Task');
      } else if (choice == EditAndDeletePopupMenuButton.choices[1]) {
        _displayDeleteConfirmationDialog(noteFolderDao, context, noteFolder);
      }
    });
  }

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
                final noteFolderDao =
                    Provider.of<NoteFolderDao>(context, listen: false);
                noteFolderDao.deleteNoteFolder(noteFolder);
                Navigator.of(context).pop(); // Close dialog
              },
            ),
          ],
        );
      },
    );
  }

  void _presentSnackBar(BuildContext context, String message) {
    final snackBar = SnackBar(content: Text(message));
  }

  //When this function is called, it navigates the Folder screen to the Add Folder Screen
  void navigateToAddNoteFolderScreen(NoteFolder folder, String title) async {
    bool result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) {
          return NoteFolderDetail(folder, title);
        },
      ),
    );
    if (result == true) {}
  }
}

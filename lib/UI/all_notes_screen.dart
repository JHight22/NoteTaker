import 'package:flutter/material.dart';
import 'package:notetaker/Widgets/navigation_drawer.dart';
import 'package:notetaker/UI/add_note_screen.dart';
import 'package:notetaker/Models/note.dart';
import 'package:notetaker/Data/DatabaseHelper.dart';
import 'package:sqflite/sqflite.dart';
import 'dart:async';

class AllNotesScreen extends StatefulWidget {
  static const String id = 'all_notes_screen';

  @override
  State<StatefulWidget> createState() {
    return AllNotesScreenState();
  }
}

class AllNotesScreenState extends State<AllNotesScreen> {
  DatabaseHelper noteDatabaseHelper = DatabaseHelper();
  List<Note> noteList;
  int count = 0;
  Note note;

  @override
  Widget build(BuildContext context) {
    if (noteList == null) {
      noteList = <Note>[];
      updateListView();
    }

    return Scaffold(
      backgroundColor: Color.fromRGBO(21, 32, 43, 1.0),
      floatingActionButton: FloatingActionButton(
        foregroundColor: Colors.black,
        backgroundColor: Colors.orangeAccent[700],
        child: Icon(Icons.note),
        onPressed: () {
          navigateToAddNoteScreen(Note('', '', ''), 'Create Note');
        },
      ),
      appBar: AppBar(
        elevation: 1,
        iconTheme: IconThemeData(color: Colors.orangeAccent[700]),
        backgroundColor: Color.fromRGBO(21, 32, 43, 1.0),
        title: const Text(
          'All Notes',
          style: TextStyle(
            fontSize: 20.0,
          ),
        ),
      ),
      //drawer: NavigationDrawer(),
      body: Builder(
        builder: (BuildContext innerContext) => getNoteListView(),
      ),
    );
  }

  ListView getNoteListView() {
    return ListView.builder(
      itemCount: count,
      itemBuilder: (BuildContext context, int position) {
        return Card(
          color: Color.fromRGBO(21, 32, 43, 1.0),
          elevation: 0,
          child: ListTile(
//            leading: ConstrainedBox(
//              constraints: BoxConstraints(
//                maxHeight: 100,
//                minHeight: 100,
//                maxWidth: 100,
//                minWidth: 100,
//              ),
//              child: Image.asset(
//                this.noteList[position].image,
//                fit: BoxFit.cover,
//              ),
//            ),
            title: Text(
              this.noteList[position].title,
            ),
            subtitle: Text(
              this.noteList[position].description,
            ),
            trailing: GestureDetector(
              child: Icon(
                Icons.delete,
                color: Colors.orangeAccent[700],
              ),
              onTap: () {
                _displayDeleteConfirmationDialog(
                    context, this.noteList[position]);
                updateListView();
              },
            ),
            onTap: () {
              debugPrint('ListTile tapped');
              navigateToAddNoteScreen(this.noteList[position], 'Create Note');
            },
          ),
        );
      },
    );
  }

  //Displays delete confirmation dialog so that the user has a choice to cancel their action or go through with it
  Future<void> _displayDeleteConfirmationDialog(
      BuildContext context, Note note) {
    return showDialog<void>(
        context: context,
        barrierDismissible: true, // Allow dismiss when tapping away from dialog
        builder: (BuildContext context) {
          return AlertDialog(
            backgroundColor: Color.fromRGBO(21, 32, 43, 1.0),
            title: Text("Delete Note"),
            content: Text("Are you sure you want to delete this note?"),
            actions: <Widget>[
              TextButton(
                child: Text("Cancel"),
                onPressed: Navigator.of(context).pop, // Close dialog
              ),
              TextButton(
                child: Text("Delete"),
                onPressed: () {
                  _delete(context, note);
                  Navigator.of(context).pop(); // Close dialog
                  updateListView();
                },
              ),
            ],
          );
        });
  }

  void _delete(BuildContext context, Note note) async {
    int result = await noteDatabaseHelper.deleteNote(note.id);
    if (result != 0) {
      _presentSnackBar(context, 'Note Deleted Successfully!');
      updateListView();
    }
  }

  void _presentSnackBar(BuildContext context, String message) {
    final snackBar = SnackBar(content: Text(message));
  }

  //When this function is called, it navigates the note screen to the add note screen
  void navigateToAddNoteScreen(Note note, String title) async {
    bool result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) {
          return NoteDetail(note, title);
        },
      ),
    );
    if (result == true) {
      updateListView();
    }
  }

  void updateListView() {
    final Future<Database> dbFuture =
        noteDatabaseHelper.initializeNoteTakerDatabase();
    dbFuture.then((database) {
      Future<List<Note>> noteListFuture = noteDatabaseHelper.getNoteList();
      noteListFuture.then((noteList) {
        setState(() {
          this.noteList = noteList;
          this.count = noteList.length;
        });
      });
    });
  }
}

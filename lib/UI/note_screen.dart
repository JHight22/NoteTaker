import 'package:flutter/material.dart';
import 'package:notetaker/Widgets/navigation_drawer.dart';
import 'package:notetaker/UI/add_note_screen.dart';
import 'dart:async';
import 'package:notetaker/Data/moor_database.dart';
import 'package:provider/provider.dart';

class NoteScreen extends StatefulWidget {
  static const String id = 'note_screen';

  @override
  State<StatefulWidget> createState() {
    return NoteScreenState();
  }
}

class NoteScreenState extends State<NoteScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromRGBO(21, 32, 43, 1.0),
      floatingActionButton: FloatingActionButton(
        foregroundColor: Colors.black,
        backgroundColor: Colors.orangeAccent[700],
        child: Icon(Icons.note),
        onPressed: () {
          navigateToAddNoteScreen(Note(), 'Create Note');
        },
      ),
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.orangeAccent[700]),
        backgroundColor: Color.fromRGBO(21, 32, 43, 1.0),
        title: const Text(
          'All Notes',
          style: TextStyle(
            fontSize: 20.0,
          ),
        ),
      ),
      drawer: NavigationDrawer(),
      body: Builder(
        builder: (BuildContext innerContext) => _buildNoteList(context),
      ),
    );
  }

  StreamBuilder<List<Note>> _buildNoteList(BuildContext context) {
    final noteDao = Provider.of<NoteDao>(context);
    return StreamBuilder(
      stream: noteDao.watchAllNotes(),
      builder: (context, AsyncSnapshot<List<Note>> snapshot) {
        final notes = snapshot.data ?? List();
        return ListView.builder(
          itemCount: notes.length,
          itemBuilder: (_, index) {
            final itemNote = notes[index];
            return _buildListItem(itemNote, noteDao);
          },
        );
      },
    );
  }

  Widget _buildListItem(Note itemNote, NoteDao noteDao) {
    return Card(
      color: Color.fromRGBO(21, 32, 43, 1.0),
      elevation: 0,
      child: ListTile(
        title: Text(itemNote.title),
        subtitle: Text(itemNote.description),
        trailing: GestureDetector(
          child: Icon(
            Icons.delete_outline,
            color: Colors.orangeAccent[700],
          ),
          onTap: () =>
              _displayDeleteConfirmationDialog(noteDao, context, itemNote),
        ),
        onTap: () {
          debugPrint('Listtile tapped');
          navigateToAddNoteScreen(itemNote, 'Edit Note');
        },
      ),
    );
  }

  //Displays delete confirmation dialog so that the user has a choice to cancel their action or go through with it
  Future<void> _displayDeleteConfirmationDialog(
      NoteDao noteDao, BuildContext context, itemNote) {
    return showDialog<void>(
        context: context,
        barrierDismissible: true, // Allow dismiss when tapping away from dialog
        builder: (BuildContext context) {
          return AlertDialog(
            backgroundColor: Color.fromRGBO(21, 32, 43, 1.0),
            title: Text("Delete Note"),
            content: Text("Are you sure you want to delete this note?"),
            actions: <Widget>[
              FlatButton(
                child: Text("Cancel"),
                onPressed: Navigator.of(context).pop, // Close dialog
              ),
              FlatButton(
                child: Text("Delete"),
                onPressed: () {
                  final noteDao = Provider.of<NoteDao>(context);
                  noteDao.deleteNote(itemNote);
                  Navigator.of(context).pop(); // Close dialog
                },
              ),
            ],
          );
        });
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
    if (result == true) {}
  }
}

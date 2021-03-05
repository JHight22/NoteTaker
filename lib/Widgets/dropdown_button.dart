import 'dart:async';
import 'package:flutter/material.dart';
import 'package:notetaker/Models/noteFolder.dart';
import 'package:notetaker/Data/DatabaseHelper.dart';
import 'package:sqflite/sqflite.dart';
import 'package:notetaker/Models/note.dart';

class DropdownButtonFolders extends StatefulWidget {
  DropdownButtonFolders(int folderId);

  @override
  State<StatefulWidget> createState() {
    return DropdownButtonState();
  }
}

class DropdownButtonState extends State<DropdownButtonFolders> {
  DatabaseHelper folderDatabaseHelper = DatabaseHelper();
  List<NoteFolder> folderList;
  int count = 0;
  NoteFolder noteFolder;
  Note note;
  String selectedFolder;

  @override
  Widget build(BuildContext context) {
    if (folderList == null) {
      folderList = <NoteFolder>[];
      updateListView();
    }

    return DropdownButtonHideUnderline(
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: DropdownButton<NoteFolder>(
          value: noteFolder,
          isExpanded: false,
          icon: Icon(
            Icons.arrow_drop_down,
            color: Colors.orangeAccent[700],
          ),
          dropdownColor: Color.fromRGBO(21, 32, 43, 1.0),
          iconSize: 30,
          elevation: 16,
          style: TextStyle(color: Colors.orangeAccent[700]),
          items: folderList.map((NoteFolder folder) {
            return DropdownMenuItem<NoteFolder>(
              value: noteFolder,
              child: Row(
                children: <Widget>[
                  CircleAvatar(
                    backgroundColor: Color.fromRGBO(21, 32, 43, 1.0),
                    foregroundColor: Colors.orangeAccent[700],
                    child: Icon(Icons.folder),
                  ),
                  Text(folder.title),
                ],
              ),
            );
          }).toList(),
          hint: Text('All Notes'),
          onChanged: (selectedFolder) {
            setState(() {
              noteFolder.title;
            });
          },
        ),
      ),
    );
  }

  //When this function is called, it updates the list view so the user sees an updated screens
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

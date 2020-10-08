//import 'dart:async';
//import 'package:flutter/material.dart';
//import 'package:notetaker/Data/moor_database.dart';
//import 'package:provider/provider.dart';
//import 'package:notetaker/UI/note_folder_screen.dart';
//
//class DropdownButtonNoteFolders extends StatefulWidget {
//  @override
//  State<StatefulWidget> createState() {
//    return DropdownButtonState();
//  }
//}
//
//class DropdownButtonState extends State<DropdownButtonNoteFolders> {
//  @override
//  Widget build(BuildContext context) {
//    NoteFolder itemNoteFolder;
//
//    return DropdownButtonHideUnderline(
//      child: SingleChildScrollView(
//        scrollDirection: Axis.horizontal,
//        child: DropdownButton<NoteFolder>(
//          value: itemNoteFolder,
//          isExpanded: false,
//          icon: Icon(
//            Icons.arrow_drop_down,
//            color: Colors.orangeAccent[700],
//          ),
//          dropdownColor: Color.fromRGBO(21, 32, 43, 1.0),
//          iconSize: 30,
//          elevation: 16,
//          style: TextStyle(color: Colors.orangeAccent[700]),
//          items: _buildNoteFolderList.map((NoteFolder itemNoteFolder) {
//            return DropdownMenuItem<NoteFolder>(
//              value: itemNoteFolder,
//              child: Row(
//                children: <Widget>[
//                  CircleAvatar(
//                    backgroundColor: Color.fromRGBO(21, 32, 43, 1.0),
//                    foregroundColor: Colors.orangeAccent[700],
//                    child: Icon(Icons.folder),
//                  ),
//                  Text(itemNoteFolder.title),
//                ],
//              ),
//            );
//          }).toList(),
//          hint: Text('All Notes'),
//          onChanged: (NoteFolder selectedFolder) {
//            setState(() {
//              itemNoteFolder = selectedFolder;
//            });
//          },
//        ),
//      ),
//    );
//  }
//
////  //Save data to database
////  //TODO: Finish this!
////  void _save(Folder folder, Note note) async {
////    int result;
////    //update operation
////    if (folder.id != note.folderId) {
////      note.folderId = folder.id;
////      result = await folderDatabaseHelper.updateNote(note);
////    } else {
////      note.folderId = folder.id;
////      result = await folderDatabaseHelper.updateNote(note);
////    }
////    if (result != 0) {
////    } else {}
////  }
//
//}

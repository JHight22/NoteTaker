import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:notetaker/UI/all_tasks_screen.dart';
import 'package:notetaker/UI/note_folder_screen.dart';
import 'package:notetaker/UI/all_notes_screen.dart';
import 'package:notetaker/UI/note_screen.dart';
import 'package:notetaker/UI/task_folder_screen.dart';
import 'package:notetaker/UI/task_screen.dart';
import 'package:notetaker/Widgets/BottomNavigationBar.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'NoteTaker',
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark(
          //       primaryColors: Color.fromRGBO(21, 32, 43, 1.0),
//        accentColor: Colors.orangeAccent[700],
          ),
      home: BottomNavigationBarWidget(),
      routes: {
        AllTasksScreen.id: (context) => AllTasksScreen(),
        AllNotesScreen.id: (context) => AllNotesScreen(),
        NoteFolderScreen.id: (context) => NoteFolderScreen(),
        NoteScreen.id: (context) => NoteScreen(),
        TaskFolderScreen.id: (context) => TaskFolderScreen(),
        TaskScreen.id: (context) => TaskScreen(),
      },
    );
  }
}

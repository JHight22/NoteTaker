import 'package:flutter/material.dart';
import 'package:notetaker/Data/moor_database.dart';
import 'package:notetaker/UI/all_tasks_screen.dart';
import 'package:notetaker/UI/note_folder_screen.dart';
import 'package:notetaker/UI/all_notes_screen.dart';
import 'package:notetaker/UI/note_screen.dart';
import 'package:provider/provider.dart';
import 'package:notetaker/UI/task_folder_screen.dart';
import 'package:notetaker/UI/task_screen.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider(
          create: (context) => NoteTakerDatabase().noteDao,
          lazy: false,
          dispose: (context, db) => db.close(),
        ),
        Provider(
          create: (context) => NoteTakerDatabase().taskDao,
          lazy: false,
          dispose: (context, db) => db.close(),
        ),
        Provider(
          create: (context) => NoteTakerDatabase().noteFolderDao,
          lazy: false,
          dispose: (context, db) => db.close(),
        ),
        Provider(
          create: (context) => NoteTakerDatabase().taskFolderDao,
          lazy: false,
          dispose: (context, db) => db.close(),
        ),
      ],
      child: MaterialApp(
        title: 'NoteTaker',
        debugShowCheckedModeBanner: false,
        theme: ThemeData.dark(
//        primaryColor: Color.fromRGBO(21, 32, 43, 1.0),
//        accentColor: Colors.orangeAccent[700],
            ),
        home: AllNotesScreen(),
        routes: {
          AllTasksScreen.id: (context) => AllTasksScreen(),
          AllNotesScreen.id: (context) => AllNotesScreen(),
          NoteFolderScreen.id: (context) => NoteFolderScreen(),
          NoteScreen.id: (context) => NoteScreen(),
          TaskFolderScreen.id: (context) => TaskFolderScreen(),
          TaskScreen.id: (context) => TaskScreen(),
        },
      ),
    );
  }
}

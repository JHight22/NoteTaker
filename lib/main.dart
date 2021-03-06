import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:notetaker/controllers/authController.dart';
import 'package:notetaker/controllers/bindings/authBinding.dart';
import 'package:notetaker/screens/all_tasks_screen.dart';
import 'package:notetaker/screens/note_folder_screen.dart';
import 'package:notetaker/screens/all_notes_screen.dart';
import 'package:notetaker/screens/note_screen.dart';
import 'package:notetaker/screens/task_folder_screen.dart';
import 'package:notetaker/screens/task_screen.dart';
import 'package:notetaker/Widgets/BottomNavigationBar.dart';
import 'package:notetaker/screens/login.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'NoteTaker',
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark(
          //       primaryColors: Color.fromRGBO(21, 32, 43, 1.0),
//        accentColor: Colors.orangeAccent[700],
          ),
      initialBinding: AuthBinding(),
      home: (Get.put(AuthController()).user != null)
          ? BottomNavigationBarWidget()
          : Login(),
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

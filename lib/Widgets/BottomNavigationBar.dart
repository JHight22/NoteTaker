import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:notetaker/controllers/bottomNavigationController.dart';
import 'package:notetaker/screens/allNotesScreen.dart';
import 'package:notetaker/screens/allTasksScreen.dart';
import 'package:notetaker/screens/noteFolderScreen.dart';
import 'package:notetaker/screens/taskFolderScreen.dart';

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GetBuilder<BottomNavigationController>(
        init: BottomNavigationController(),
        builder: (s) => IndexedStack(
          index: s.selectedIndex,
          children: <Widget>[
            AllNotesScreen(),
            AllTasksScreen(),
            NoteFolderScreen(),
            TaskFolderScreen(),
          ],
        ),
      ),
      bottomNavigationBar: CoolBottomNavigationBar(),
    );
  }
}

class CoolBottomNavigationBar extends StatelessWidget {
  const CoolBottomNavigationBar({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetBuilder<BottomNavigationController>(
      builder: (s) => BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            backgroundColor: Colors.black,
            icon: Icon(Icons.note),
            label: 'All Notes',
          ),
          BottomNavigationBarItem(
            backgroundColor: Colors.black,
            icon: Icon(Icons.content_paste),
            label: 'All Tasks',
          ),
          BottomNavigationBarItem(
            backgroundColor: Colors.black,
            icon: Icon(Icons.folder),
            label: 'Note Folders',
          ),
          BottomNavigationBarItem(
            backgroundColor: Colors.black,
            icon: Icon(Icons.folder_open),
            label: 'Task Folders',
          ),
        ],
        currentIndex: s.selectedIndex,
        unselectedItemColor: Colors.orangeAccent[700],
        selectedItemColor: Colors.orangeAccent[700],
        onTap: (index) => s.onItemTapped(index),
        showSelectedLabels: true,
        showUnselectedLabels: false,
        elevation: 10,
      ),
    );
  }
}

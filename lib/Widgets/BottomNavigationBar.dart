import 'package:flutter/material.dart';
import 'package:notetaker/screens/all_tasks_screen.dart';
import 'package:notetaker/screens/all_notes_screen.dart';
import 'package:notetaker/screens/note_folder_screen.dart';
import 'package:notetaker/screens/task_folder_screen.dart';

class BottomNavigationBarWidget extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _BottomNavigationBarWidget();
  }
}

class _BottomNavigationBarWidget extends State<BottomNavigationBarWidget> {
  int _currentIndex = 0;
  final List<Widget> _children = [
    AllNotesScreen(),
    AllTasksScreen(),
    NoteFolderScreen(),
    TaskFolderScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _children[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Color.fromRGBO(21, 32, 43, 1.0),
        onTap: onTabTapped,
        currentIndex: _currentIndex,
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.note),
            label: 'All Notes',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.content_paste),
            label: 'All Tasks',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.folder),
            label: 'Note Folders',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.folder_open),
            label: 'Task Folders',
          ),
        ],
        selectedItemColor: Colors.orangeAccent[700],
        unselectedItemColor: Colors.orangeAccent[700],
      ),
    );
  }

  void onTabTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }
}

import 'package:flutter/material.dart';
import 'package:notetaker/UI/all_tasks_screen.dart';
import 'package:notetaker/UI/all_notes_screen.dart';
import 'package:notetaker/UI/note_folder_screen.dart';
import 'package:notetaker/UI/task_folder_screen.dart';

class NavigationDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          DrawerHeader(
            decoration: BoxDecoration(
              color: Colors.orangeAccent[700],
            ),
            child: Text(
              'NoteTaker',
              style: TextStyle(
                color: Colors.black,
                fontSize: 24,
              ),
            ),
          ),
          ListTile(
            leading: Icon(
              Icons.note,
              color: Colors.orangeAccent[700],
            ),
            title: Text('All Notes'),
            trailing: Icon(
              Icons.arrow_right,
            ),
            onTap: () {
              Navigator.of(context).pop();
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => AllNotesScreen()));
            },
          ),
          Divider(),
          ListTile(
            leading: Icon(
              Icons.content_paste,
              color: Colors.orangeAccent[700],
            ),
            title: Text('All Tasks'),
            trailing: Icon(
              Icons.arrow_right,
            ),
            onTap: () {
              Navigator.of(context).pop();
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => AllTasksScreen()));
            },
          ),
          Divider(),
          ListTile(
            leading: Icon(
              Icons.folder,
              color: Colors.orangeAccent[700],
            ),
            title: Text('Note Folders'),
            trailing: Icon(
              Icons.arrow_right,
            ),
            onTap: () {
              Navigator.of(context).pop();
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => NoteFolderScreen()));
            },
          ),
          Divider(),
          ListTile(
            leading: Icon(
              Icons.folder,
              color: Colors.orangeAccent[700],
            ),
            title: Text('Task Folders'),
            trailing: Icon(
              Icons.arrow_right,
            ),
            onTap: () {
              Navigator.of(context).pop();
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => TaskFolderScreen()));
            },
          )
        ],
      ),
    );
  }
}

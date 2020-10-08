import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:notetaker/Widgets/navigation_drawer.dart';
import 'package:notetaker/UI/add_task_folder_screen.dart';
import 'dart:async';
import 'package:notetaker/Data/constants.dart';
import 'package:notetaker/Data/moor_database.dart';
import 'package:provider/provider.dart';
import 'package:notetaker/UI/task_screen.dart';

class TaskFolderScreen extends StatefulWidget {
  static const String id = 'task_folder_screen';

  @override
  State<StatefulWidget> createState() {
    return TaskFolderScreenState();
  }
}

class TaskFolderScreenState extends State<TaskFolderScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromRGBO(21, 32, 43, 1.0),
      floatingActionButton: FloatingActionButton(
        foregroundColor: Colors.black,
        backgroundColor: Colors.orangeAccent[700],
        child: Icon(Icons.create_new_folder),
        onPressed: () {
          navigateToAddTaskFolderScreen(TaskFolder(), 'Create Folder');
        },
      ),
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.orangeAccent[700]),
        backgroundColor: Color.fromRGBO(21, 32, 43, 1.0),
        title: const Text(
          'Task Folders',
          style: TextStyle(
            fontSize: 20.0,
          ),
        ),
      ),
      drawer: NavigationDrawer(),
      body: Builder(
        builder: (BuildContext innerContext) => _buildTaskFolderList(context),
      ),
    );
  }

  StreamBuilder<List<TaskFolder>> _buildTaskFolderList(BuildContext context) {
    final taskFolderDao = Provider.of<TaskFolderDao>(context);
    return StreamBuilder(
      stream: taskFolderDao.watchAllTaskFolders(),
      builder: (context, AsyncSnapshot<List<TaskFolder>> snapshot) {
        final taskFolders = snapshot.data ?? List();
        return ListView.builder(
          itemCount: taskFolders.length,
          itemBuilder: (_, index) {
            final itemTaskFolder = taskFolders[index];
            return _buildListItem(itemTaskFolder, taskFolderDao);
          },
        );
      },
    );
  }

  Widget _buildListItem(TaskFolder taskFolder, TaskFolderDao taskFolderDao) {
    var newFormat = DateFormat("MM-dd-yyyy");
    String updatedDt = newFormat.format(taskFolder.date);

    return ListTile(
      leading: CircleAvatar(
        backgroundColor: Colors.orangeAccent[700],
        child: Icon(
          Icons.folder,
          color: Colors.black,
        ),
      ),
      title: Text(
        taskFolder.title,
      ),
      subtitle: Text(
        updatedDt,
      ),
      trailing: PopupMenuButton<EditAndDeletePopupMenuButton>(
        color: Color.fromRGBO(21, 32, 43, 1.0),
        icon: Icon(
          Icons.more_vert,
          color: Colors.orangeAccent[700],
        ),
        onSelected: (choice) => choiceAction(taskFolderDao, choice, taskFolder),
        captureInheritedThemes: true,
        itemBuilder: (BuildContext context) {
          return EditAndDeletePopupMenuButton.choices
              .map((EditAndDeletePopupMenuButton editAndDeletePopupMenuButton) {
            return PopupMenuItem<EditAndDeletePopupMenuButton>(
              value: editAndDeletePopupMenuButton,
              child: ListTile(
                leading: CircleAvatar(
                  backgroundColor: Color.fromRGBO(21, 32, 43, 1.0),
                  foregroundColor: Colors.orangeAccent[700],
                  child: editAndDeletePopupMenuButton.icon,
                ),
                title: Text(
                  editAndDeletePopupMenuButton.title,
                  style: TextStyle(
                    color: Colors.orangeAccent[700],
                  ),
                ),
              ),
            );
          }).toList();
        },
      ),
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => TaskScreen(),
          ),
        );
      },
    );
  }

  //Gives the PopupMenuButton Widget functionality
  void choiceAction(
      TaskFolderDao taskFolderDao, choice, TaskFolder taskFolder) {
    setState(
      () {
        if (choice == EditAndDeletePopupMenuButton.choices[0]) {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => TaskScreen(),
            ),
          );
        } else if (choice == EditAndDeletePopupMenuButton.choices[1]) {
          navigateToAddTaskFolderScreen(taskFolder, 'Edit Task');
        } else if (choice == EditAndDeletePopupMenuButton.choices[2]) {
          _displayDeleteConfirmationDialog(taskFolderDao, context, taskFolder);
        }
      },
    );
  }

  //Displays delete confirmation dialog so that the user has a choice to cancel their action or go through with it
  Future<void> _displayDeleteConfirmationDialog(TaskFolderDao taskFolderDao,
      BuildContext context, TaskFolder taskFolder) {
    return showDialog<void>(
      context: context,
      barrierDismissible: true, // Allow dismiss when tapping away from dialog
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Delete Folder"),
          content: Text("Are you sure you want to delete this folder?"),
          actions: <Widget>[
            FlatButton(
              child: Text("Cancel"),
              onPressed: Navigator.of(context).pop, // Close dialog
            ),
            FlatButton(
              child: Text("Delete"),
              onPressed: () {
                final taskFolderDao =
                    Provider.of<TaskFolderDao>(context, listen: false);
                taskFolderDao.deleteTaskFolder(taskFolder);
                Navigator.of(context).pop(); // Close dialog
              },
            ),
          ],
        );
      },
    );
  }

  void _presentSnackBar(BuildContext context, String message) {
    final snackBar = SnackBar(content: Text(message));
  }

  //When this function is called, it navigates the Folder screen to the Add Folder Screen
  void navigateToAddTaskFolderScreen(
      TaskFolder taskFolder, String title) async {
    bool result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) {
          return TaskFolderDetail(taskFolder, title);
        },
      ),
    );
    if (result == true) {}
  }
}

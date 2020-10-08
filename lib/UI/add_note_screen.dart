import 'dart:io';
import 'package:flutter/material.dart';
import 'package:notetaker/Data/moor_database.dart';
import 'dart:async';
import 'package:intl/intl.dart';
import 'package:notetaker/UI/all_notes_screen.dart';
import 'package:image_picker/image_picker.dart';
import 'package:notetaker/Data/constants.dart';
import 'package:notetaker/Widgets/dropdown_button.dart';
import 'package:provider/provider.dart';

class NoteDetail extends StatefulWidget {
  final String appBarTitle;
  final Note note;

  NoteDetail(this.note, this.appBarTitle);

  @override
  State<StatefulWidget> createState() {
    return AddNoteScreenState(this.note, this.appBarTitle);
  }
}

class AddNoteScreenState extends State<NoteDetail> {
  File _selectImage;
  final imagePicker = ImagePicker();
  NoteDao noteDao;

  Future getImage() async {
    final image = await imagePicker.getImage(source: ImageSource.gallery);
    setState(() {
      _selectImage = File(image.path);
    });
  }

  //TODO: Finish this!!
  //Uint8List galleryImageInBytes = _selectImage.readAsBytesSync();

  File _takeImage;
  final imageTaker = ImagePicker();

  Future takeImage() async {
    final image = await imageTaker.getImage(source: ImageSource.camera);
    setState(() {
      _takeImage = File(image.path);
    });
  }

  var _noteFormKey = GlobalKey<FormState>();

  String appBarTitle;
  Note note;
  NoteFolder selectedNoteFolder;

  TextEditingController titleController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  TextEditingController imageController = TextEditingController();

  AddNoteScreenState(this.note, this.appBarTitle);

  @override
  Widget build(BuildContext context) {
    TextStyle textStyle = Theme.of(context).textTheme.headline6;

    titleController.text = note.title;
    descriptionController.text = note.description;
    //imageController.text = note.image;

    return Scaffold(
      backgroundColor: Color.fromRGBO(21, 32, 43, 1.0),
      appBar: AppBar(
        iconTheme: IconThemeData(
          color: Colors.orangeAccent[700],
        ),
        backgroundColor: Color.fromRGBO(21, 32, 43, 1.0),
        //title: _buildNoteFolderSelector(context),
        actions: <Widget>[
          _buildNoteFolderSelector(context),
          PopupMenuButton<NotePopupMenuButton>(
            icon: Icon(Icons.add),
            elevation: 16,
            onSelected: (choice) => choiceAction(choice),
            color: Color.fromRGBO(21, 32, 43, 1.0),
            captureInheritedThemes: true,
            itemBuilder: (BuildContext context) {
              return NotePopupMenuButton.choices
                  .map((NotePopupMenuButton notePopupMenuButton) {
                return PopupMenuItem<NotePopupMenuButton>(
                  value: notePopupMenuButton,
                  child: ListTile(
                    leading: notePopupMenuButton.icon,
                    title: Text(notePopupMenuButton.title),
                    trailing: Icon(Icons.chevron_right),
                  ),
                );
              }).toList();
            },
          ),
          FlatButton(
            color: Color.fromRGBO(21, 32, 43, 1.0),
            child: Text(
              'Save',
              textScaleFactor: 1.5,
            ),
            textColor: Colors.orangeAccent[700],
            onPressed: () {
              setState(() {
                debugPrint('Save button clicked');
                if (_noteFormKey.currentState.validate()) {
                  _save();
                } else {
                  moveToPreviousScreen();
                  _showAlertDialog(
                      'Note must have a title and description. Note discarded');
                }
              });
            },
          ),
          IconButton(
            icon: Icon(Icons.delete_outline),
            color: Colors.orangeAccent[900],
            tooltip: 'Delete your note!',
            onPressed: () {
              setState(() {
                _displayDeleteConfirmationDialog(noteDao, context, note);
              });
            },
          ),
        ],
      ),
      body: Form(
        key: _noteFormKey,
        child: Padding(
          padding: EdgeInsets.only(top: 15.0, left: 5.0, right: 5.0),
          child: ListView(
            children: <Widget>[
              Padding(
                padding: EdgeInsets.only(top: 5.0, bottom: 5.0),
                child: TextFormField(
                  style: TextStyle(
                    fontSize: 17.0,
                    color: Colors.white,
                  ),
                  validator: (String value) {
                    if (value.isEmpty) {
                      return 'Please enter a Title';
                    }
                    return null;
                  },
                  controller: titleController,
                  //style: textStyle,
                  textCapitalization: TextCapitalization.words,
                  maxLength: 100,
                  maxLines: 1,
                  autocorrect: true,
//                  onChanged: (value) {
//                    debugPrint('Something change in Title TextField');
//                    updateNoteTitle();
//                  },
                  cursorColor: Colors.orangeAccent[700],
                  decoration: InputDecoration(
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: Color.fromRGBO(21, 32, 43, 1.0),
                      ),
                    ),
                    alignLabelWithHint: true,
                    fillColor: Color.fromRGBO(21, 32, 43, 1.0),
                    filled: true,
                    labelText: 'Note Title',
                    labelStyle: TextStyle(
                      fontSize: 20.0,
                      color: Colors.grey,
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(1.0),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: Color.fromRGBO(21, 32, 43, 1.0),
                      ),
                    ),
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(top: 5.0, bottom: 5.0),
                child: TextFormField(
                  validator: (String value) {
                    if (value.isEmpty) {
                      return 'Please enter a description';
                    }
                    return null;
                  },
                  controller: descriptionController,
                  textCapitalization: TextCapitalization.sentences,
                  maxLength: 2000,
                  maxLines: 10,
                  style: TextStyle(
                    fontSize: 17.0,
                    color: Colors.white,
                  ),
                  autocorrect: true,
                  cursorColor: Colors.orangeAccent[700],
//                  onChanged: (value) {
//                    debugPrint('Something changed in Description TextField');
//                    updateNoteDescription();
//                  },
                  decoration: InputDecoration(
                    focusedBorder: OutlineInputBorder(
                      borderSide:
                          BorderSide(color: Color.fromRGBO(21, 32, 43, 1.0)),
                    ),
                    alignLabelWithHint: true,
                    fillColor: Color.fromRGBO(21, 32, 43, 1.0),
                    filled: true,
                    labelText: 'Note Description',
                    labelStyle: TextStyle(
                      fontSize: 20.0,
                      color: Colors.grey,
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(1.0),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: Color.fromRGBO(21, 32, 43, 1.0),
                      ),
                    ),
                  ),
                ),
              ),
              GridView.count(
                shrinkWrap: true,
                primary: false,
                padding: const EdgeInsets.all(10),
                crossAxisCount: 1,
                mainAxisSpacing: 5,
                crossAxisSpacing: 5,
                scrollDirection: Axis.vertical,
                children: <Widget>[
                  GestureDetector(
                    onTap: getImage,
                    child: Container(
                      color: Color.fromRGBO(21, 32, 43, 1.0),
                      child: _selectImage == null
                          ? Icon(
                              Icons.image,
                              color: Color.fromRGBO(21, 32, 43, 1.0),
                            )
                          : Image.file(_selectImage),
                    ),
                  ),
                  GestureDetector(
                    onTap: takeImage,
                    child: Container(
                      color: Color.fromRGBO(21, 32, 43, 1.0),
                      child: _takeImage == null
                          ? Icon(
                              Icons.camera_alt,
                              color: Color.fromRGBO(21, 32, 43, 1.0),
                            )
                          : Image.file(_takeImage),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  void moveToPreviousScreen() {
    Navigator.pop(context, true);
  }

//  //Update the title of Note object
//  void updateNoteTitle() {
//    note.title = titleController.text;
//  }
//
//  //Update the description of note object
//  void updateNoteDescription() {
//    note.description = descriptionController.text;
//  }

  //TODO: Finish this!!
//  void updateNoteImage() {
//    note.image = imageController.text;
//  }

  //Gives the PopupMenuButton Widget functionality
  void choiceAction(NotePopupMenuButton choice) {
    setState(
      () {
        if (choice == NotePopupMenuButton.choices[0]) {
          getImage();
        } else if (choice == NotePopupMenuButton.choices[1]) {
          takeImage();
        } else if (choice == NotePopupMenuButton.choices[2]) {
          //TODO: implement this feature
        } else if (choice == NotePopupMenuButton.choices[3]) {
          //TODO: implement this feature
        } else if (choice == NotePopupMenuButton.choices[4]) {
          //TODO: implement this feature
        }
      },
    );
  }

  //Save data to database
  //TODO: Finish this!
  void _save() async {
    moveToPreviousScreen();
    final noteDao = Provider.of<NoteDao>(context, listen: false);
    int result;
    //update operation
    if (note.id != null) {
      result = await noteDao.updateNote(note);
      //insert operation
    } else {
      result = await noteDao.insertNote(note);
    }

    if (result != 0) {
      _showAlertDialog('Note Saved Successfully!');
    } else {
      _showAlertDialog('Issue with Saving Note! Please Try again!');
    }
  }

  //Displays delete confirmation dialog so that the user has a choice to cancel their action or go through with it
  Future<void> _displayDeleteConfirmationDialog(
      NoteDao noteDao, BuildContext context, Note note) {
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
                  _delete(noteDao);
                  Navigator.of(context).pop();
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => AllNotesScreen(),
                    ),
                  ); // Close dialog
                },
              ),
            ],
          );
        });
  }

  //Delete data from database
  void _delete(NoteDao noteDao) async {
    final noteDao = Provider.of<NoteDao>(context);
    moveToPreviousScreen();
    //User tries to delete a new note which they have arrived at via pressing the FAB
    if (note.id == null) {
      _showAlertDialog('Changes Have Been Successfully Discarded!');
      return;
    }
    //User tries to delete an old note that already has a valid ID and has been previously saved on the note screen
    int result = await noteDao.deleteNote(note);
    if (result != 0) {
      _showAlertDialog('Note Deleted Successfully!');
    } else {
      _showAlertDialog("Note Wasn't Successfully Deleted!");
    }
  }

  //This function will be called when someone tries to save or delete a note
  void _showAlertDialog(String message) {
    AlertDialog alertDialog = AlertDialog(
      backgroundColor: Color.fromRGBO(21, 32, 43, 1.0),
      content: Text(message),
    );
    showDialog(
        context: context,
        builder: (context) {
          Future.delayed(Duration(seconds: 1), () {
            Navigator.of(context).pop(true);
          });
          return alertDialog;
        });
  }

  StreamBuilder<List<NoteFolder>> _buildNoteFolderSelector(
      BuildContext context) {
    return StreamBuilder<List<NoteFolder>>(
      stream: Provider.of<NoteFolderDao>(context).watchAllNoteFolders(),
      builder: (context, snapshot) {
        final noteFolders = snapshot.data ?? List();
        DropdownMenuItem<NoteFolder> dropdownFromNoteFolder(
            NoteFolder noteFolder) {
          return DropdownMenuItem(
            value: noteFolder,
            child: Row(
              children: <Widget>[
                CircleAvatar(
                  backgroundColor: Color.fromRGBO(21, 32, 43, 1.0),
                  foregroundColor: Colors.orangeAccent[700],
                  child: Icon(Icons.folder),
                ),
                Text(noteFolder.title)
              ],
            ),
          );
        }

        final dropdownMenuItems = noteFolders
            .map((noteFolder) => dropdownFromNoteFolder(noteFolder))
            .toList()
              ..insert(
                0,
                DropdownMenuItem(
                  value: null,
                  child: Text('All Notes'),
                ),
              );
        return Expanded(
          flex: 3,
          child: DropdownButton(
            icon: Icon(
              Icons.arrow_drop_down,
              color: Colors.orangeAccent[700],
            ),
            iconSize: 30,
            elevation: 16,
            dropdownColor: Color.fromRGBO(21, 32, 43, 1.0),
            style: TextStyle(color: Colors.orangeAccent[700]),
            onChanged: (noteFolder) {
              setState(() {
                selectedNoteFolder = noteFolder;
              });
            },
            isExpanded: true,
            value: selectedNoteFolder,
            items: dropdownMenuItems,
          ),
        );
      },
    );
  }
}

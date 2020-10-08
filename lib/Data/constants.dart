import 'package:flutter/material.dart';

class EditAndDeletePopupMenuButton {
  final String title;
  final Icon icon;

  EditAndDeletePopupMenuButton({this.title, this.icon});

  static List<EditAndDeletePopupMenuButton> choices =
      <EditAndDeletePopupMenuButton>[
    EditAndDeletePopupMenuButton(
        title: 'Go To Tasks', icon: Icon(Icons.content_paste)),
    EditAndDeletePopupMenuButton(title: 'Edit', icon: Icon(Icons.edit)),
    EditAndDeletePopupMenuButton(
        title: 'Delete', icon: Icon(Icons.delete_outline))
  ];
}

class NotePopupMenuButton {
  final String title;
  final Icon icon;

  NotePopupMenuButton({this.title, this.icon});

  static List<NotePopupMenuButton> choices = <NotePopupMenuButton>[
    NotePopupMenuButton(title: 'Gallery Image', icon: Icon(Icons.image)),
    NotePopupMenuButton(title: 'Camera', icon: Icon(Icons.camera_alt)),
    NotePopupMenuButton(title: 'Video', icon: Icon(Icons.videocam)),
    NotePopupMenuButton(title: 'Draw Something', icon: Icon(Icons.brush)),
    NotePopupMenuButton(title: 'Record Audio', icon: Icon(Icons.mic)),
  ];
}

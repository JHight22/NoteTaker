import 'package:sqflite/sqflite.dart';
import 'dart:async';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:notetaker/Models/note.dart';
import 'package:path/path.dart';
import 'package:notetaker/Models/task.dart';
import 'package:notetaker/Models/noteFolder.dart';
import 'package:notetaker/Models/taskFolder.dart';

class DatabaseHelper {
  //Singleton DatabaseHelper
  static DatabaseHelper _databaseHelper;
  //Singleton Database
  static Database _noteTakerDatabase;

  String noteTable = 'noteTable';
  String colNoteId = 'id';
  String colNoteTitle = 'title';
  String colNoteDescription = 'description';
  String colNoteDate = 'date';
  String colNoteFId = 'noteFolderId';

  String taskTable = 'taskTable';
  String colTaskId = 'id';
  String colTaskDescription = 'description';
  String colTaskDate = 'date';
  String colTaskCheckbox = 'checkbox';
  String colTaskFId = 'taskFolderId';

  String noteFolderTable = 'noteFolderTable';
  String colNoteFolderId = 'id';
  String colNoteFolderTitle = 'title';
  String colNoteFolderDate = 'date';

  String taskFolderTable = 'taskFolderTable';
  String colTaskFolderId = 'id';
  String colTaskFolderTitle = 'title';
  String colTaskFolderDate = 'date';

  //Constructor to create instance of DatabaseHelper
  DatabaseHelper._createInstance();

  // part 1 of initializing the database
  factory DatabaseHelper() {
    if (_databaseHelper == null) {
      //This is created only once, it is a singleton object
      _databaseHelper = DatabaseHelper._createInstance();
    }
    return _databaseHelper;
  }

  // part 2 of initializing the database
  Future<Database> get database async {
    if (_noteTakerDatabase == null) {
      _noteTakerDatabase = await initializeNoteTakerDatabase();
    }
    return _noteTakerDatabase;
  }

  // let's the database utilize foreign keys
  static Future _onConfigure(Database db) async {
    await db.execute('PRAGMA foreign_keys = ON');
  }

  // this gets the device's documents directory to store the offline database
  Future<Database> initializeNoteTakerDatabase() async {
    //Get the directory path for both Android and iOS to store database
    Directory directory = await getApplicationDocumentsDirectory();
    String path = join(directory.path + 'notetaker.db');
    //Open and/or create the database at a given path
    var noteTakerDatabase = await openDatabase(path,
        version: 1, onCreate: _createNoteTakerDb, onConfigure: _onConfigure);
    return noteTakerDatabase;
  }

  //This function actually creates the tables that will be stored in the database. This is a normal SQL statement
  void _createNoteTakerDb(Database db, int newVersion) async {
    await db.execute(
        'CREATE TABLE $noteTable($colNoteId INTEGER PRIMARY KEY AUTOINCREMENT, $colNoteTitle TEXT, $colNoteDescription TEXT, $colNoteDate TEXT, $colNoteFId INTEGER, FOREIGN KEY($colNoteFId) REFERENCES $noteFolderTable($colNoteFolderId))');
    await db.execute(
        'CREATE TABLE $taskTable($colTaskId INTEGER PRIMARY KEY AUTOINCREMENT, $colTaskDescription TEXT, $colTaskDate TEXT, $colTaskCheckbox INTEGER NOT NULL, $colTaskFId INTEGER, FOREIGN KEY($colTaskFId) REFERENCES $taskFolderTable($colTaskFolderId))');
    await db.execute(
        'CREATE TABLE $noteFolderTable($colNoteFolderId INTEGER PRIMARY KEY AUTOINCREMENT, $colNoteFolderTitle TEXT, $colNoteFolderDate TEXT)');
    await db.execute(
        'CREATE TABLE $taskFolderTable($colTaskFolderId INTEGER PRIMARY KEY AUTOINCREMENT, $colTaskFolderTitle TEXT, $colTaskFolderDate TEXT)');
    await db.rawInsert(
        'INSERT INTO $noteFolderTable($colNoteFolderId, $colNoteFolderTitle, $colNoteFolderDate) VALUES(1, "All Notes", "now")');
    await db.rawInsert(
        'INSERT INTO $taskFolderTable($colTaskFolderId, $colTaskFolderTitle, $colTaskFolderDate) VALUES(1, "All Tasks", "now")');
  }

  //Retrieve Operation: Get all note objects from database
  Future<List<Map<String, dynamic>>> getNoteMapList() async {
    Database db = await this.database;
    //can also write a raw SQL statement, but it is more subject to SQL injections, so don't do that if possible.
    //But as an example, the raw SQL statement would be var result = await db.rawQuery('SELECT * FROM $noteTable order by $colId ASC');
    var result = await db.query(noteTable, orderBy: '$colNoteId ASC');
    return result;
  }

//  Future<List<Note>> getSpecificNoteMapList(int folderId) async {
//    Database db = await this.database;
//    List<Map> result = await db.query(noteTable,
//        columns: [
//          colNoteId,
//          colNoteTitle,
//          colNoteDescription,
//          colNoteDate,
//          colNoteFolderId
//        ],
//        where: '$colNoteFolderId = ?',
//        whereArgs: [folderId]);
//    if (result.length > 0) {
//      return result;
//    }
//    return null;
//  }

  //Retrieve Operation: Get all task objects from database
  Future<List<Map<String, dynamic>>> getTaskMapList() async {
    Database db = await this.database;
    //can also write a raw SQL statement, but it is more subject to SQL injections, so don't do that if possible.
    //But as an example, the raw SQL statement would be var result = await db.rawQuery('SELECT * FROM $noteTable order by $colId ASC');
    var result = await db.query(taskTable, orderBy: '$colTaskId ASC');
    return result;
  }

  //Retrieve Operation: Get all noteFolder objects from database
  Future<List<Map<String, dynamic>>> getNoteFolderMapList() async {
    Database db = await this.database;
    //can also write a raw SQL statement, but it is more subject to SQL injections, so don't do that if possible.
    //But as an example, the raw SQL statement would be var result = await db.rawQuery('SELECT * FROM $noteTable order by $colId ASC');
    var result =
        await db.query(noteFolderTable, orderBy: '$colNoteFolderId ASC');
    return result;
  }

  //Retrieve Operation: Get all taskFolder objects from database
  Future<List<Map<String, dynamic>>> getTaskFolderMapList() async {
    Database db = await this.database;
    //can also write a raw SQL statement, but it is more subject to SQL injections, so don't do that if possible.
    //But as an example, the raw SQL statement would be var result = await db.rawQuery('SELECT * FROM $noteTable order by $colId ASC');
    var result =
        await db.query(taskFolderTable, orderBy: '$colTaskFolderId ASC');
    return result;
  }

//Insert Operation: Insert/add/create a new note object to database
  Future<int> insertNote(Note note) async {
    Database db = await this.database;
    var result = await db.insert(
      noteTable,
      note.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
    return result;
  }

  //Insert Operation: Insert/add/create a new task object to database
  Future<int> insertTask(Task task) async {
    Database db = await this.database;
    var result = await db.insert(
      taskTable,
      task.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
    return result;
  }

//Insert Operation: Insert/add/create a new noteFolder object to database
  Future<int> insertNoteFolder(NoteFolder folder) async {
    Database db = await this.database;
    var result = await db.insert(
      noteFolderTable,
      folder.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
    return result;
  }

  //Insert Operation: Insert/add/create a new noteFolder object to database
  Future<int> insertTaskFolder(TaskFolder folder) async {
    Database db = await this.database;
    var result = await db.insert(
      taskFolderTable,
      folder.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
    return result;
  }

//Update Operation: Update a note object and save it to database
  Future<int> updateNote(Note note) async {
    var db = await this.database;
    var result = await db.update(noteTable, note.toMap(),
        where: '$colNoteId = ?', whereArgs: [note.id]);
    return result;
  }

  //Update Operation: Update a task object and save it to database
  Future<int> updateTask(Task task) async {
    var db = await this.database;
    var result = await db.update(taskTable, task.toMap(),
        where: '$colTaskId = ?', whereArgs: [task.id]);
    return result;
  }

  //Update Operation: Update a noteFolder object and save it to database
  Future<int> updateNoteFolder(NoteFolder folder) async {
    var db = await this.database;
    var result = await db.update(noteFolderTable, folder.toMap(),
        where: '$colNoteFolderId = ?', whereArgs: [folder.id]);
    return result;
  }

  //Update Operation: Update a taskFolder object and save it to database
  Future<int> updateTaskFolder(TaskFolder folder) async {
    var db = await this.database;
    var result = await db.update(taskFolderTable, folder.toMap(),
        where: '$colTaskFolderId = ?', whereArgs: [folder.id]);
    return result;
  }

//Delete Operation: Delete a note object from database
  Future<int> deleteNote(int id) async {
    var db = await this.database;
    int result =
        await db.delete(noteTable, where: '$colNoteId = ?', whereArgs: [id]);
    return result;
  }

  //Delete Operation: Delete a task object from database
  Future<int> deleteTask(int id) async {
    var db = await this.database;
    int result =
        await db.delete(taskTable, where: '$colTaskId = ?', whereArgs: [id]);
    return result;
  }

  //Delete Operation: Delete a Folder object from database
  Future<int> deleteNoteFolder(int id) async {
    var db = await this.database;
    int result = await db.delete(noteFolderTable,
        where: '$colNoteFolderId = ?', whereArgs: [id]);
    return result;
  }

  //Delete Operation: Delete a Folder object from database
  Future<int> deleteTaskFolder(int id) async {
    var db = await this.database;
    int result = await db.delete(taskFolderTable,
        where: '$colTaskFolderId = ?', whereArgs: [id]);
    return result;
  }

////Get number of Note objects in database
//  Future<int> getNoteObjectCount() async {
//    Database db = await this.database;
//    //This is a raw SQL statement
//    List<Map<String, dynamic>> x =
//        await db.rawQuery('SELECT COUNT (*) from $noteTable');
//    int result = Sqflite.firstIntValue(x);
//    return result;
//  }

//  //Get number of task objects in database
//  Future<int> getTaskObjectCount() async {
//    Database db = await this.database;
//    //This is a raw SQL statement
//    List<Map<String, dynamic>> x =
//        await db.rawQuery('SELECT COUNT (*) from $taskTable');
//    int result = Sqflite.firstIntValue(x);
//    return result;
//  }

//  //Get number of Folder objects in database
//  Future<int> getFolderObjectCount() async {
//    Database db = await this.database;
//    //This is a raw SQL statement
//    List<Map<String, dynamic>> x =
//        await db.rawQuery('SELECT COUNT (*) from $folderTable');
//    int result = Sqflite.firstIntValue(x);
//    return result;
//  }

  //TODO: Who knows if I need this as well...IDK
//  //This function queries for specific Notes hopefully within specific folders
//  Future<int> fetchNotesForSpecificFolder(int id) async {
//    Database db = await this.database;
//    List<Map<String, dynamic>> x =
//        await db.rawQuery('SELECT * FROM $noteTable WHERE folderId=?', [2]);
//    int result = Sqflite.firstIntValue(x);
//    return result;
//  }

//  //TODO: dont know if this is correct either
//  Future<List<Note>> getSpecificNoteList() async {
//    var specificNoteMapList = await getSpecificNoteMapList(id);
//    int count = specificNoteMapList.length;
//    List<Note> noteList = List<Note>();
//    for (int i = 0; i < count; i++) {
//      noteList.add(Note.fromMapObject(getSpecificNoteMapList[i]));
//    }
//    return noteList;
//  }

  //Get the 'Map List' [List<Map>] and convert it to 'Note List' [List<Note>]
  Future<List<Note>> getNoteList() async {
    //Get 'Map List' from database
    var noteMapList = await getNoteMapList();
    //Count the number of map entries in db table
    int count = noteMapList.length;
    List<Note> noteList = <Note>[];
    for (int i = 0; i < count; i++) {
      noteList.add(Note.fromMapObject(noteMapList[i]));
    }
    return noteList;
  }

  //Get the 'Map List' [List<Map>] and convert it to 'Task List' [List<Task>]
  Future<List<Task>> getTaskList() async {
    //Get 'Map List' from database
    var taskMapList = await getTaskMapList();
    //Count the number of map entries in db table
    int count = taskMapList.length;
    List<Task> taskList = <Task>[];
    for (int i = 0; i < count; i++) {
      taskList.add(Task.fromMapObject(taskMapList[i]));
    }
    return taskList;
  }

  //Get the 'Map List' [List<Map>] and convert it to 'Folder List' [List<Folder>]
  Future<List<NoteFolder>> getNoteFolderList() async {
    //Get 'Map List' from database
    var noteFolderMapList = await getNoteFolderMapList();
    //Count the number of map entries in db table
    int count = noteFolderMapList.length;
    List<NoteFolder> noteFolderList = <NoteFolder>[];
    for (int i = 0; i < count; i++) {
      noteFolderList.add(NoteFolder.fromMapObject(noteFolderMapList[i]));
    }
    return noteFolderList;
  }

  Future<List<TaskFolder>> getTaskFolderList() async {
    //Get 'Map List' from database
    var taskFolderMapList = await getTaskFolderMapList();
    //Count the number of map entries in db table
    int count = taskFolderMapList.length;
    List<TaskFolder> taskFolderList = <TaskFolder>[];
    for (int i = 0; i < count; i++) {
      taskFolderList.add(TaskFolder.fromMapObject(taskFolderMapList[i]));
    }
    return taskFolderList;
  }
}

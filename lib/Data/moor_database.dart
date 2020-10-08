import 'package:moor/moor.dart';
import 'package:moor_ffi/moor_ffi.dart';
import 'dart:async';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;
part 'moor_database.g.dart';

@DataClassName('Task')
class Tasks extends Table {
  //autoIncrement automatically sets this to be the primary key
  IntColumn get id => integer().autoIncrement()();
  TextColumn get description => text().nullable()();
  DateTimeColumn get date => dateTime()();
  BoolColumn get checkbox => boolean().withDefault(Constant(false))();
  TextColumn get folder => text()
      .nullable()
      .customConstraint('NULLABLE REFERENCES taskfolders(title)')();
}

@DataClassName('TaskFolder')
class TaskFolders extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get title => text().withLength(min: 1, max: 100)();
  DateTimeColumn get date => dateTime()();
}

@DataClassName('NoteFolder')
class NoteFolders extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get title => text().withLength(min: 1, max: 100)();
  DateTimeColumn get date => dateTime()();
}

@DataClassName('Note')
class Notes extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get title => text().nullable()();
  TextColumn get description => text().nullable()();
  DateTimeColumn get date => dateTime()();
  IntColumn get folder => integer()
      .nullable()
      .customConstraint('NULLABLE REFERENCES noteFolders(id)')();
}

class NoteWithNoteFolder {
  final Note note;
  final NoteFolder noteFolder;

  NoteWithNoteFolder({
    @required this.note,
    @required this.noteFolder,
  });
}

class TaskWithTaskFolder {
  final Task task;
  final TaskFolder taskFolder;

  TaskWithTaskFolder({
    @required this.task,
    @required this.taskFolder,
  });
}

@UseMoor(
    tables: [Tasks, TaskFolders, NoteFolders, Notes],
    daos: [TaskDao, NoteDao, TaskFolderDao, NoteFolderDao])
class NoteTakerDatabase extends _$NoteTakerDatabase {
  NoteTakerDatabase()
      : super(
          LazyDatabase(
            () async {
              final dbFolder = await getApplicationDocumentsDirectory();
              final file =
                  File(p.join(dbFolder.path, 'notetakerdatabase.sqlite'));
              return VmDatabase(file);
            },
          ),
        );

  @override
  int get schemaVersion => 1;

  @override
  MigrationStrategy get migration => MigrationStrategy(
        beforeOpen: (details) async {
          await customStatement('PRAGMA foreign_keys = ON');
        },
      );
}

//LazyDatabase _openConnection() {
//  return LazyDatabase(() async {
//    final dbFolder = await getApplicationDocumentsDirectory();
//    final file = File(p.join(dbFolder.path, 'notetakerdatabase.db'));
//    return VmDatabase(file);
//  });
//}

@UseDao(tables: [Tasks, TaskFolders])
class TaskDao extends DatabaseAccessor<NoteTakerDatabase> with _$TaskDaoMixin {
  final NoteTakerDatabase db;

  TaskDao(this.db) : super(db);

  Future<List<Task>> getAllTasks() => select(tasks).get();
  Stream<List<Task>> watchAllTasks() => select(tasks).watch();

  Stream<List<Task>> watchCompletedTasks() {
    return (select(tasks)
          ..orderBy([
            (t) => OrderingTerm(expression: t.date, mode: OrderingMode.desc),
          ])
          ..where((t) => t.checkbox.equals(true)))
        .watch();
  }

  Stream<List<Task>> watchNonCompletedTasks() {
    return (select(tasks)
          ..orderBy([
            (t) => OrderingTerm(expression: t.date, mode: OrderingMode.desc),
          ])
          ..where((t) => t.checkbox.equals(false)))
        .watch();
  }

  //this function joins the notes and noteFolder tables
  Stream<List<TaskWithTaskFolder>> watchTasksWithTaskFolders() {
    return (select(tasks)
          ..orderBy(
              //Primarily sorting by id
              [
                (t) => OrderingTerm(expression: t.id, mode: OrderingMode.desc),
              ]))
        .join(
          [
            //Join all of the tasks with their specific folders
            //Its important to use equalsExp so I can join all folder id's in the tasks table
            //And not just one specific task and folder
            leftOuterJoin(
                taskFolders, taskFolders.title.equalsExp(tasks.folder)),
          ],
        )
        .watch()
        .map((rows) => rows.map(
              (row) {
                return TaskWithTaskFolder(
                  task: row.readTable(tasks),
                  taskFolder: row.readTable(taskFolders),
                );
              },
            ).toList());
  }

  Future insertTask(Insertable<Task> task) => into(tasks).insert(task);
  Future updateTask(Insertable<Task> task) => update(tasks).replace(task);
  Future deleteTask(Insertable<Task> task) => delete(tasks).delete(task);
}

@UseDao(tables: [Notes, NoteFolders])
class NoteDao extends DatabaseAccessor<NoteTakerDatabase> with _$NoteDaoMixin {
  final NoteTakerDatabase db;

  NoteDao(this.db) : super(db);

  Future<List<Note>> getAllNotes() => select(notes).get();
  Stream<List<Note>> watchAllNotes() => select(notes).watch();

  //this function joins the notes and noteFolder tables
  Stream<List<NoteWithNoteFolder>> watchNotesWithNoteFolders() {
    return (select(notes)
          ..orderBy(
              //Primarily sorting by id
              [
                (t) => OrderingTerm(expression: t.id, mode: OrderingMode.desc),
              ]))
        .join(
          [
            //Join all of the notes with their specific folders
            //Its important to use equalsExp so I can join all folder id's in the notes table
            //And not just one specific note and folder
            leftOuterJoin(noteFolders, noteFolders.id.equalsExp(notes.folder)),
          ],
        )
        .watch()
        .map((rows) => rows.map(
              (row) {
                return NoteWithNoteFolder(
                  note: row.readTable(notes),
                  noteFolder: row.readTable(noteFolders),
                );
              },
            ).toList());
  }

  Future insertNote(Insertable<Note> note) => into(notes).insert(note);
  Future updateNote(Insertable<Note> note) => update(notes).replace(note);
  Future deleteNote(Insertable<Note> note) => delete(notes).delete(note);
}

@UseDao(tables: [TaskFolders])
class TaskFolderDao extends DatabaseAccessor<NoteTakerDatabase>
    with _$TaskFolderDaoMixin {
  final NoteTakerDatabase db;

  TaskFolderDao(this.db) : super(db);

  Future<List<TaskFolder>> getAllTaskFolders() => select(taskFolders).get();
  Stream<List<TaskFolder>> watchAllTaskFolders() => select(taskFolders).watch();
  Future insertTaskFolder(Insertable<TaskFolder> taskFolder) =>
      into(taskFolders).insert(taskFolder);
  Future updateTaskFolder(Insertable<TaskFolder> taskFolder) =>
      update(taskFolders).replace(taskFolder);
  Future deleteTaskFolder(Insertable<TaskFolder> taskFolder) =>
      delete(taskFolders).delete(taskFolder);
}

@UseDao(tables: [NoteFolders])
class NoteFolderDao extends DatabaseAccessor<NoteTakerDatabase>
    with _$NoteFolderDaoMixin {
  final NoteTakerDatabase db;

  NoteFolderDao(this.db) : super(db);

  Future<List<NoteFolder>> getAllNoteFolders() => select(noteFolders).get();
  Stream<List<NoteFolder>> watchAllNoteFolders() => select(noteFolders).watch();
  Future insertNoteFolder(Insertable<NoteFolder> noteFolder) =>
      into(noteFolders).insert(noteFolder);
  Future updateNoteFolder(Insertable<NoteFolder> noteFolder) =>
      update(noteFolders).replace(noteFolder);
  Future deleteNoteFolder(Insertable<NoteFolder> noteFolder) =>
      delete(noteFolders).delete(noteFolder);
}

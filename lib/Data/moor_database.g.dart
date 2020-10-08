// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'moor_database.dart';

// **************************************************************************
// MoorGenerator
// **************************************************************************

// ignore_for_file: unnecessary_brace_in_string_interps, unnecessary_this
class Task extends DataClass implements Insertable<Task> {
  final int id;
  final String description;
  final DateTime date;
  final bool checkbox;
  final String folder;
  Task(
      {@required this.id,
      this.description,
      @required this.date,
      @required this.checkbox,
      this.folder});
  factory Task.fromData(Map<String, dynamic> data, GeneratedDatabase db,
      {String prefix}) {
    final effectivePrefix = prefix ?? '';
    final intType = db.typeSystem.forDartType<int>();
    final stringType = db.typeSystem.forDartType<String>();
    final dateTimeType = db.typeSystem.forDartType<DateTime>();
    final boolType = db.typeSystem.forDartType<bool>();
    return Task(
      id: intType.mapFromDatabaseResponse(data['${effectivePrefix}id']),
      description: stringType
          .mapFromDatabaseResponse(data['${effectivePrefix}description']),
      date:
          dateTimeType.mapFromDatabaseResponse(data['${effectivePrefix}date']),
      checkbox:
          boolType.mapFromDatabaseResponse(data['${effectivePrefix}checkbox']),
      folder:
          stringType.mapFromDatabaseResponse(data['${effectivePrefix}folder']),
    );
  }
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (!nullToAbsent || id != null) {
      map['id'] = Variable<int>(id);
    }
    if (!nullToAbsent || description != null) {
      map['description'] = Variable<String>(description);
    }
    if (!nullToAbsent || date != null) {
      map['date'] = Variable<DateTime>(date);
    }
    if (!nullToAbsent || checkbox != null) {
      map['checkbox'] = Variable<bool>(checkbox);
    }
    if (!nullToAbsent || folder != null) {
      map['folder'] = Variable<String>(folder);
    }
    return map;
  }

  TasksCompanion toCompanion(bool nullToAbsent) {
    return TasksCompanion(
      id: id == null && nullToAbsent ? const Value.absent() : Value(id),
      description: description == null && nullToAbsent
          ? const Value.absent()
          : Value(description),
      date: date == null && nullToAbsent ? const Value.absent() : Value(date),
      checkbox: checkbox == null && nullToAbsent
          ? const Value.absent()
          : Value(checkbox),
      folder:
          folder == null && nullToAbsent ? const Value.absent() : Value(folder),
    );
  }

  factory Task.fromJson(Map<String, dynamic> json,
      {ValueSerializer serializer}) {
    serializer ??= moorRuntimeOptions.defaultSerializer;
    return Task(
      id: serializer.fromJson<int>(json['id']),
      description: serializer.fromJson<String>(json['description']),
      date: serializer.fromJson<DateTime>(json['date']),
      checkbox: serializer.fromJson<bool>(json['checkbox']),
      folder: serializer.fromJson<String>(json['folder']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer serializer}) {
    serializer ??= moorRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'description': serializer.toJson<String>(description),
      'date': serializer.toJson<DateTime>(date),
      'checkbox': serializer.toJson<bool>(checkbox),
      'folder': serializer.toJson<String>(folder),
    };
  }

  Task copyWith(
          {int id,
          String description,
          DateTime date,
          bool checkbox,
          String folder}) =>
      Task(
        id: id ?? this.id,
        description: description ?? this.description,
        date: date ?? this.date,
        checkbox: checkbox ?? this.checkbox,
        folder: folder ?? this.folder,
      );
  @override
  String toString() {
    return (StringBuffer('Task(')
          ..write('id: $id, ')
          ..write('description: $description, ')
          ..write('date: $date, ')
          ..write('checkbox: $checkbox, ')
          ..write('folder: $folder')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => $mrjf($mrjc(
      id.hashCode,
      $mrjc(description.hashCode,
          $mrjc(date.hashCode, $mrjc(checkbox.hashCode, folder.hashCode)))));
  @override
  bool operator ==(dynamic other) =>
      identical(this, other) ||
      (other is Task &&
          other.id == this.id &&
          other.description == this.description &&
          other.date == this.date &&
          other.checkbox == this.checkbox &&
          other.folder == this.folder);
}

class TasksCompanion extends UpdateCompanion<Task> {
  final Value<int> id;
  final Value<String> description;
  final Value<DateTime> date;
  final Value<bool> checkbox;
  final Value<String> folder;
  const TasksCompanion({
    this.id = const Value.absent(),
    this.description = const Value.absent(),
    this.date = const Value.absent(),
    this.checkbox = const Value.absent(),
    this.folder = const Value.absent(),
  });
  TasksCompanion.insert({
    this.id = const Value.absent(),
    this.description = const Value.absent(),
    @required DateTime date,
    this.checkbox = const Value.absent(),
    this.folder = const Value.absent(),
  }) : date = Value(date);
  static Insertable<Task> custom({
    Expression<int> id,
    Expression<String> description,
    Expression<DateTime> date,
    Expression<bool> checkbox,
    Expression<String> folder,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (description != null) 'description': description,
      if (date != null) 'date': date,
      if (checkbox != null) 'checkbox': checkbox,
      if (folder != null) 'folder': folder,
    });
  }

  TasksCompanion copyWith(
      {Value<int> id,
      Value<String> description,
      Value<DateTime> date,
      Value<bool> checkbox,
      Value<String> folder}) {
    return TasksCompanion(
      id: id ?? this.id,
      description: description ?? this.description,
      date: date ?? this.date,
      checkbox: checkbox ?? this.checkbox,
      folder: folder ?? this.folder,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (description.present) {
      map['description'] = Variable<String>(description.value);
    }
    if (date.present) {
      map['date'] = Variable<DateTime>(date.value);
    }
    if (checkbox.present) {
      map['checkbox'] = Variable<bool>(checkbox.value);
    }
    if (folder.present) {
      map['folder'] = Variable<String>(folder.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('TasksCompanion(')
          ..write('id: $id, ')
          ..write('description: $description, ')
          ..write('date: $date, ')
          ..write('checkbox: $checkbox, ')
          ..write('folder: $folder')
          ..write(')'))
        .toString();
  }
}

class $TasksTable extends Tasks with TableInfo<$TasksTable, Task> {
  final GeneratedDatabase _db;
  final String _alias;
  $TasksTable(this._db, [this._alias]);
  final VerificationMeta _idMeta = const VerificationMeta('id');
  GeneratedIntColumn _id;
  @override
  GeneratedIntColumn get id => _id ??= _constructId();
  GeneratedIntColumn _constructId() {
    return GeneratedIntColumn('id', $tableName, false,
        hasAutoIncrement: true, declaredAsPrimaryKey: true);
  }

  final VerificationMeta _descriptionMeta =
      const VerificationMeta('description');
  GeneratedTextColumn _description;
  @override
  GeneratedTextColumn get description =>
      _description ??= _constructDescription();
  GeneratedTextColumn _constructDescription() {
    return GeneratedTextColumn(
      'description',
      $tableName,
      true,
    );
  }

  final VerificationMeta _dateMeta = const VerificationMeta('date');
  GeneratedDateTimeColumn _date;
  @override
  GeneratedDateTimeColumn get date => _date ??= _constructDate();
  GeneratedDateTimeColumn _constructDate() {
    return GeneratedDateTimeColumn(
      'date',
      $tableName,
      false,
    );
  }

  final VerificationMeta _checkboxMeta = const VerificationMeta('checkbox');
  GeneratedBoolColumn _checkbox;
  @override
  GeneratedBoolColumn get checkbox => _checkbox ??= _constructCheckbox();
  GeneratedBoolColumn _constructCheckbox() {
    return GeneratedBoolColumn('checkbox', $tableName, false,
        defaultValue: Constant(false));
  }

  final VerificationMeta _folderMeta = const VerificationMeta('folder');
  GeneratedTextColumn _folder;
  @override
  GeneratedTextColumn get folder => _folder ??= _constructFolder();
  GeneratedTextColumn _constructFolder() {
    return GeneratedTextColumn('folder', $tableName, true,
        $customConstraints: 'NULLABLE REFERENCES taskfolders(title)');
  }

  @override
  List<GeneratedColumn> get $columns =>
      [id, description, date, checkbox, folder];
  @override
  $TasksTable get asDslTable => this;
  @override
  String get $tableName => _alias ?? 'tasks';
  @override
  final String actualTableName = 'tasks';
  @override
  VerificationContext validateIntegrity(Insertable<Task> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id'], _idMeta));
    }
    if (data.containsKey('description')) {
      context.handle(
          _descriptionMeta,
          description.isAcceptableOrUnknown(
              data['description'], _descriptionMeta));
    }
    if (data.containsKey('date')) {
      context.handle(
          _dateMeta, date.isAcceptableOrUnknown(data['date'], _dateMeta));
    } else if (isInserting) {
      context.missing(_dateMeta);
    }
    if (data.containsKey('checkbox')) {
      context.handle(_checkboxMeta,
          checkbox.isAcceptableOrUnknown(data['checkbox'], _checkboxMeta));
    }
    if (data.containsKey('folder')) {
      context.handle(_folderMeta,
          folder.isAcceptableOrUnknown(data['folder'], _folderMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Task map(Map<String, dynamic> data, {String tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : null;
    return Task.fromData(data, _db, prefix: effectivePrefix);
  }

  @override
  $TasksTable createAlias(String alias) {
    return $TasksTable(_db, alias);
  }
}

class TaskFolder extends DataClass implements Insertable<TaskFolder> {
  final int id;
  final String title;
  final DateTime date;
  TaskFolder({@required this.id, @required this.title, @required this.date});
  factory TaskFolder.fromData(Map<String, dynamic> data, GeneratedDatabase db,
      {String prefix}) {
    final effectivePrefix = prefix ?? '';
    final intType = db.typeSystem.forDartType<int>();
    final stringType = db.typeSystem.forDartType<String>();
    final dateTimeType = db.typeSystem.forDartType<DateTime>();
    return TaskFolder(
      id: intType.mapFromDatabaseResponse(data['${effectivePrefix}id']),
      title:
          stringType.mapFromDatabaseResponse(data['${effectivePrefix}title']),
      date:
          dateTimeType.mapFromDatabaseResponse(data['${effectivePrefix}date']),
    );
  }
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (!nullToAbsent || id != null) {
      map['id'] = Variable<int>(id);
    }
    if (!nullToAbsent || title != null) {
      map['title'] = Variable<String>(title);
    }
    if (!nullToAbsent || date != null) {
      map['date'] = Variable<DateTime>(date);
    }
    return map;
  }

  TaskFoldersCompanion toCompanion(bool nullToAbsent) {
    return TaskFoldersCompanion(
      id: id == null && nullToAbsent ? const Value.absent() : Value(id),
      title:
          title == null && nullToAbsent ? const Value.absent() : Value(title),
      date: date == null && nullToAbsent ? const Value.absent() : Value(date),
    );
  }

  factory TaskFolder.fromJson(Map<String, dynamic> json,
      {ValueSerializer serializer}) {
    serializer ??= moorRuntimeOptions.defaultSerializer;
    return TaskFolder(
      id: serializer.fromJson<int>(json['id']),
      title: serializer.fromJson<String>(json['title']),
      date: serializer.fromJson<DateTime>(json['date']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer serializer}) {
    serializer ??= moorRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'title': serializer.toJson<String>(title),
      'date': serializer.toJson<DateTime>(date),
    };
  }

  TaskFolder copyWith({int id, String title, DateTime date}) => TaskFolder(
        id: id ?? this.id,
        title: title ?? this.title,
        date: date ?? this.date,
      );
  @override
  String toString() {
    return (StringBuffer('TaskFolder(')
          ..write('id: $id, ')
          ..write('title: $title, ')
          ..write('date: $date')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      $mrjf($mrjc(id.hashCode, $mrjc(title.hashCode, date.hashCode)));
  @override
  bool operator ==(dynamic other) =>
      identical(this, other) ||
      (other is TaskFolder &&
          other.id == this.id &&
          other.title == this.title &&
          other.date == this.date);
}

class TaskFoldersCompanion extends UpdateCompanion<TaskFolder> {
  final Value<int> id;
  final Value<String> title;
  final Value<DateTime> date;
  const TaskFoldersCompanion({
    this.id = const Value.absent(),
    this.title = const Value.absent(),
    this.date = const Value.absent(),
  });
  TaskFoldersCompanion.insert({
    this.id = const Value.absent(),
    @required String title,
    @required DateTime date,
  })  : title = Value(title),
        date = Value(date);
  static Insertable<TaskFolder> custom({
    Expression<int> id,
    Expression<String> title,
    Expression<DateTime> date,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (title != null) 'title': title,
      if (date != null) 'date': date,
    });
  }

  TaskFoldersCompanion copyWith(
      {Value<int> id, Value<String> title, Value<DateTime> date}) {
    return TaskFoldersCompanion(
      id: id ?? this.id,
      title: title ?? this.title,
      date: date ?? this.date,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (title.present) {
      map['title'] = Variable<String>(title.value);
    }
    if (date.present) {
      map['date'] = Variable<DateTime>(date.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('TaskFoldersCompanion(')
          ..write('id: $id, ')
          ..write('title: $title, ')
          ..write('date: $date')
          ..write(')'))
        .toString();
  }
}

class $TaskFoldersTable extends TaskFolders
    with TableInfo<$TaskFoldersTable, TaskFolder> {
  final GeneratedDatabase _db;
  final String _alias;
  $TaskFoldersTable(this._db, [this._alias]);
  final VerificationMeta _idMeta = const VerificationMeta('id');
  GeneratedIntColumn _id;
  @override
  GeneratedIntColumn get id => _id ??= _constructId();
  GeneratedIntColumn _constructId() {
    return GeneratedIntColumn('id', $tableName, false,
        hasAutoIncrement: true, declaredAsPrimaryKey: true);
  }

  final VerificationMeta _titleMeta = const VerificationMeta('title');
  GeneratedTextColumn _title;
  @override
  GeneratedTextColumn get title => _title ??= _constructTitle();
  GeneratedTextColumn _constructTitle() {
    return GeneratedTextColumn('title', $tableName, false,
        minTextLength: 1, maxTextLength: 100);
  }

  final VerificationMeta _dateMeta = const VerificationMeta('date');
  GeneratedDateTimeColumn _date;
  @override
  GeneratedDateTimeColumn get date => _date ??= _constructDate();
  GeneratedDateTimeColumn _constructDate() {
    return GeneratedDateTimeColumn(
      'date',
      $tableName,
      false,
    );
  }

  @override
  List<GeneratedColumn> get $columns => [id, title, date];
  @override
  $TaskFoldersTable get asDslTable => this;
  @override
  String get $tableName => _alias ?? 'task_folders';
  @override
  final String actualTableName = 'task_folders';
  @override
  VerificationContext validateIntegrity(Insertable<TaskFolder> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id'], _idMeta));
    }
    if (data.containsKey('title')) {
      context.handle(
          _titleMeta, title.isAcceptableOrUnknown(data['title'], _titleMeta));
    } else if (isInserting) {
      context.missing(_titleMeta);
    }
    if (data.containsKey('date')) {
      context.handle(
          _dateMeta, date.isAcceptableOrUnknown(data['date'], _dateMeta));
    } else if (isInserting) {
      context.missing(_dateMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  TaskFolder map(Map<String, dynamic> data, {String tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : null;
    return TaskFolder.fromData(data, _db, prefix: effectivePrefix);
  }

  @override
  $TaskFoldersTable createAlias(String alias) {
    return $TaskFoldersTable(_db, alias);
  }
}

class NoteFolder extends DataClass implements Insertable<NoteFolder> {
  final int id;
  final String title;
  final DateTime date;
  NoteFolder({@required this.id, @required this.title, @required this.date});
  factory NoteFolder.fromData(Map<String, dynamic> data, GeneratedDatabase db,
      {String prefix}) {
    final effectivePrefix = prefix ?? '';
    final intType = db.typeSystem.forDartType<int>();
    final stringType = db.typeSystem.forDartType<String>();
    final dateTimeType = db.typeSystem.forDartType<DateTime>();
    return NoteFolder(
      id: intType.mapFromDatabaseResponse(data['${effectivePrefix}id']),
      title:
          stringType.mapFromDatabaseResponse(data['${effectivePrefix}title']),
      date:
          dateTimeType.mapFromDatabaseResponse(data['${effectivePrefix}date']),
    );
  }
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (!nullToAbsent || id != null) {
      map['id'] = Variable<int>(id);
    }
    if (!nullToAbsent || title != null) {
      map['title'] = Variable<String>(title);
    }
    if (!nullToAbsent || date != null) {
      map['date'] = Variable<DateTime>(date);
    }
    return map;
  }

  NoteFoldersCompanion toCompanion(bool nullToAbsent) {
    return NoteFoldersCompanion(
      id: id == null && nullToAbsent ? const Value.absent() : Value(id),
      title:
          title == null && nullToAbsent ? const Value.absent() : Value(title),
      date: date == null && nullToAbsent ? const Value.absent() : Value(date),
    );
  }

  factory NoteFolder.fromJson(Map<String, dynamic> json,
      {ValueSerializer serializer}) {
    serializer ??= moorRuntimeOptions.defaultSerializer;
    return NoteFolder(
      id: serializer.fromJson<int>(json['id']),
      title: serializer.fromJson<String>(json['title']),
      date: serializer.fromJson<DateTime>(json['date']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer serializer}) {
    serializer ??= moorRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'title': serializer.toJson<String>(title),
      'date': serializer.toJson<DateTime>(date),
    };
  }

  NoteFolder copyWith({int id, String title, DateTime date}) => NoteFolder(
        id: id ?? this.id,
        title: title ?? this.title,
        date: date ?? this.date,
      );
  @override
  String toString() {
    return (StringBuffer('NoteFolder(')
          ..write('id: $id, ')
          ..write('title: $title, ')
          ..write('date: $date')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      $mrjf($mrjc(id.hashCode, $mrjc(title.hashCode, date.hashCode)));
  @override
  bool operator ==(dynamic other) =>
      identical(this, other) ||
      (other is NoteFolder &&
          other.id == this.id &&
          other.title == this.title &&
          other.date == this.date);
}

class NoteFoldersCompanion extends UpdateCompanion<NoteFolder> {
  final Value<int> id;
  final Value<String> title;
  final Value<DateTime> date;
  const NoteFoldersCompanion({
    this.id = const Value.absent(),
    this.title = const Value.absent(),
    this.date = const Value.absent(),
  });
  NoteFoldersCompanion.insert({
    this.id = const Value.absent(),
    @required String title,
    @required DateTime date,
  })  : title = Value(title),
        date = Value(date);
  static Insertable<NoteFolder> custom({
    Expression<int> id,
    Expression<String> title,
    Expression<DateTime> date,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (title != null) 'title': title,
      if (date != null) 'date': date,
    });
  }

  NoteFoldersCompanion copyWith(
      {Value<int> id, Value<String> title, Value<DateTime> date}) {
    return NoteFoldersCompanion(
      id: id ?? this.id,
      title: title ?? this.title,
      date: date ?? this.date,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (title.present) {
      map['title'] = Variable<String>(title.value);
    }
    if (date.present) {
      map['date'] = Variable<DateTime>(date.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('NoteFoldersCompanion(')
          ..write('id: $id, ')
          ..write('title: $title, ')
          ..write('date: $date')
          ..write(')'))
        .toString();
  }
}

class $NoteFoldersTable extends NoteFolders
    with TableInfo<$NoteFoldersTable, NoteFolder> {
  final GeneratedDatabase _db;
  final String _alias;
  $NoteFoldersTable(this._db, [this._alias]);
  final VerificationMeta _idMeta = const VerificationMeta('id');
  GeneratedIntColumn _id;
  @override
  GeneratedIntColumn get id => _id ??= _constructId();
  GeneratedIntColumn _constructId() {
    return GeneratedIntColumn('id', $tableName, false,
        hasAutoIncrement: true, declaredAsPrimaryKey: true);
  }

  final VerificationMeta _titleMeta = const VerificationMeta('title');
  GeneratedTextColumn _title;
  @override
  GeneratedTextColumn get title => _title ??= _constructTitle();
  GeneratedTextColumn _constructTitle() {
    return GeneratedTextColumn('title', $tableName, false,
        minTextLength: 1, maxTextLength: 100);
  }

  final VerificationMeta _dateMeta = const VerificationMeta('date');
  GeneratedDateTimeColumn _date;
  @override
  GeneratedDateTimeColumn get date => _date ??= _constructDate();
  GeneratedDateTimeColumn _constructDate() {
    return GeneratedDateTimeColumn(
      'date',
      $tableName,
      false,
    );
  }

  @override
  List<GeneratedColumn> get $columns => [id, title, date];
  @override
  $NoteFoldersTable get asDslTable => this;
  @override
  String get $tableName => _alias ?? 'note_folders';
  @override
  final String actualTableName = 'note_folders';
  @override
  VerificationContext validateIntegrity(Insertable<NoteFolder> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id'], _idMeta));
    }
    if (data.containsKey('title')) {
      context.handle(
          _titleMeta, title.isAcceptableOrUnknown(data['title'], _titleMeta));
    } else if (isInserting) {
      context.missing(_titleMeta);
    }
    if (data.containsKey('date')) {
      context.handle(
          _dateMeta, date.isAcceptableOrUnknown(data['date'], _dateMeta));
    } else if (isInserting) {
      context.missing(_dateMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  NoteFolder map(Map<String, dynamic> data, {String tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : null;
    return NoteFolder.fromData(data, _db, prefix: effectivePrefix);
  }

  @override
  $NoteFoldersTable createAlias(String alias) {
    return $NoteFoldersTable(_db, alias);
  }
}

class Note extends DataClass implements Insertable<Note> {
  final int id;
  final String title;
  final String description;
  final DateTime date;
  final int folder;
  Note(
      {@required this.id,
      this.title,
      this.description,
      @required this.date,
      this.folder});
  factory Note.fromData(Map<String, dynamic> data, GeneratedDatabase db,
      {String prefix}) {
    final effectivePrefix = prefix ?? '';
    final intType = db.typeSystem.forDartType<int>();
    final stringType = db.typeSystem.forDartType<String>();
    final dateTimeType = db.typeSystem.forDartType<DateTime>();
    return Note(
      id: intType.mapFromDatabaseResponse(data['${effectivePrefix}id']),
      title:
          stringType.mapFromDatabaseResponse(data['${effectivePrefix}title']),
      description: stringType
          .mapFromDatabaseResponse(data['${effectivePrefix}description']),
      date:
          dateTimeType.mapFromDatabaseResponse(data['${effectivePrefix}date']),
      folder: intType.mapFromDatabaseResponse(data['${effectivePrefix}folder']),
    );
  }
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (!nullToAbsent || id != null) {
      map['id'] = Variable<int>(id);
    }
    if (!nullToAbsent || title != null) {
      map['title'] = Variable<String>(title);
    }
    if (!nullToAbsent || description != null) {
      map['description'] = Variable<String>(description);
    }
    if (!nullToAbsent || date != null) {
      map['date'] = Variable<DateTime>(date);
    }
    if (!nullToAbsent || folder != null) {
      map['folder'] = Variable<int>(folder);
    }
    return map;
  }

  NotesCompanion toCompanion(bool nullToAbsent) {
    return NotesCompanion(
      id: id == null && nullToAbsent ? const Value.absent() : Value(id),
      title:
          title == null && nullToAbsent ? const Value.absent() : Value(title),
      description: description == null && nullToAbsent
          ? const Value.absent()
          : Value(description),
      date: date == null && nullToAbsent ? const Value.absent() : Value(date),
      folder:
          folder == null && nullToAbsent ? const Value.absent() : Value(folder),
    );
  }

  factory Note.fromJson(Map<String, dynamic> json,
      {ValueSerializer serializer}) {
    serializer ??= moorRuntimeOptions.defaultSerializer;
    return Note(
      id: serializer.fromJson<int>(json['id']),
      title: serializer.fromJson<String>(json['title']),
      description: serializer.fromJson<String>(json['description']),
      date: serializer.fromJson<DateTime>(json['date']),
      folder: serializer.fromJson<int>(json['folder']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer serializer}) {
    serializer ??= moorRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'title': serializer.toJson<String>(title),
      'description': serializer.toJson<String>(description),
      'date': serializer.toJson<DateTime>(date),
      'folder': serializer.toJson<int>(folder),
    };
  }

  Note copyWith(
          {int id,
          String title,
          String description,
          DateTime date,
          int folder}) =>
      Note(
        id: id ?? this.id,
        title: title ?? this.title,
        description: description ?? this.description,
        date: date ?? this.date,
        folder: folder ?? this.folder,
      );
  @override
  String toString() {
    return (StringBuffer('Note(')
          ..write('id: $id, ')
          ..write('title: $title, ')
          ..write('description: $description, ')
          ..write('date: $date, ')
          ..write('folder: $folder')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => $mrjf($mrjc(
      id.hashCode,
      $mrjc(title.hashCode,
          $mrjc(description.hashCode, $mrjc(date.hashCode, folder.hashCode)))));
  @override
  bool operator ==(dynamic other) =>
      identical(this, other) ||
      (other is Note &&
          other.id == this.id &&
          other.title == this.title &&
          other.description == this.description &&
          other.date == this.date &&
          other.folder == this.folder);
}

class NotesCompanion extends UpdateCompanion<Note> {
  final Value<int> id;
  final Value<String> title;
  final Value<String> description;
  final Value<DateTime> date;
  final Value<int> folder;
  const NotesCompanion({
    this.id = const Value.absent(),
    this.title = const Value.absent(),
    this.description = const Value.absent(),
    this.date = const Value.absent(),
    this.folder = const Value.absent(),
  });
  NotesCompanion.insert({
    this.id = const Value.absent(),
    this.title = const Value.absent(),
    this.description = const Value.absent(),
    @required DateTime date,
    this.folder = const Value.absent(),
  }) : date = Value(date);
  static Insertable<Note> custom({
    Expression<int> id,
    Expression<String> title,
    Expression<String> description,
    Expression<DateTime> date,
    Expression<int> folder,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (title != null) 'title': title,
      if (description != null) 'description': description,
      if (date != null) 'date': date,
      if (folder != null) 'folder': folder,
    });
  }

  NotesCompanion copyWith(
      {Value<int> id,
      Value<String> title,
      Value<String> description,
      Value<DateTime> date,
      Value<int> folder}) {
    return NotesCompanion(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      date: date ?? this.date,
      folder: folder ?? this.folder,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (title.present) {
      map['title'] = Variable<String>(title.value);
    }
    if (description.present) {
      map['description'] = Variable<String>(description.value);
    }
    if (date.present) {
      map['date'] = Variable<DateTime>(date.value);
    }
    if (folder.present) {
      map['folder'] = Variable<int>(folder.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('NotesCompanion(')
          ..write('id: $id, ')
          ..write('title: $title, ')
          ..write('description: $description, ')
          ..write('date: $date, ')
          ..write('folder: $folder')
          ..write(')'))
        .toString();
  }
}

class $NotesTable extends Notes with TableInfo<$NotesTable, Note> {
  final GeneratedDatabase _db;
  final String _alias;
  $NotesTable(this._db, [this._alias]);
  final VerificationMeta _idMeta = const VerificationMeta('id');
  GeneratedIntColumn _id;
  @override
  GeneratedIntColumn get id => _id ??= _constructId();
  GeneratedIntColumn _constructId() {
    return GeneratedIntColumn('id', $tableName, false,
        hasAutoIncrement: true, declaredAsPrimaryKey: true);
  }

  final VerificationMeta _titleMeta = const VerificationMeta('title');
  GeneratedTextColumn _title;
  @override
  GeneratedTextColumn get title => _title ??= _constructTitle();
  GeneratedTextColumn _constructTitle() {
    return GeneratedTextColumn(
      'title',
      $tableName,
      true,
    );
  }

  final VerificationMeta _descriptionMeta =
      const VerificationMeta('description');
  GeneratedTextColumn _description;
  @override
  GeneratedTextColumn get description =>
      _description ??= _constructDescription();
  GeneratedTextColumn _constructDescription() {
    return GeneratedTextColumn(
      'description',
      $tableName,
      true,
    );
  }

  final VerificationMeta _dateMeta = const VerificationMeta('date');
  GeneratedDateTimeColumn _date;
  @override
  GeneratedDateTimeColumn get date => _date ??= _constructDate();
  GeneratedDateTimeColumn _constructDate() {
    return GeneratedDateTimeColumn(
      'date',
      $tableName,
      false,
    );
  }

  final VerificationMeta _folderMeta = const VerificationMeta('folder');
  GeneratedIntColumn _folder;
  @override
  GeneratedIntColumn get folder => _folder ??= _constructFolder();
  GeneratedIntColumn _constructFolder() {
    return GeneratedIntColumn('folder', $tableName, true,
        $customConstraints: 'NULLABLE REFERENCES noteFolders(id)');
  }

  @override
  List<GeneratedColumn> get $columns => [id, title, description, date, folder];
  @override
  $NotesTable get asDslTable => this;
  @override
  String get $tableName => _alias ?? 'notes';
  @override
  final String actualTableName = 'notes';
  @override
  VerificationContext validateIntegrity(Insertable<Note> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id'], _idMeta));
    }
    if (data.containsKey('title')) {
      context.handle(
          _titleMeta, title.isAcceptableOrUnknown(data['title'], _titleMeta));
    }
    if (data.containsKey('description')) {
      context.handle(
          _descriptionMeta,
          description.isAcceptableOrUnknown(
              data['description'], _descriptionMeta));
    }
    if (data.containsKey('date')) {
      context.handle(
          _dateMeta, date.isAcceptableOrUnknown(data['date'], _dateMeta));
    } else if (isInserting) {
      context.missing(_dateMeta);
    }
    if (data.containsKey('folder')) {
      context.handle(_folderMeta,
          folder.isAcceptableOrUnknown(data['folder'], _folderMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Note map(Map<String, dynamic> data, {String tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : null;
    return Note.fromData(data, _db, prefix: effectivePrefix);
  }

  @override
  $NotesTable createAlias(String alias) {
    return $NotesTable(_db, alias);
  }
}

abstract class _$NoteTakerDatabase extends GeneratedDatabase {
  _$NoteTakerDatabase(QueryExecutor e)
      : super(SqlTypeSystem.defaultInstance, e);
  $TasksTable _tasks;
  $TasksTable get tasks => _tasks ??= $TasksTable(this);
  $TaskFoldersTable _taskFolders;
  $TaskFoldersTable get taskFolders => _taskFolders ??= $TaskFoldersTable(this);
  $NoteFoldersTable _noteFolders;
  $NoteFoldersTable get noteFolders => _noteFolders ??= $NoteFoldersTable(this);
  $NotesTable _notes;
  $NotesTable get notes => _notes ??= $NotesTable(this);
  TaskDao _taskDao;
  TaskDao get taskDao => _taskDao ??= TaskDao(this as NoteTakerDatabase);
  NoteDao _noteDao;
  NoteDao get noteDao => _noteDao ??= NoteDao(this as NoteTakerDatabase);
  TaskFolderDao _taskFolderDao;
  TaskFolderDao get taskFolderDao =>
      _taskFolderDao ??= TaskFolderDao(this as NoteTakerDatabase);
  NoteFolderDao _noteFolderDao;
  NoteFolderDao get noteFolderDao =>
      _noteFolderDao ??= NoteFolderDao(this as NoteTakerDatabase);
  @override
  Iterable<TableInfo> get allTables => allSchemaEntities.whereType<TableInfo>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities =>
      [tasks, taskFolders, noteFolders, notes];
}

// **************************************************************************
// DaoGenerator
// **************************************************************************

mixin _$TaskDaoMixin on DatabaseAccessor<NoteTakerDatabase> {
  $TasksTable get tasks => attachedDatabase.tasks;
  $TaskFoldersTable get taskFolders => attachedDatabase.taskFolders;
}
mixin _$NoteDaoMixin on DatabaseAccessor<NoteTakerDatabase> {
  $NotesTable get notes => attachedDatabase.notes;
  $NoteFoldersTable get noteFolders => attachedDatabase.noteFolders;
}
mixin _$TaskFolderDaoMixin on DatabaseAccessor<NoteTakerDatabase> {
  $TaskFoldersTable get taskFolders => attachedDatabase.taskFolders;
}
mixin _$NoteFolderDaoMixin on DatabaseAccessor<NoteTakerDatabase> {
  $NoteFoldersTable get noteFolders => attachedDatabase.noteFolders;
}

class Task {
  //These are the fields for the Task class
  int id;
  String description;
  String date;
  bool checkbox = false;
  int taskFolderId;

  //These are the constructors for the Task class
  //The getters and setters are baked in via the curly braces and parentheses
  Task(
      {this.description,
      this.date,
      this.checkbox = false,
      this.taskFolderId,
      this.id});

  Task.withId(
      {this.id,
      this.checkbox = false,
      this.date,
      this.description,
      this.taskFolderId});

  //TODO: Might want to add more validators to each setter to control for errors and bugs

  //Convert a Task Object into a Map Object for database
  Map<String, dynamic> toMap() {
    var map = Map<String, dynamic>();
    map['description'] = this.description;
    map['date'] = this.date;
    map['checkbox'] = this.checkbox == false ? 1 : 0;
    map['taskFolderId'] = this.taskFolderId;
    //Allow for auto-increment
    if (id != null) {
      map['id'] = id;
    }

    return map;
  }

  //Convert a Map object back into a Task Object
  Task.fromMapObject(Map<String, dynamic> map) {
    this.id = map['id'];
    this.description = map['description'];
    this.date = map['date'];
    this.checkbox = map['checkbox'] == 0 ? true : false;
    this.taskFolderId = map['taskFolderId'];
  }
}

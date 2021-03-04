class TaskFolder {
  //These are the fields for the Folder class
  int _id;
  String _title;
  String _date;

  //These are the constructors for the Folder class
  TaskFolder(this._title, this._date);

  TaskFolder.withId(this._id, this._title, this._date);

  //These are the getters for the Folder class
  int get id => _id;
  String get title => _title;
  String get date => _date;

  //These are the setters for the Folder class. Dont need a setter for ID because it will be automatically assigned within the database
  set title(String newTitle) {
    if (newTitle.length <= 255) {
      this._title = newTitle;
    }
  }

  set date(String newDate) {
    this._date = newDate;
  }

  //Convert a Folder Object into a Map Object for database
  Map<String, dynamic> toMap() {
    var map = Map<String, dynamic>();

    if (id != null) {
      map['id'] = _id;
    }
    map['title'] = _title;
    map['date'] = _date;

    return map;
  }

  //Convert a Map object back into a Folder Object
  TaskFolder.fromMapObject(Map<String, dynamic> map) {
    this._id = map['id'];
    this._title = map['title'];
    this._date = map['date'];
  }
}

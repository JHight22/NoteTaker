class Note {
  //These are the fields for the Note class
  int _id;
  String _title;
  String _description;
  String _date;
  int _noteFolderId;

  //These are the constructors for the Note class
  Note(this._description, this._date, this._title, [this._noteFolderId]);

  Note.withId(this._id, this._title, this._date, this._noteFolderId,
      [this._description]);

  //These are the getters for the Note class
  int get id => _id;
  String get title => _title;
  String get description => _description;
  String get date => _date;
  int get folderId => _noteFolderId;

  //These are the setters for the Note class. Dont need a setter for ID because it will be automatically assigned within the database
  //TODO: Might want to add more validators to each setter to control for errors and bugs
  set title(String newTitle) {
    if (newTitle.length <= 100) {
      this._title = newTitle;
    }
  }

  set description(String newDescription) {
    if (newDescription.length <= 2000) {
      this._description = newDescription;
    }
  }

  set date(String newDate) {
    this._date = newDate;
  }

  set folderId(int newFolderId) {
    this._noteFolderId = newFolderId;
  }

  //Convert a Note Object into a Map Object for database
  Map<String, dynamic> toMap() {
    var map = Map<String, dynamic>();

    if (id != null) {
      map['id'] = _id;
    }
    map['title'] = _title;
    map['description'] = _description;
    map['date'] = _date;
    map['noteFolderId'] = _noteFolderId;

    return map;
  }

  //Convert a Map object back into a Note Object
  Note.fromMapObject(Map<String, dynamic> map) {
    this._id = map['id'];
    this._title = map['title'];
    this._description = map['description'];
    this._date = map['date'];
    this._noteFolderId = map['noteFolderId'];
  }
}

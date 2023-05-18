class Note {
  String textNote;
  Note(this.textNote);

  Note.fromMap(Map map) : textNote = map['textNote'];

  Map toMap() {
    return {
      'textNote': textNote,
    };
  }
}

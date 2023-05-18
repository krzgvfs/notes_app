// ignore_for_file: camel_case_types

import 'package:shared_preferences/shared_preferences.dart';

import 'model.dart';

class prefranceServer {
  saveServer(Note note) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('note', note.textNote);
  }

  Future<Note> getServer() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var noteText = prefs.getString('note');

    return Note(noteText!);
  }
}

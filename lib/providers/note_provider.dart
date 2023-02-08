import 'package:flutter/material.dart';
import 'package:vp12_database/database/controller/note_db_controller.dart';
import 'package:vp12_database/models/note.dart';

class NoteProvider extends ChangeNotifier{

  List<Note> notes = <Note>[];
  bool loading = false;

  final NoteDbController _dbController = NoteDbController();

  void read() async {
    loading = true;
    notes = await _dbController.read();
    loading = false;
    notifyListeners();
  }

  Future<bool> create({required Note note}) async {
    int newRowId = await _dbController.create(note);
    if(newRowId != 0) {
      note.id = newRowId;
      notes.add(note);
      notifyListeners();
    }
    return newRowId != 0;
  }

  Future<bool> delete(/*int id*/ int index) async {
    bool deleted = await _dbController.delete(notes[index].id);
    if(deleted) {
      notes.removeAt(index);
      notifyListeners();
      //****************
      // notes.removeWhere((element) => element.id == id);
      // notifyListeners();
      //****************
      // int index = notes.indexWhere((element) => element.id == id);
      // if(index != -1) {
      //   notes.removeAt(index);
      //   notifyListeners();
      // }
    }
    return deleted;
  }

  Future<bool> update(Note updatedNote) async {
    bool updated = await _dbController.update(updatedNote);
    if(updated){
      int index = notes.indexWhere((element) => element.id == updatedNote.id);
      if(index != -1) {
        notes[index] = updatedNote;
        notifyListeners();
      }
    }
    return updated;
  }
}
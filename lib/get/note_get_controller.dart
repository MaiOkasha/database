import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:vp12_database/database/controller/note_db_controller.dart';
import 'package:vp12_database/models/note.dart';

class NoteGetController extends GetxController {

  // List<Note> notes = <Note>[];
  RxList<Note> notes = <Note>[].obs;
  RxBool loading = false.obs
  ;

  final NoteDbController _dbController = NoteDbController();

  static NoteGetController get to => Get.find();

  @override
  void onInit() {
    read();
    super.onInit();
  }

  void read() async {
    loading.value = true;
    notes.value = await _dbController.read();
    loading.value = false;
    // notifyListeners();
    // update(['NotesScreen-Read']);
  }

  Future<bool> create({required Note note}) async {
    int newRowId = await _dbController.create(note);
    if(newRowId != 0) {
      note.id = newRowId;
      notes.add(note);
      // notifyListeners();
      // update();
    }
    return newRowId != 0;
  }

  Future<bool> delete(/*int id*/ int index) async {
    bool deleted = await _dbController.delete(notes[index].id);
    if(deleted) {
      notes.removeAt(index);
      // notifyListeners();
      // update();
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

  Future<bool> updateNote(Note updatedNote) async {
    bool updated = await _dbController.update(updatedNote);
    if(updated){
      int index = notes.indexWhere((element) => element.id == updatedNote.id);
      if(index != -1) {
        notes[index] = updatedNote;
        // notifyListeners();
        // update();
      }
    }
    return updated;
  }
}
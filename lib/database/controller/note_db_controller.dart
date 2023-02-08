import 'package:sqflite/sqflite.dart';
import 'package:vp12_database/database/db_controller.dart';
import 'package:vp12_database/database/db_operations.dart';
import 'package:vp12_database/models/note.dart';
import 'package:vp12_database/storage/pref_controller.dart';

class NoteDbController implements DbOperations<Note> {
  Database database = DbController().database;

  @override
  Future<int> create(Note model) async {
    int newRowId = await database.insert('notes', model.toMap());
    return newRowId;
  }

  @override
  Future<bool> delete(int id) async {
    int countOfDeletedRows =
        await database.delete('notes', where: 'id = ?', whereArgs: [id]);
    return countOfDeletedRows == 1;
  }

  @override
  Future<List<Note>> read() async {
    List<Map<String, dynamic>> rows = await database.query(
      'notes',
      where: 'user_id = ?',
      whereArgs: [
        PrefController().getValueFor<int>(key: PrefKeys.id.toString())
      ],
    );
    return rows
        .map((Map<String, dynamic> rowMap) => Note.fromMap(rowMap))
        .toList();
  }

  @override
  Future<Note?> show(int id) async {
    List<Map<String, dynamic>> rows =
        await database.query('notes', where: 'id = ?', whereArgs: [id]);
    if (rows.isNotEmpty) {
      return Note.fromMap(rows.first);
    }
  }

  @override
  Future<bool> update(Note model) async {
    int countOfUpdatedRows = await database
        .update('notes', model.toMap(), where: 'id=?', whereArgs: [model.id]);
    return countOfUpdatedRows == 1;
  }
}

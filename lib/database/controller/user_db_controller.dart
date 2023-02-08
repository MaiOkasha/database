import 'package:sqflite/sqflite.dart';
import 'package:vp12_database/database/db_controller.dart';
import 'package:vp12_database/database/db_operations.dart';
import 'package:vp12_database/models/user.dart';
import 'package:vp12_database/storage/pref_controller.dart';

class UserDbController implements DbOperations<User> {
  Database database = DbController().database;

  Future<bool> login({required String email, required String password}) async {
    List<Map<String, dynamic>> maps = await database.query('users',where: 'email = ? AND password = ?',whereArgs: [email, password]);
    if(maps.isNotEmpty) {
      User user = User.fromMap(maps.first);
      await PrefController().save(user);
    }
    return maps.isNotEmpty;
  }

  @override
  Future<int> create(User model) async {
    //INSERT INTO users (name, email, password) VALUES ('Name','Email','Password');
    //INSERT INTO users ('Name','Email','Password');
    int newRowId = await database.insert('users', model.toMap());
    return newRowId;
  }

  @override
  Future<bool> delete(int id) async {
    //DELETE FROM users;
    //DELETE FROM users WHERE id = 1;
    int countOfDeletedRows =
        await database.delete('users', where: 'id = ?', whereArgs: [id]);
    return countOfDeletedRows == 1;
  }

  @override
  Future<List<User>> read() async {
    //SELECT * FROM users;
    //SELECT id,name FROM users;
    List<Map<String, dynamic>> rows = await database.query('users');
    return rows
        .map((Map<String, dynamic> rowMap) => User.fromMap(rowMap))
        .toList();
  }

  @override
  Future<User?> show(int id) async {
    //SELECT * FROM users WHERE id = 1;
    List<Map<String, dynamic>> rows = await database.query('users',where: 'id = ?', whereArgs: [id]);
    if(rows.isNotEmpty) {
      return User.fromMap(rows.first);
    }
  }

  @override
  Future<bool> update(User model) async {
    //UPDATE users SET name = 'Ahmed';
    //UPDATE users SET name = 'Ahmed' WHERE id = 1;
    int countOfUpdatedRows = await database
        .update('users', model.toMap(), where: 'id = ?', whereArgs: [model.id]);
    return countOfUpdatedRows == 1;
  }
}

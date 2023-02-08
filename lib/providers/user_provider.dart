import 'package:flutter/material.dart';
import 'package:vp12_database/database/controller/user_db_controller.dart';
import 'package:vp12_database/models/user.dart';

class UserProvider extends ChangeNotifier{

  final UserDbController _dbController = UserDbController();

  Future<bool> login({required String email, required String password}) async {
    return await _dbController.login(email: email, password: password);
  }

  Future<bool> create(User user)async {
    int newRowId = await _dbController.create(user);
    return newRowId != 0;
  }

  Future<bool> update(User user) async {
    return await _dbController.update(user);
  }

  Future<bool> delete(int id) async {
    return await _dbController.delete(id);
  }
}
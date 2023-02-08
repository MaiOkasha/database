import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:vp12_database/database/controller/user_db_controller.dart';
import 'package:vp12_database/models/user.dart';

class UserGetController extends GetxController{

  final UserDbController _dbController = UserDbController();

  static UserGetController get to => Get.find();

  Future<bool> login({required String email, required String password}) async {
    return await _dbController.login(email: email, password: password);
  }

  Future<bool> create(User user)async {
    int newRowId = await _dbController.create(user);
    return newRowId != 0;
  }

  Future<bool> updateUser(User user) async {
    return await _dbController.update(user);
  }

  Future<bool> delete(int id) async {
    return await _dbController.delete(id);
  }
}
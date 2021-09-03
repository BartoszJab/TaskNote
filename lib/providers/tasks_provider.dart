import 'package:daily_helper/database/database_helper.dart';
import 'package:daily_helper/models/task.dart';
import 'package:flutter/material.dart';

class TasksProvider with ChangeNotifier {

  void refresh() {
    notifyListeners();
  }

  Future<List<Task>> getAllTasks() async {
    return await DatabaseHelper.instance.getAllTasks();
  }

}

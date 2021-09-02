import 'package:daily_helper/models/subtask.dart';

class Task {
  final int? id;
  final String task;
  final String? description;
  final List<Subtask>? subtasks;

  const Task({this.id, required this.task, this.description, this.subtasks});

}
import 'dart:convert';

import 'package:daily_helper/models/subtask.dart';

class Task {
  final int? id;
  final String title;
  final String? description;
  final List<Subtask>? subtasks;

  const Task({this.id, required this.title, this.description, this.subtasks});

  factory Task.fromMap(Map<String, dynamic> json) => Task(
    id: json['id'] as int?,
    title: json['title'] as String,
    description: json['description'] as String?,
    subtasks: jsonDecode(json['subtasks'] as String) as List<Subtask>?,
  );

  Map<String, dynamic> toMap() {
    final String jsonSubtasks = jsonEncode(subtasks);
    return {
      'id': id,
      'title': title,
      'description': description,
      'subtasks': jsonSubtasks,
    };
  }
}
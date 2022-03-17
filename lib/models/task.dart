import 'dart:convert';

import 'package:daily_helper/models/subtask.dart';
import 'package:equatable/equatable.dart';

class Task extends Equatable {
  final int? id;
  final String title;
  final String? description;
  final List<Subtask>? subtasks;

  const Task({this.id, required this.title, this.description, this.subtasks});

  factory Task.fromMap(Map<String, dynamic> json) {
    // jsonDecode(json['subtasks']) returns an array of maps with Subtask fields
    final jsonSubtasks = jsonDecode(json['subtasks'] as String);
    final List<Subtask> subtasksList = [];
    for (final jsonMap in jsonSubtasks) {
      // we convert current map to a Subtask object and add it to a list
      final subtask = Subtask.fromJson(jsonMap as Map<String, dynamic>);
      subtasksList.add(subtask);
    }
    // we pass obtained subtasks list to the Task constructor as well as other fields
    return Task(
      id: json['id'] as int?,
      title: json['title'] as String,
      description: json['description'] as String?,
      subtasks: subtasksList,
    );
  }

  Map<String, dynamic> toMap() {
    final String jsonSubtasks = jsonEncode(subtasks);
    return {
      'id': id,
      'title': title,
      'description': description,
      'subtasks': jsonSubtasks,
    };
  }

  @override
  List<Object?> get props => [title, description, subtasks];
}

import 'package:daily_helper/database/database_helper.dart';
import 'package:daily_helper/models/task.dart';
import 'package:daily_helper/providers/tasks_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class RemoveTaskAlert extends StatelessWidget {
  final Task task;

  const RemoveTaskAlert(this.task);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Remove task'),
      content: Text(
          'Do you want to remove "${task.title}" task?'),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(
              context, 'Cancel'),
          child: const Text('Cancel'),
        ),
        TextButton(
          onPressed: () async {
            // remove task
            await DatabaseHelper.instance
                .remove(task.id!)
                .then((_)  {
              Provider.of<TasksProvider>(context, listen: false).refresh();
              Navigator.pop(context, 'OK');
            });
          },
          child: const Text('OK'),
        )
      ],
    );
  }
}

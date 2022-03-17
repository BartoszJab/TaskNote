import 'package:daily_helper/models/task.dart';
import 'package:daily_helper/providers/tasks_provider.dart';
import 'package:daily_helper/screens/create_task.dart';
import 'package:daily_helper/widgets/remove_task_alert.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const CreateTask(null),
            ),
          );
        },
        child: const Icon(Icons.add),
      ),
      appBar: AppBar(
        title: const Text('Task note'),
      ),
      body: Center(
        child: FutureBuilder<List<Task>>(
          future: Provider.of<TasksProvider>(context).getAllTasks(),
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return const Center(
                child: Text('Loading tasks...'),
              );
            }
            return snapshot.data!.isEmpty
                ? const Center(child: Text('No tasks to display'))
                : ListView.builder(
                    itemCount: snapshot.data!.length,
                    itemBuilder: (context, index) {
                      final currentTask = snapshot.data![index];
                      return GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => CreateTask(currentTask),
                            ),
                          );
                        },
                        child: Card(
                          child: ListTile(
                            title: Text(currentTask.title),
                            subtitle: (currentTask.subtasks == null ||
                                    currentTask.subtasks!.isEmpty)
                                ? null
                                : Text(
                                    'Subtasks done: '
                                    '${currentTask.subtasks!.where((subtask) => subtask.isChecked == true).toList().length}'
                                    ' / ${currentTask.subtasks!.length}',
                                  ),
                            trailing: IconButton(
                              icon: const Icon(Icons.delete_forever),
                              onPressed: () {
                                showDialog(
                                  context: context,
                                  builder: (BuildContext context) =>
                                      RemoveTaskAlert(currentTask),
                                );
                              },
                            ),
                          ),
                        ),
                      );
                    },
                  );
          },
        ),
      ),
    );
  }
}

import 'package:daily_helper/database/database_helper.dart';
import 'package:daily_helper/models/subtask.dart';
import 'package:daily_helper/models/task.dart';
import 'package:daily_helper/providers/tasks_provider.dart';
import 'package:daily_helper/widgets/task_input_field.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CreateTask extends StatefulWidget {
  final Task? currentTask;

  const CreateTask(this.currentTask);

  @override
  _CreateTaskState createState() => _CreateTaskState();
}

class _CreateTaskState extends State<CreateTask> {
  String? _title;
  String? _description;
  List<Subtask> _subtasks = [];
  late final DatabaseHelper _dbHelper;

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final _subtaskFieldController = TextEditingController();

  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    _dbHelper = DatabaseHelper.instance;
    _subtasks = [...?widget.currentTask?.subtasks];
    super.initState();
  }

  @override
  void dispose() {
    _subtaskFieldController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  Future<void> createOrUpdateTask() async {
    _formKey.currentState!.save();
    if (_title?.trim().isEmpty ?? true) return;

    // if null then task doesn't exist so create one
    if (widget.currentTask == null) {
      await _dbHelper
          .add(
            Task(
              title: _title!,
              description: _description,
              subtasks: _subtasks,
            ),
          )
          .then(
            (value) =>
                Provider.of<TasksProvider>(context, listen: false).refresh(),
          );
    } // else task exists so update it
    else {
      final newTask = Task(
        title: _title!,
        description: _description,
        subtasks: _subtasks,
      );
      if (widget.currentTask != newTask) {
        await _dbHelper
            .update(
              Task(
                id: widget.currentTask!.id,
                title: _title!,
                description: _description,
                subtasks: _subtasks,
              ),
            )
            .then(
              (value) =>
                  Provider.of<TasksProvider>(context, listen: false).refresh(),
            );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        createOrUpdateTask();
        return true;
      },
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          leading: GestureDetector(
            onTap: () {
              createOrUpdateTask();
              Navigator.of(context).pop();
            },
            child: const Icon(Icons.arrow_back),
          ),
          title: const Text('Task'),
        ),
        body: SafeArea(
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                Container(
                  padding: const EdgeInsets.only(left: 10, right: 10, top: 10),
                  child: Column(
                    children: [
                      TaskInputField(
                        initialValue: widget.currentTask?.title,
                        maxLength: 40,
                        hintText: 'Task title *',
                        isRequired: true,
                        onSaved: (String? titleFormValue) {
                          _title = titleFormValue;
                        },
                      ),
                      const SizedBox(
                        height: 20.0,
                      ),
                      TaskInputField(
                        initialValue: widget.currentTask?.description,
                        maxLength: 205,
                        minLines: 2,
                        maxLines: 2,
                        hintText: 'Task description',
                        isRequired: false,
                        onSaved: (String? descriptionFormValue) {
                          _description = descriptionFormValue;
                        },
                      ),
                      const SizedBox(
                        height: 20.0,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Expanded(
                            child: TextField(
                              controller: _subtaskFieldController,
                              minLines: 1,
                              maxLines: 4,
                              decoration: const InputDecoration(
                                hintText: 'Subtask to add',
                                contentPadding:
                                    EdgeInsets.symmetric(horizontal: 10),
                              ),
                            ),
                          ),
                          IconButton(
                            icon:
                                const Icon(Icons.add_box_outlined, size: 40.0),
                            onPressed: () {
                              if (_subtaskFieldController.text.isNotEmpty) {
                                setState(() {
                                  _subtasks.add(
                                    Subtask(
                                      subtaskText: _subtaskFieldController.text,
                                      isChecked: false,
                                    ),
                                  );
                                  _subtaskFieldController.text = '';
                                });
                              }
                            },
                          )
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                SizedBox(
                  height: 220,
                  child: Scrollbar(
                    isAlwaysShown: true,
                    controller: _scrollController,
                    child: ListView.builder(
                      controller: _scrollController,
                      shrinkWrap: true,
                      itemCount: _subtasks.length,
                      itemBuilder: (context, index) {
                        final subtask = _subtasks[index];
                        return CheckboxListTile(
                          value: subtask.isChecked,
                          onChanged: (value) {
                            setState(() {
                              _subtasks[index] =
                                  subtask.copyWith(isChecked: value);
                            });
                          },
                          secondary: IconButton(
                            icon: const Icon(Icons.highlight_remove_rounded),
                            onPressed: () {
                              setState(() {
                                _subtasks.removeAt(index);
                              });
                            },
                          ),
                          controlAffinity: ListTileControlAffinity.leading,
                          title: Text(subtask.subtaskText!),
                        );
                      },
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

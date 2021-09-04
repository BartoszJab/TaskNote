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
  List<Subtask> subtasks = [];

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final _subtaskFieldController = TextEditingController();

  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    subtasks = [...?widget.currentTask?.subtasks];
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          leading: GestureDetector(
            onTap: () {
              Navigator.pop(context);
            },
            child: const Icon(Icons.arrow_back),
          ),
          title: const Text('Create task'),
        ),
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 20.0),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                TaskInputField(
                  initialValue: widget.currentTask?.title,
                  maxLength: 40,
                  hintText: 'Task title',
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
                                EdgeInsets.symmetric(horizontal: 10)),
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.add_box_outlined, size: 40.0),
                      onPressed: () {
                        if (_subtaskFieldController.text.isNotEmpty) {
                          setState(() {
                            subtasks.add(Subtask(
                                subtaskText: _subtaskFieldController.text,
                                isChecked: false));
                            _subtaskFieldController.text = '';
                          });
                        }
                      },
                    )
                  ],
                ),
                const SizedBox(
                  height: 10,
                ),
                // TODO: make list view fill available height
                SizedBox(
                  height: 220,
                  child: Scrollbar(
                    isAlwaysShown: true,
                    controller: _scrollController,
                    child: ListView.builder(
                        controller: _scrollController,
                        shrinkWrap: true,
                        itemCount: subtasks.length,
                        itemBuilder: (context, index) {
                          final subtask = subtasks[index];
                          return CheckboxListTile(
                            value: subtask.isChecked,
                            onChanged: (value) {
                              setState(() {
                                subtask.isChecked = value;
                              });
                            },
                            secondary: IconButton(
                              icon: const Icon(Icons.highlight_remove_rounded),
                              onPressed: () {
                                setState(() {
                                  subtasks.removeAt(index);
                                });
                              },
                            ),
                            controlAffinity: ListTileControlAffinity.leading,
                            title: Text(subtask.subtaskText!),
                          );
                        }),
                  ),
                ),
                const Spacer(),
                // TODO: shorten this unclear if-else widget creation | toast when created/update task
                if (widget.currentTask == null)
                  TextButton(
                    onPressed: () async {
                      if (!_formKey.currentState!.validate()) return;

                      _formKey.currentState!.save();

                      await DatabaseHelper.instance
                          .add(Task(
                              title: _title!,
                              description: _description,
                              subtasks: subtasks))
                          .then((_) {
                        Provider.of<TasksProvider>(context, listen: false)
                            .refresh();
                        Navigator.pop(context);
                      });
                    },
                    child: const Text(
                      'Add task',
                      style: TextStyle(
                        fontSize: 25,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  )
                else
                  TextButton(
                      onPressed: () async {
                        if (!_formKey.currentState!.validate()) return;

                        _formKey.currentState!.save();

                        await DatabaseHelper.instance
                            .update(Task(
                                id: widget.currentTask!.id,
                                title: _title!,
                                description: _description,
                                subtasks: subtasks))
                            .then((_) => Provider.of<TasksProvider>(context,
                                    listen: false)
                                .refresh());
                      },
                      child: const Text(
                        'Update',
                        style: TextStyle(
                            fontSize: 25, fontWeight: FontWeight.bold),
                      )),
              ],
            ),
          ),
        ));
  }
}

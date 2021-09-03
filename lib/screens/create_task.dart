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

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  List<Subtask> testSubtasks = [
    Subtask(subtaskText: 'buy pepsi', isChecked: false),
    Subtask(subtaskText: 'help father', isChecked: true),
    Subtask(subtaskText: 'buy vegetables', isChecked: true),
    Subtask(subtaskText: 'buy taw', isChecked: true),
    Subtask(subtaskText: 'buy taw', isChecked: true),
    Subtask(subtaskText: 'buy taw', isChecked: true),
    Subtask(subtaskText: 'buy taw', isChecked: true)
  ];

  final ScrollController _scrollController = ScrollController();

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
                  children: const [
                    Expanded(
                      child: TextField(
                        minLines: 1,
                        maxLines: 4,
                        decoration: InputDecoration(
                            hintText: 'Subtask to add',
                            contentPadding:
                                EdgeInsets.symmetric(horizontal: 10)),
                      ),
                    ),
                    Icon(
                      Icons.add_box_outlined,
                      size: 40.0,
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
                        itemCount: testSubtasks.length,
                        itemBuilder: (context, index) {
                          final subtask = testSubtasks[index];
                          return CheckboxListTile(
                            value: subtask.isChecked,
                            onChanged: (value) {
                              setState(() {
                                subtask.isChecked = value;
                              });
                            },
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
                              subtasks: testSubtasks))
                          .then((_) =>
                              Provider.of<TasksProvider>(context, listen: false)
                                  .refresh());
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
                                subtasks: testSubtasks))
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

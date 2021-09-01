import 'package:daily_helper/widgets/task_input_field.dart';
import 'package:flutter/material.dart';

class CreateTask extends StatelessWidget {
  const CreateTask({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    String? _title;
    String? _description;

    final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

    return Scaffold(
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
                  hintText: 'Task title',
                  isRequired: true,
                  onSaved: (String? titleFormValue) {
                    _title = titleFormValue;
                  },
                ),
                const SizedBox(height: 20.0,),
                TaskInputField(
                  hintText: 'Task description',
                  isRequired: false,
                  onSaved: (String? descriptionFormValue) {
                    _description = descriptionFormValue;
                  },
                ),
                const SizedBox(height: 20.0,),
                TextButton(
                  onPressed: () {
                    if (!_formKey.currentState!.validate()) return;

                    _formKey.currentState!.save();

                    print('Title: $_title; Description: $_description');
                  },

                  child: const Text('Add task'),
                )
              ],
            ),
          ),
        ));
  }
}

import 'package:flutter/material.dart';

class TaskInputField extends StatelessWidget {
  final String? hintText;
  final bool isRequired;
  final Function(String?) onSaved;

  const TaskInputField(
      {this.hintText, required this.isRequired, required this.onSaved});

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      decoration: InputDecoration(
        hintText: hintText,
        fillColor: Colors.white,
        filled: true,
      ),
      initialValue: '',
      validator: (String? value) {
        if (value!.isEmpty && isRequired) {
          return 'This field cannot be empty';
        }
        return null;
      },
      onSaved: onSaved,
    );
  }
}

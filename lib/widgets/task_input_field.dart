import 'package:flutter/material.dart';

class TaskInputField extends StatelessWidget {
  final String? hintText;
  final bool isRequired;
  final Function(String?) onSaved;
  final int? minLines;
  final int? maxLines;
  final int? maxLength;
  final String? initialValue;

  const TaskInputField(
      {this.hintText,
      required this.isRequired,
      required this.onSaved,
      this.minLines,
      this.maxLines,
      this.maxLength,
      this.initialValue});

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      minLines: minLines,
      maxLines: maxLines,
      maxLength: maxLength,
      decoration: InputDecoration(
        counterText: '',
        hintText: hintText,
        fillColor: Colors.white,
        filled: true,
      ),
      initialValue: initialValue,
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

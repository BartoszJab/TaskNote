import 'package:flutter/material.dart';

class CreateTask extends StatelessWidget {
  const CreateTask({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
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
      body: const Center(
        child: Center(
          child: Text('Create task screen'),
        ),
      ),
    );
  }
}

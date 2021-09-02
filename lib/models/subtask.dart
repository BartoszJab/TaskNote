class Subtask {
  final String subtaskText;
  bool isChecked;

  Subtask({required this.subtaskText, required this.isChecked});

  Map toJson() => {
    'subtaskText': subtaskText,
    'isChecked': isChecked
  };
}
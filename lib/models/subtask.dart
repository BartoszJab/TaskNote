class Subtask {
  String? subtaskText;
  bool? isChecked;

  Subtask({required this.subtaskText, required this.isChecked});

  Map toJson() => {'subtaskText': subtaskText, 'isChecked': isChecked};

  Subtask.fromJson(Map<String, dynamic> json)
      : subtaskText = json['subtaskText'] as String?,
        isChecked = json['isChecked'] as bool?;
}

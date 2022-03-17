import 'package:equatable/equatable.dart';

class Subtask extends Equatable {
  final String? subtaskText;
  final bool? isChecked;

  const Subtask({required this.subtaskText, required this.isChecked});

  Map toJson() => {'subtaskText': subtaskText, 'isChecked': isChecked};

  Subtask.fromJson(Map<String, dynamic> json)
      : subtaskText = json['subtaskText'] as String?,
        isChecked = json['isChecked'] as bool?;

  Subtask copyWith({String? subtaskText, bool? isChecked}) => Subtask(
        subtaskText: subtaskText ?? this.subtaskText,
        isChecked: isChecked ?? this.isChecked,
      );

  @override
  List<Object?> get props => [subtaskText, isChecked];
}

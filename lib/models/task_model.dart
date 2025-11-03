// lib/models/task_model.dart
class TaskModel {
  final String id;
  String title;
  String description;
  bool isCompleted;
  DateTime? reminderTime;
  DateTime createdAt;

  

  TaskModel({
    required this.id,
    required this.title,
    this.description = '',
    this.isCompleted = false,
    this.reminderTime,
    DateTime? createdAt,
  }) : createdAt = createdAt ?? DateTime.now();


  // Serialización a JSON (Map)
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'isCompleted': isCompleted,
      'reminderTime': reminderTime?.toIso8601String(),
      'createdAt': createdAt.toIso8601String(),
    };
  }

  // Deserialización desde JSON (Map)
  factory TaskModel.fromJson(Map<String, dynamic> json) {
    return TaskModel(
      id: json['id'] as String,
      title: json['title'] as String,
      description: (json['description'] as String?) ?? '',
      isCompleted: (json['isCompleted'] as bool?) ?? false,
      reminderTime: json['reminderTime'] != null
          ? DateTime.parse(json['reminderTime'] as String)
          : null,
      createdAt: json['createdAt'] != null
          ? DateTime.parse(json['createdAt'] as String)
          : DateTime.now(),
    );
  }
}

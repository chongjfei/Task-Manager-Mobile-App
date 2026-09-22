import 'package:hive/hive.dart';

part 'task.g.dart';

@HiveType(typeId: 0)
class Task extends HiveObject {
  @HiveField(0)
  String id;

  @HiveField(1)
  String title;

  @HiveField(2)
  String description;

  @HiveField(3)
  DateTime? dueDate;

  @HiveField(4)
  String category;

  @HiveField(5)
  bool isCompleted;

  @HiveField(6)
  DateTime createdAt;

  @HiveField(7)
  int? notificationId;

  Task({
    required this.id,
    required this.title,
    this.description = '',
    this.dueDate,
    this.category = 'General',
    this.isCompleted = false,
    DateTime? createdAt,
    this.notificationId,
  }) : createdAt = createdAt ?? DateTime.now();
}

import 'package:flutter/foundation.dart';
import 'package:hive/hive.dart';
import '../models/task.dart';
import '../services/notification_service.dart';

class TaskProvider extends ChangeNotifier {
  final Box<Task> _box = Hive.box<Task>('tasks');

  String _searchQuery = '';
  String? _selectedCategory;

  List<Task> get allTasks => _box.values.toList()
    ..sort((a, b) =>
        (a.dueDate ?? DateTime(2100)).compareTo(b.dueDate ?? DateTime(2100)));

  List<Task> get filteredTasks {
    return allTasks.where((task) {
      final matchesSearch = _searchQuery.isEmpty ||
          task.title.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          task.description.toLowerCase().contains(_searchQuery.toLowerCase());
      final matchesCategory =
          _selectedCategory == null || task.category == _selectedCategory;
      return matchesSearch && matchesCategory;
    }).toList();
  }

  List<String> get categories =>
      allTasks.map((t) => t.category).toSet().toList()..sort();

  String get searchQuery => _searchQuery;
  String? get selectedCategory => _selectedCategory;

  void setSearchQuery(String query) {
    _searchQuery = query;
    notifyListeners();
  }

  void setCategoryFilter(String? category) {
    _selectedCategory = category;
    notifyListeners();
  }

  Future<void> addTask(Task task) async {
    await _box.put(task.id, task);
    if (task.dueDate != null) {
      task.notificationId = await NotificationService.scheduleTaskReminder(task);
      await task.save();
    }
    notifyListeners();
  }

  Future<void> updateTask(Task task) async {
    if (task.notificationId != null) {
      await NotificationService.cancelReminder(task.notificationId!);
      task.notificationId = null;
    }
    if (task.dueDate != null && !task.isCompleted) {
      task.notificationId = await NotificationService.scheduleTaskReminder(task);
    }
    await task.save();
    notifyListeners();
  }

  Future<void> deleteTask(Task task) async {
    if (task.notificationId != null) {
      await NotificationService.cancelReminder(task.notificationId!);
    }
    await task.delete();
    notifyListeners();
  }

  Future<void> toggleComplete(Task task) async {
    task.isCompleted = !task.isCompleted;
    if (task.isCompleted && task.notificationId != null) {
      await NotificationService.cancelReminder(task.notificationId!);
      task.notificationId = null;
    }
    await task.save();
    notifyListeners();
  }
}

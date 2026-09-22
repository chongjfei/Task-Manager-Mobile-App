import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/task.dart';

/// Optional cloud sync backed by Cloud Firestore.
///
/// This is a bonus feature and is NOT wired into the UI by default, since it
/// requires a Firebase project. To enable it:
///   1. Run `flutterfire configure` in the project root (see README).
///   2. Call `Firebase.initializeApp()` in main() before runApp().
///   3. Call SyncService methods from TaskProvider where desired.
class SyncService {
  final CollectionReference _tasksRef =
      FirebaseFirestore.instance.collection('tasks');

  Future<void> pushTask(Task task) async {
    await _tasksRef.doc(task.id).set({
      'id': task.id,
      'title': task.title,
      'description': task.description,
      'dueDate': task.dueDate?.toIso8601String(),
      'category': task.category,
      'isCompleted': task.isCompleted,
      'createdAt': task.createdAt.toIso8601String(),
    });
  }

  Future<void> deleteTask(String id) async {
    await _tasksRef.doc(id).delete();
  }

  Stream<List<Map<String, dynamic>>> watchTasks() {
    return _tasksRef.snapshots().map(
          (snap) => snap.docs
              .map((d) => d.data() as Map<String, dynamic>)
              .toList(),
        );
  }
}

import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest.dart' as tzdata;
import '../models/task.dart';

/// Wraps flutter_local_notifications to schedule/cancel due-date reminders.
class NotificationService {
  static final FlutterLocalNotificationsPlugin _plugin =
      FlutterLocalNotificationsPlugin();

  static Future<void> init() async {
    tzdata.initializeTimeZones();
    const androidSettings =
        AndroidInitializationSettings('@mipmap/ic_launcher');
    const iosSettings = DarwinInitializationSettings();
    const settings = InitializationSettings(
      android: androidSettings,
      iOS: iosSettings,
    );
    await _plugin.initialize(settings);
  }

  /// Schedules a reminder at the task's due date. Returns the notification
  /// id (to allow cancelling later) or null if no due date was set.
  static Future<int?> scheduleTaskReminder(Task task) async {
    if (task.dueDate == null || task.dueDate!.isBefore(DateTime.now())) {
      return null;
    }
    final id = task.id.hashCode & 0x7fffffff;
    const androidDetails = AndroidNotificationDetails(
      'task_reminders',
      'Task Reminders',
      channelDescription: 'Reminders for upcoming tasks',
      importance: Importance.high,
      priority: Priority.high,
    );
    const details = NotificationDetails(android: androidDetails);

    await _plugin.zonedSchedule(
      id,
      'Task Due: ${task.title}',
      task.description.isEmpty ? 'Your task is due now' : task.description,
      tz.TZDateTime.from(task.dueDate!, tz.local),
      details,
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
    );
    return id;
  }

  static Future<void> cancelReminder(int id) async {
    await _plugin.cancel(id);
  }
}

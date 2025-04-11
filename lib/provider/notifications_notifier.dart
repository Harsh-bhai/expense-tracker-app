import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:flutter/material.dart';

class Reminder {
  final int id;
  final String name;
  final DateTime time;
  final bool isDaily;
  bool isEnabled;

  Reminder({
    required this.id,
    required this.name,
    required this.time,
    this.isDaily = false,
    this.isEnabled = true,
  });
}

class NotificationsNotifier extends ChangeNotifier {
  final List<Reminder> _reminders = [];

  List<Reminder> get reminders => _reminders;

  Future<void> scheduleReminderNotification(Reminder reminder) async {
    await AwesomeNotifications().createNotification(
      content: NotificationContent(
        id: reminder.id,
        channelKey: 'reminder_channel',
        title: reminder.name,
        body: 'Reminder: ${reminder.name}',
        notificationLayout: NotificationLayout.Default,
        wakeUpScreen: true,
        category: NotificationCategory.Reminder,
        displayOnForeground: true,
        displayOnBackground: true,
      ),
      schedule: reminder.isDaily
          ? NotificationCalendar(
              hour: reminder.time.hour,
              minute: reminder.time.minute,
              second: 0,
              repeats: true,
              timeZone: await AwesomeNotifications().getLocalTimeZoneIdentifier(),
              preciseAlarm: true,
              allowWhileIdle: true,
            )
          : NotificationCalendar(
              year: reminder.time.year,
              month: reminder.time.month,
              day: reminder.time.day,
              hour: reminder.time.hour,
              minute: reminder.time.minute,
              second: 0,
              timeZone: await AwesomeNotifications().getLocalTimeZoneIdentifier(),
              preciseAlarm: true,
              allowWhileIdle: true,
            ),
    );
    notifyListeners();
  }

  void addReminder(Reminder reminder) {
    _reminders.add(reminder);
    scheduleReminderNotification(reminder);
    notifyListeners();
  }

  void updateReminder(Reminder updatedReminder) {
    final index = _reminders.indexWhere((r) => r.id == updatedReminder.id);
    if (index != -1) {
      _reminders[index] = updatedReminder;
      scheduleReminderNotification(updatedReminder);
      notifyListeners();
    }
  }

  Future<void> toggleReminder(int id, bool enabled) async {
    final reminder = _reminders.firstWhere((r) => r.id == id);
    reminder.isEnabled = enabled;
    if (enabled) {
      await scheduleReminderNotification(reminder);
    } else {
      await cancelNotification(id);
    }
    notifyListeners();
  }

  Future<void> cancelNotification(int id) async {
    await AwesomeNotifications().cancel(id);
  }
}

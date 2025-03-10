import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:expense_tracker/provider/notifications_notifier.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class NotificationsPage extends StatefulWidget {
  const NotificationsPage({super.key});

  @override
  State<NotificationsPage> createState() => _NotificationsPageState();
}

class _NotificationsPageState extends State<NotificationsPage> {
  DateTime? _selectedDateTime;

  void _pickDateTime(BuildContext context) async {
    await AwesomeNotifications().isNotificationAllowed().then((isAllowed) {
    if (!isAllowed) {
      AwesomeNotifications().requestPermissionToSendNotifications();
    }
  });
    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2030),
    );

    if (pickedDate != null) {
      TimeOfDay? pickedTime = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.now(),
      );

      if (pickedTime != null) {
        setState(() {
          _selectedDateTime = DateTime(
            pickedDate.year,
            pickedDate.month,
            pickedDate.day,
            pickedTime.hour,
            pickedTime.minute,
          );
        });
      }
    }
  }

  void _scheduleReminder(BuildContext context) {
    if (_selectedDateTime != null) {
      Provider.of<NotificationsNotifier>(context, listen: false)
          .scheduleReminderNotification(
        id: DateTime.now().millisecondsSinceEpoch.remainder(100000),
        title: 'Reminder',
        body: 'Don\'t forget to categorize your transaction!',
        scheduleTime: _selectedDateTime!,
      );
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Reminder set for $_selectedDateTime')),
      );
    }
  }

  void triggerTestNotification() {
  AwesomeNotifications().createNotification(
    content: NotificationContent(
      id: 1234,
      channelKey: 'reminder_channel',
      title: 'Test Notification',
      body: 'This is a test notification to check if everything is working!',
      notificationLayout: NotificationLayout.Default,
    ),
  );
}


  @override
  Widget build(BuildContext context) {
    
    return Scaffold(
      appBar: AppBar(title: const Text('Set Transaction Reminder')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(onPressed: triggerTestNotification, child: const Text('CHECK')),
            Text(_selectedDateTime != null
                ? 'Selected: $_selectedDateTime'
                : 'Pick a date and time'),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () => _pickDateTime(context),
              child: const Text('Pick Date & Time'),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () => _scheduleReminder(context),
              child: const Text('Set Reminder'),
            ),
          ],
        ),
      ),
    );
  }
}

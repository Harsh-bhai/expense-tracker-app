import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:expense_tracker/provider/notifications_notifier.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class BudgetPage extends StatefulWidget {
  const BudgetPage({super.key});

  @override
  State<BudgetPage> createState() => _BudgetPageState();
}

class _BudgetPageState extends State<BudgetPage> {
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

  // void _scheduleReminder(BuildContext context) {
  //   if (_selectedDateTime != null) {
  //     Provider.of<NotificationsNotifier>(context, listen: false)
  //         .scheduleReminderNotification(
  //       id: DateTime.now().millisecondsSinceEpoch.remainder(100000),
  //       title: 'Reminder',
  //       body: 'Don\'t forget to categorize your transaction!',
  //       scheduleTime: _selectedDateTime!,
  //     );
  //     ScaffoldMessenger.of(context).showSnackBar(
  //       SnackBar(content: Text('Reminder set for $_selectedDateTime')),
  //     );
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    
    return Scaffold(
      appBar: AppBar(title: const Text('Set Transaction Reminder')),
      body: const Center(
        child: Text("comming soon"),
      ));
  }
}

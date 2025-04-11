import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:expense_tracker/provider/notifications_notifier.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class NotificationsPage extends StatefulWidget {
  const NotificationsPage({super.key});

  @override
  State<NotificationsPage> createState() => _NotificationsPageState();
}

class _NotificationsPageState extends State<NotificationsPage> {
  DateTime? _selectedDateTime;
  final TextEditingController _nameController = TextEditingController();
  bool _isDaily = false;

  void _pickDateTime(BuildContext context, {Reminder? existing}) async {
    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: existing?.time ?? DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2030),
    );

    if (pickedDate != null) {
      TimeOfDay? pickedTime = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.fromDateTime(existing?.time ?? DateTime.now()),
      );

      if (pickedTime != null) {
        _selectedDateTime = DateTime(
          pickedDate.year,
          pickedDate.month,
          pickedDate.day,
          pickedTime.hour,
          pickedTime.minute,
        );

        _nameController.text = existing?.name ?? '';
        _isDaily = existing?.isDaily ?? false;

        _showReminderDialog(context, existing: existing);
      }
    }
  }

  void _showReminderDialog(BuildContext context, {Reminder? existing}) {
    showDialog(
      context: context,
      builder: (_) {
        return AlertDialog(
          title: Text(existing != null ? 'Edit Reminder' : 'New Reminder'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: _nameController,
                decoration: const InputDecoration(labelText: 'Reminder Name'),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('Repeat every day'),
                  Switch(
                    value: _isDaily,
                    onChanged: (val) {
                      setState(() => _isDaily = val);
                      Navigator.pop(context);
                      _showReminderDialog(context, existing: existing);
                    },
                  )
                ],
              ),
            ],
          ),
          actions: [
            TextButton(
              child: const Text('Cancel'),
              onPressed: () => Navigator.pop(context),
            ),
            ElevatedButton(
              child: Text(existing != null ? 'Update' : 'Set'),
              onPressed: () {
                _scheduleReminder(context, existing: existing);
                Navigator.pop(context);
              },
            )
          ],
        );
      },
    );
  }

  void _scheduleReminder(BuildContext context, {Reminder? existing}) {
    if (_selectedDateTime != null && _nameController.text.trim().isNotEmpty) {
      final id = existing?.id ?? DateTime.now().millisecondsSinceEpoch.remainder(100000);
      final reminder = Reminder(
        id: id,
        name: _nameController.text.trim(),
        time: _selectedDateTime!,
        isDaily: _isDaily,
        isEnabled: true,
      );

      final notifier = Provider.of<NotificationsNotifier>(context, listen: false);
      if (existing != null) {
        notifier.updateReminder(reminder);
      } else {
        notifier.addReminder(reminder);
      }

      _selectedDateTime = null;
      _nameController.clear();
      _isDaily = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    final reminders = context.watch<NotificationsNotifier>().reminders;
    final nextReminder = reminders.where((r) => r.isEnabled).fold<DateTime?>(null, (prev, r) {
      if (prev == null || r.time.isBefore(prev)) return r.time;
      return prev;
    });

    return Scaffold(
      appBar: AppBar(title: const Text('Reminder')),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(
                nextReminder != null
                    ? "Next reminder at ${DateFormat.jm().format(nextReminder)}"
                    : "No active reminders",
                style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
              ),
            ),
          ),
          Expanded(
            child: reminders.isEmpty
                ? const Center(child: Text("No Reminders Yet"))
                : ListView.builder(
                    itemCount: reminders.length,
                    itemBuilder: (context, index) {
                      final reminder = reminders[index];
                      return ListTile(
                        onTap: () => _pickDateTime(context, existing: reminder),
                        leading: Text(
                          DateFormat.jm().format(reminder.time),
                          style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                        ),
                        title: Text(reminder.name),
                        subtitle: Text(reminder.isDaily ? 'Every day' : 'Ring once'),
                        trailing: Switch(
                          value: reminder.isEnabled,
                          onChanged: (val) {
                            Provider.of<NotificationsNotifier>(context, listen: false)
                                .toggleReminder(reminder.id, val);
                          },
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _pickDateTime(context),
        child: const Icon(Icons.add),
      ),
    );
  }
}

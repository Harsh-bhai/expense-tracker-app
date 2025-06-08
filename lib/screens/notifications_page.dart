// ignore_for_file: use_build_context_synchronously
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

  void _resetFormState() {
    _selectedDateTime = null;
    _nameController.clear();
    _isDaily = false;
  }

  void _pickDateTime(BuildContext context, {Reminder? existing}) async {
    DateTime initialDate = existing?.time ?? DateTime.now();
    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: initialDate,
      firstDate: DateTime.now(),
      lastDate: DateTime(2030),
    );

    if (pickedDate == null) return;

    TimeOfDay? pickedTime = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.fromDateTime(initialDate),
    );

    if (pickedTime == null) return;

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

  void _showReminderDialog(BuildContext context, {Reminder? existing}) {
    showDialog(
      context: context,
      builder: (_) => StatefulBuilder(
        builder: (context, setState) {
          return AlertDialog(
            title: Text(existing != null ? 'Edit Reminder' : 'New Reminder'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: _nameController,
                  decoration: const InputDecoration(labelText: 'Reminder Name'),
                ),
                const SizedBox(height: 12),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text('Repeat every day'),
                    Switch(
                      value: _isDaily,
                      onChanged: (val) => setState(() => _isDaily = val),
                    ),
                  ],
                ),
              ],
            ),
            actions: [
              if (existing != null)
                TextButton(
                  onPressed: () {
                    Provider.of<NotificationsNotifier>(context, listen: false)
                        .deleteReminder(existing.id);
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Reminder deleted: ${existing.name}')),
                    );
                    _resetFormState();
                    Navigator.pop(context);
                  },
                  style: TextButton.styleFrom(foregroundColor: Colors.red),
                  child: const Text('Delete'),
                ),
              TextButton(
                onPressed: () {
                  _resetFormState();
                  Navigator.pop(context);
                },
                child: const Text('Cancel'),
              ),
              ElevatedButton(
                onPressed: () {
                  _scheduleReminder(context, existing: existing);
                  Navigator.pop(context);
                },
                child: Text(existing != null ? 'Update' : 'Set'),
              ),
            ],
          );
        },
      ),
    );
  }

  void _scheduleReminder(BuildContext context, {Reminder? existing}) {
    if (_selectedDateTime == null || _nameController.text.trim().isEmpty) return;

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
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Reminder updated: ${reminder.name}')),
      );
    } else {
      notifier.addReminder(reminder);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Reminder set for ${DateFormat.jm().format(reminder.time)}')),
      );
    }

    _resetFormState();
  }

  @override
  Widget build(BuildContext context) {
    final reminders = context.watch<NotificationsNotifier>().reminders;

    final createdReminders = reminders.where((r) => r.name.trim().isNotEmpty).toList();

    final nextReminder = createdReminders
        .where((r) => r.isEnabled)
        .fold<DateTime?>(null, (prev, r) => prev == null || r.time.isBefore(prev) ? r.time : prev);

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
            child: createdReminders.isEmpty
                ? const Center(child: Text("No Reminders Yet"))
                : ListView.builder(
                    itemCount: createdReminders.length,
                    itemBuilder: (context, index) {
                      final reminder = createdReminders[index];
                      return ListTile(
                        onLongPress: () => _pickDateTime(context, existing: reminder),
                        leading: Text(
                          DateFormat.jm().format(reminder.time),
                          style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                        ),
                        title: Text(reminder.name),
                        subtitle: Text(reminder.isDaily ? 'Every day' : 'Ring once'),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              icon: const Icon(Icons.delete),
                              onPressed: () => editReminder(context, reminder),
                            ),
                            Switch(
                              value: reminder.isEnabled,
                              onChanged: (val) {
                                Provider.of<NotificationsNotifier>(context, listen: false)
                                    .toggleReminder(reminder.id, val);
                              },
                            ),
                          ],
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

  Future<dynamic> editReminder(BuildContext context, Reminder reminder) {
    return showDialog(
                          context: context,
                          builder: (_) => AlertDialog(
                            title: const Text("Delete Reminder"),
                            content: Text("Are you sure you want to delete '${reminder.name}'?"),
                            actions: [
                              TextButton(
                                onPressed: () => Navigator.pop(context),
                                child: const Text("Cancel"),
                              ),
                              TextButton(
                                onPressed: () {
                                  Provider.of<NotificationsNotifier>(context, listen: false)
                                      .deleteReminder(reminder.id);
                                  Navigator.pop(context);
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(content: Text("Reminder deleted: ${reminder.name}")),
                                  );
                                },
                                style: TextButton.styleFrom(foregroundColor: Colors.red),
                                child: const Text("Delete"),
                              ),
                            ],
                          ),
                        );
  }
}

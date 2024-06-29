import "package:expense_tracker/provider/money_notifier.dart";
import "package:flutter/material.dart";
class DatePickerButton extends StatelessWidget {
  const DatePickerButton({
    super.key,
    required this.moneyNotifier,
  });

  final MoneyNotifier moneyNotifier;

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      backgroundColor: Colors.green.shade100,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(50),
      ),
      onPressed: () {
        showDialog(
          context: context,
          builder: (context) => StatefulBuilder(
              builder: (BuildContext context, StateSetter setterState) {
            return AlertDialog(
              content: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Card(
                    child: ListTile(
                      title: const Text("Start Date"),
                      leading: const Icon(Icons.date_range),
                      trailing: moneyNotifier.startDate != null
                          ? const Icon(Icons.check_circle,
                              color: Colors.green)
                          : null,
                      onTap: () {
                        moneyNotifier.selectStartDate(context, setterState);
                      },
                    ),
                  ),
                  Card(
                    child: ListTile(
                      title: const Text("End Date"),
                      leading: const Icon(Icons.date_range),
                      trailing: moneyNotifier.endDate != null
                          ? const Icon(Icons.check_circle,
                              color: Colors.green)
                          : null,
                      onTap: () {
                        moneyNotifier.selectEndDate(context, setterState);
                      },
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Row(
                    children: [
                      const Spacer(),
                      ElevatedButton(
                        onPressed: () => Navigator.pop(context),
                        child: const Text("OK"),
                      ),
                    ],
                  )
                ],
              ),
            );
          }),
        );
      },
      child: const Icon(Icons.filter_alt),
    );
  }
}




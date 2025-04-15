import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../provider/budget_notifier.dart';
import '../components/budget_tile.dart'; // adjust import if needed

class BudgetPage extends StatelessWidget {
  const BudgetPage({super.key});

  final List<String> categories = const ['Food', 'Travel', 'Shopping', 'Bills', 'Others'];

  @override
  Widget build(BuildContext context) {
    final budgetNotifier = Provider.of<BudgetNotifier>(context);

    return Scaffold(
      appBar: AppBar(title: const Text("Budget Manager")),
      body: ListView(
        children: [
          ExpansionTile(
            title: const Text("Overall Budget Limit"),
            children: [
              BudgetTile(
                label: "Overall Budget",
                currentLimit: budgetNotifier.overallLimit,
                onSet: (val) => budgetNotifier.setOverallLimit(val),
              ),
            ],
          ),
          ExpansionTile(
            title: const Text("Category-wise Budget Limit"),
            children: categories.map((category) {
              return ExpansionTile(
                title: Text(category),
                children: [
                  BudgetTile(
                    label: "$category Budget",
                    currentLimit: budgetNotifier.categoryLimits[category] ?? 0,
                    onSet: (val) => budgetNotifier.setCategoryLimit(category, val),
                  ),
                ],
              );
            }).toList(),
          ),
        ],
      ),
    );
  }
}

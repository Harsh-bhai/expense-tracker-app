import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../provider/analysis_notifier.dart';
import '../provider/budget_notifier.dart';

class OverallBudgetTile extends StatefulWidget {
  const OverallBudgetTile({super.key});

  @override
  State<OverallBudgetTile> createState() => _OverallBudgetTileState();
}

class _OverallBudgetTileState extends State<OverallBudgetTile> {
  late double _sliderValue;
  late TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    final budget = context.read<BudgetNotifier>().overallLimit;
    _sliderValue = budget;
    _controller = TextEditingController(text: budget.toStringAsFixed(0));
  }

  void _updateValue(double val) {
    setState(() {
      _sliderValue = val;
      _controller.text = val.toStringAsFixed(0);
    });
  }

  @override
  Widget build(BuildContext context) {
    final analysisNotifier = Provider.of<AnalysisNotifier>(context);
    final budgetNotifier = Provider.of<BudgetNotifier>(context);

    return Card(
      elevation: 1,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ExpansionTile(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        title: const Text("Overall Budget Limit", style: TextStyle(fontWeight: FontWeight.bold)),
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("Spent: ₹${analysisNotifier.totalMoney.toStringAsFixed(2)}",
                    style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
                const SizedBox(height: 10),
                TextField(
                  controller: _controller,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    labelText: "Set Budget",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(12)),
                    ),
                    isDense: true,
                    contentPadding: EdgeInsets.symmetric(horizontal: 15, vertical: 15),
                  ),
                  onChanged: (val) {
                    final parsed = double.tryParse(val);
                    if (parsed != null) {
                      _sliderValue = parsed;
                      setState(() {});
                    }
                  },
                ),
                const SizedBox(height: 10),
                Slider(
                  value: _sliderValue.clamp(0, 100000),
                  min: 0,
                  max: 100000,
                  divisions: 100,
                  label: "₹${_sliderValue.toInt()}",
                  onChanged: (val) => _updateValue(val),
                ),
                const SizedBox(height: 10),
                Align(
                  alignment: Alignment.centerRight,
                  child: ElevatedButton.icon(
                    icon: const Icon(Icons.save),
                    label: const Text("Save"),
                    onPressed: () {
                      final value = double.tryParse(_controller.text);
                      if (value != null) {
                        budgetNotifier.setOverallLimit(value);
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text("Budget saved")),
                        );
                      }
                    },
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

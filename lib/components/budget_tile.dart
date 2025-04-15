import 'package:flutter/material.dart';

class BudgetTile extends StatefulWidget {
  final String label;
  final double currentLimit;
  final Function(double) onSet;

  const BudgetTile({
    super.key,
    required this.label,
    required this.currentLimit,
    required this.onSet,
  });

  @override
  State<BudgetTile> createState() => _BudgetTileState();
}

class _BudgetTileState extends State<BudgetTile> {
  double _sliderValue = 0;
  final TextEditingController _controller = TextEditingController();

  @override
  void initState() {
    super.initState();
    _sliderValue = widget.currentLimit;
    _controller.text = widget.currentLimit.toString();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TextField(
          keyboardType: TextInputType.number,
          controller: _controller,
          decoration: const InputDecoration(labelText: 'Budget Limit'),
          onChanged: (val) {
            final parsed = double.tryParse(val);
            if (parsed != null) {
              setState(() {
                _sliderValue = parsed;
              });
            }
          },
        ),
        Slider(
          value: _sliderValue,
          min: 0,
          max: 100000,
          divisions: 1000,
          label: _sliderValue.toStringAsFixed(0),
          onChanged: (val) {
            setState(() {
              _sliderValue = val;
              _controller.text = val.toStringAsFixed(0);
            });
          },
        ),
        ElevatedButton(
          onPressed: () {
            widget.onSet(_sliderValue);
          },
          child: const Text("Set"),
        ),
      ],
    );
  }
}

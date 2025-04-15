import 'package:flutter/material.dart';

class CategoryBudgetExpansionTile extends StatefulWidget {
  final String title;
  final IconData? icon;
  final Color color;
  final double currentLimit;
  final double spent;
  final Function(double) onSet;

  const CategoryBudgetExpansionTile({
    super.key,
    required this.title,
    required this.icon,
    required this.color,
    required this.currentLimit,
    required this.spent,
    required this.onSet,
  });

  @override
  State<CategoryBudgetExpansionTile> createState() =>
      CategoryBudgetExpansionTileState();
}

class CategoryBudgetExpansionTileState
    extends State<CategoryBudgetExpansionTile> {
  late double _sliderValue;
  final TextEditingController _controller = TextEditingController();

  @override
  void initState() {
    super.initState();
    _sliderValue = widget.currentLimit;
    _controller.text = widget.currentLimit.toStringAsFixed(0);
  }

  void _updateValue(double val) {
    setState(() {
      _sliderValue = val;
      _controller.text = val.toStringAsFixed(0);
    });
  }

  @override
  Widget build(BuildContext context) {
    return ExpansionTile(
      leading: CircleAvatar(
        backgroundColor: widget.color,
        child: Icon(widget.icon, color: Colors.white),
      ),
      title: Text(widget.title,
          style: const TextStyle(fontWeight: FontWeight.w600)),
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("Spent: ₹${widget.spent.toStringAsFixed(2)}",
                  style: const TextStyle(
                      fontSize: 16, fontWeight: FontWeight.w500)),
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
                      widget.onSet(value);
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text("Budget saved")),
                      );
                    }
                  },
                ),
              ),
            ],
          ),
        )
      ],
    );
  }
}

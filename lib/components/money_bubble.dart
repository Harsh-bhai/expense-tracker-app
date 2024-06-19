import 'package:flutter/material.dart';

class MoneyBubble extends StatefulWidget {
  final Color color;
  final IconData icon;
  final double money;
  final String title;

  const MoneyBubble({super.key, required this.color, required this.icon, required this.money, required this.title});

  @override
  State<MoneyBubble> createState() => _MoneyBubbleState();
}

class _MoneyBubbleState extends State<MoneyBubble> {
  double spending =10;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: widget.color,
        borderRadius: BorderRadius.circular(40),
      ),
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 25),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            padding: const EdgeInsets.all(5),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.3),
              shape: BoxShape.circle,
            ),
            child: Icon(widget.icon, color: Colors.white),
          ),
          const SizedBox(width: 10),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                widget.title,
                style: const TextStyle(color: Colors.white, fontSize: 14),
              ),
              Text(
                '₹${spending.toStringAsFixed(2)}',
                style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
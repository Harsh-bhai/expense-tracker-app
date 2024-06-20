import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../provider/money_notifier.dart';

class MoneyBubble extends StatefulWidget {
  final Color color;
  final IconData icon;
  final int money;
  final String title;

  const MoneyBubble(
      {super.key,
      required this.color,
      required this.icon,
      required this.money,
      required this.title});

  @override
  State<MoneyBubble> createState() => _MoneyBubbleState();
}

class _MoneyBubbleState extends State<MoneyBubble> {
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
      padding: const EdgeInsets.only(top: 12,bottom: 12, right: 30, left: 15),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Provider.of<MoneyNotifier>(context).isMessagesLoading
              ? const CircularProgressIndicator(
                  color: Colors.white,
                  strokeWidth: 3,
                )
              : Container(
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
                style: const TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                    fontWeight: FontWeight.w500),
              ),
              Text(
                '₹${widget.money}',
                style: const TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.bold),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

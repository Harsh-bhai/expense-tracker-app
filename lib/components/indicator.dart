// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';

class Indicator extends StatelessWidget {
  Indicator({
    super.key,
    required this.color,
    required this.icon,
    required this.text,
    this.showBorder = false,
    this.size = 16,
    this.textColor,
  });
  final Color color;
  bool showBorder;
  final IconData icon;
  final String text;
  final double size;
  final Color? textColor;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Container(
          decoration: BoxDecoration(
            border: Border.all(color: showBorder? Colors.black : color, width: 3),
            shape: BoxShape.circle,
          ),
          child: CircleAvatar(
            radius: 24.0,
            backgroundColor: color,
            child: Icon(
              icon,
              color: Colors.white,
              size: 24.0,
            ),
          ),
        ),
        Text(
          text,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w500,
            color: textColor,
          ),
        )
      ],
    );
  }
}

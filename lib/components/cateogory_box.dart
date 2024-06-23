import 'package:expense_tracker/models/hive_listtile_model.dart';
import 'package:flutter/material.dart';

class CategoryBox extends StatelessWidget {
  final HiveListTileModel category;

  const CategoryBox({super.key, required this.category});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: Colors.grey[200],
        borderRadius: BorderRadius.circular(12.0),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircleAvatar(
            radius: 24.0,
            backgroundColor: category.bgColor ?? Colors.blue,
            child: Icon(
              category.iconData,
              color: Colors.white,
              size: 24.0,
            ),
          ),
          const SizedBox(height: 12.0),
          Text(
            category.title ?? '',
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.bold,
              fontSize: 16.0,
            ),
          ),
          const SizedBox(height: 8.0),
          Text(
            category.subtitle ?? '',
            overflow: TextOverflow.ellipsis,
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: Colors.black,
              fontSize: 12.0,
            ),
          ),
        ],
      ),
    );
  }

}
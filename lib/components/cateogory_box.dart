import 'package:expense_tracker/models/listtile_model.dart';
import 'package:expense_tracker/utils/utils.dart';
import 'package:flutter/material.dart';

class CategoryBox extends StatelessWidget {
  final ListTileModel category;

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
            backgroundColor: category.expenseEnum != null
                ? getColorFromExpense(category.expenseEnum!)
                : Colors.grey,
            child: Icon(
              category.icon,
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

  Color getColorFromExpense(Expense expense) {
    switch (expense) {
      case Expense.food:
        return Colors.red;
      case Expense.shopping:
        return Colors.blue;
      case Expense.travelling:
        return Colors.green;
      case Expense.entertainment:
        return Colors.orange;
      case Expense.medical:
        return Colors.purple;
      case Expense.personalCare:
        return Colors.pink;
      case Expense.education:
        return Colors.cyan;
      case Expense.householdBills:
        return Colors.brown;
      case Expense.investment:
        return Colors.teal;
      case Expense.rent:
        return Colors.indigo;
      case Expense.tax:
        return Colors.grey;
      case Expense.insurance:
        return Colors.yellow;
      case Expense.gifts:
        return Colors.lightGreen;
      default:
        return Colors.white;
    }
  }
}

import 'package:expense_tracker/components/cateogory_box.dart';
import 'package:expense_tracker/models/listtile_model.dart';
import 'package:expense_tracker/utils/utils.dart';
import 'package:flutter/material.dart';

class CategoryPage extends StatelessWidget {
  final List<ListTileModel> settingsOptions = [
    const ListTileModel(
      title: 'Food',
      subtitle: 'Groceries, restaurants, etc.',
      icon: Icons.fastfood,
      expenseEnum: Expense.food,
    ),
    const ListTileModel(
      title: 'Shopping',
      subtitle: 'Groceries, restaurants, etc.',
      icon: Icons.shopping_bag,
      expenseEnum: Expense.shopping,
    ),
    const ListTileModel(
      title: 'Traveling',
      subtitle: 'Flight tickets, hotel bookings, etc.',
      icon: Icons.flight,
      expenseEnum: Expense.travelling,
    ),
    const ListTileModel(
      title: 'Entertainment',
      subtitle: 'Movies, concerts, sports events, etc.',
      icon: Icons.movie,
      expenseEnum: Expense.entertainment,
    ),
    const ListTileModel(
      title: 'Medical',
      subtitle: 'Doctor visits, prescription medications, etc.',
      icon: Icons.medical_information,
      expenseEnum: Expense.medical,
    ),
    const ListTileModel(
      title: 'Personal Care',
      subtitle: 'Cosmetics, hair care, beauty products, etc.',
      icon: Icons.clean_hands,
      expenseEnum: Expense.personalCare,
    ),
    const ListTileModel(
      title: 'Education',
      subtitle: 'School fees, books, study materials, etc.',
      icon: Icons.book,
      expenseEnum: Expense.education,
    ),
    const ListTileModel(
      title: 'Household Bills',
      subtitle: 'Gas, electricity, water, internet bills, etc.',
      icon: Icons.receipt_long,
      expenseEnum: Expense.householdBills,
    ),
    const ListTileModel(
      title: 'Investments',
      subtitle: 'Stocks, bonds, mutual funds, etc.',
      icon: Icons.trending_up,
      expenseEnum: Expense.investment,
    ),
    const ListTileModel(
      title: 'Rent',
      subtitle: 'House rent, shop rent, etc.',
      icon: Icons.home,
      expenseEnum: Expense.rent,
    ),
    const ListTileModel(
      title: 'Taxes',
      subtitle: 'Income tax, house tax, etc.',
      icon: Icons.request_quote,
      expenseEnum: Expense.tax,
    ),
    const ListTileModel(
      title: 'Insurance',
      subtitle: 'Car insurance, health insurance, etc.',
      icon: Icons.attach_money,
      expenseEnum: Expense.insurance,
    ),
    const ListTileModel(
      title: 'Gifts',
      subtitle: 'Gifts, donations, etc.',
      icon: Icons.card_giftcard,
      expenseEnum: Expense.gifts,
    ),
  ];

  CategoryPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Custom Grid'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: GridView.builder(
          itemCount: settingsOptions.length,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            mainAxisSpacing: 16.0,
            crossAxisSpacing: 16.0,
            childAspectRatio: 1,
          ),
          itemBuilder: (context, index) {
            return CategoryBox(category: settingsOptions[index]);
          },
        ),
      ),
    );
  }
}

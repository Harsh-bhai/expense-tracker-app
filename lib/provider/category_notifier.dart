import 'package:flutter/material.dart';
import '../models/listtile_model.dart';

class CateogryNotifier extends ChangeNotifier {
  final List<ListTileModel> _categories = [
    const ListTileModel(
      title: 'Food',
      subtitle: 'Groceries, restaurants, etc.',
      icon: Icons.fastfood,
      categoryName: "food",
      bgColor: Colors.red
    ),
    const ListTileModel(
      title: 'Shopping',
      subtitle: 'Groceries, restaurants, etc.',
      icon: Icons.shopping_bag,
      categoryName: "shopping",
      bgColor: Colors.blue
    ),
    const ListTileModel(
      title: 'Traveling',
      subtitle: 'Flight tickets, hotel bookings, etc.',
      icon: Icons.flight,
      categoryName: "travelling",
      bgColor: Colors.orange
    ),
    const ListTileModel(
      title: 'Entertainment',
      subtitle: 'Movies, concerts, sports events, etc.',
      icon: Icons.movie,
      categoryName: "entertainment",
      bgColor: Colors.purple
    ),
    const ListTileModel(
      title: 'Medical',
      subtitle: 'Doctor visits, prescription medications, etc.',
      icon: Icons.medical_information,
      categoryName: "medical",
      bgColor: Colors.brown
    ),
    const ListTileModel(
      title: 'Personal Care',
      subtitle: 'Cosmetics, hair care, beauty products, etc.',
      icon: Icons.clean_hands,
      categoryName: "personalCare",
      bgColor: Colors.teal
    ),
    const ListTileModel(
      title: 'Education',
      subtitle: 'School fees, books, study materials, etc.',
      icon: Icons.book,
      categoryName: "education",
      bgColor: Colors.grey
    ),
    const ListTileModel(
      title: 'Household Bills',
      subtitle: 'Gas, electricity, water, internet bills, etc.',
      icon: Icons.receipt_long,
      categoryName: "householdBills",
      bgColor: Colors.yellow
    ),
    const ListTileModel(
      title: 'Investments',
      subtitle: 'Stocks, bonds, mutual funds, etc.',
      icon: Icons.trending_up,
      categoryName: "investment",
      bgColor: Colors.lightGreen
    ),
    const ListTileModel(
      title: 'Rent',
      subtitle: 'House rent, shop rent, etc.',
      icon: Icons.home,
      categoryName: "rent",
      bgColor: Colors.red
    ),
    const ListTileModel(
      title: 'Taxes',
      subtitle: 'Income tax, house tax, etc.',
      icon: Icons.request_quote,
      categoryName: "tax",
      bgColor: Colors.green
    ),
    const ListTileModel(
      title: 'Insurance',
      subtitle: 'Car insurance, health insurance, etc.',
      icon: Icons.attach_money,
      categoryName: "insurance",
      bgColor: Colors.pink
    ),
    const ListTileModel(
      title: 'Gifts',
      subtitle: 'Gifts, donations, etc.',
      icon: Icons.card_giftcard,
      categoryName: "gifts",
      bgColor: Colors.green
    ),
  ];

  List<ListTileModel> get categories => _categories;
}
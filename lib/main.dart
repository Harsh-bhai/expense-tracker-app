import 'package:expense_tracker/models/hive_expense_categories.dart';
import 'package:expense_tracker/provider/category_notifier.dart';
import 'package:expense_tracker/provider/money_notifier.dart';
import 'package:expense_tracker/screens/transactions.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  Hive.registerAdapter(HiveExpenseCateogryAdapter());


  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => MoneyNotifier()),
        ChangeNotifierProvider(create: (_) => CateogryNotifier()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const Transactions(),
    );
  }
}

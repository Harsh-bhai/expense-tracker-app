import 'package:expense_tracker/models/hive_listtile_model.dart';
import 'package:expense_tracker/provider/category_notifier.dart';
import 'package:expense_tracker/provider/money_notifier.dart';
import 'package:expense_tracker/screens/home_page.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  Hive.registerAdapter(HiveListTileModelAdapter()); // Register the generated adapter
  
  // Open the necessary boxes before running the app
  await Hive.openBox<List>('categoryBox');
  await Hive.openBox('settings');
  
  // Ensure checkFirstLaunch runs only after Hive initialization
  await checkFirstLaunch();

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => MoneyNotifier()),
        ChangeNotifierProvider(create: (_) => CategoryNotifier()),
      ],
      child: const MyApp(),
    ),
  );
}

Future<void> checkFirstLaunch() async {
  var categoryBox = Hive.box<List>('categoryBox');
  var settingsBox = Hive.box('settings');
  bool isFirstLaunch = settingsBox.get('isFirstLaunch', defaultValue: true);
  print("firstLaunch: $isFirstLaunch");

  if (isFirstLaunch) {
    // Add default category
    categoryBox.put('ExpenseCategoryArray', [
      HiveListTileModel(
        title: 'Food',
        subtitle: 'Groceries, restaurants, etc.',
        icon: Icons.fastfood, // Use codePoint for IconData storage
        bgColor: Colors.red,      // Use value for Color storage
      )
    ]);
    categoryBox.put('IncomeCategoryArray', [
      HiveListTileModel(
        title: 'Salary',
        subtitle: 'Groceries, restaurants, etc.',
        icon: Icons.currency_rupee_sharp, // Use codePoint for IconData storage
        bgColor: Colors.green,                // Use value for Color storage
      ),
    ]);

    // Set first launch to false
    settingsBox.put('isFirstLaunch', false);
  }
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    Provider.of<MoneyNotifier>(context, listen: false).getSmsMessages();
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const HomePage(),
    );
  }
}

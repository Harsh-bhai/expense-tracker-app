import 'package:expense_tracker/models/hive_listtile_model.dart';
import 'package:expense_tracker/provider/category_notifier.dart';
import 'package:expense_tracker/provider/common_notifier.dart';
import 'package:expense_tracker/provider/money_notifier.dart';
import 'package:expense_tracker/provider/notifications_notifier.dart';
import 'package:expense_tracker/screens/landing_page.dart';
import 'package:expense_tracker/screens/spash_screen.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:provider/provider.dart';
import 'package:awesome_notifications/awesome_notifications.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await hiveInit();
  
  // Ensure checkFirstLaunch runs only after Hive initialization
  await checkFirstLaunch();

  await notificationsInit();

  

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => MoneyNotifier()),
        ChangeNotifierProvider(create: (_) => CategoryNotifier()),
        ChangeNotifierProvider(create: (_) => CommonNotifier()),
        ChangeNotifierProvider(create: (_) => NotificationsNotifier()),
      ],
      child: const MyApp(),
    ),
  );
}

Future<void> notificationsInit() async {
  await AwesomeNotifications().initialize(
  null,
  [
    NotificationChannel(
      channelKey: 'reminder_channel',
      channelName: 'Reminders',
      channelDescription: 'Reminder notifications to add category to transactions',
      defaultColor: Colors.blue,
      importance: NotificationImportance.High,
      ledColor: Colors.white,
    ),
  ],
  debug: true,
    );
}

Future<void> hiveInit() async {
  await Hive.initFlutter();
  Hive.registerAdapter(HiveListTileModelAdapter()); // Register the generated adapter
  
  // Open the necessary boxes before running the app
  await Hive.openBox<List>('categoryBox');
  await Hive.openBox('settings');
  await Hive.openBox('maps');
}


Future<void> checkFirstLaunch() async {
  var categoryBox = Hive.box<List>('categoryBox');
  var settingsBox = Hive.box('settings');
  bool isFirstLaunch = settingsBox.get('isFirstLaunch', defaultValue: true);

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
    MoneyNotifier moneyNotifier = Provider.of<MoneyNotifier>(context, listen: false);
    CommonNotifier commonNotifier = Provider.of<CommonNotifier>(context, listen: false);
    moneyNotifier.getSmsMessages();
    Provider.of<CategoryNotifier>(context, listen: false).getCategories();
    return MaterialApp(
      title: 'Expense Tracker',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.white),
        useMaterial3: true,
      ),
      home: refreshWrapper(moneyNotifier, commonNotifier,
              const LandingPage()),
      // home: const SplashScreen(),
    );
  }



 
}

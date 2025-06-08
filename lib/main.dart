import 'package:expense_tracker/models/hive_listtile_model.dart';
import 'package:expense_tracker/provider/analysis_notifier.dart';
import 'package:expense_tracker/provider/bank_notifier.dart';
import 'package:expense_tracker/provider/budget_notifier.dart';
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

  // notifications init
  await notificationsInit();
  await createBudgetNotificationChannel();

  

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => MoneyNotifier()),
        ChangeNotifierProvider(create: (_) => CategoryNotifier()),
        ChangeNotifierProvider(create: (_) => CommonNotifier()),
        ChangeNotifierProvider(create: (_) => NotificationsNotifier()),
        ChangeNotifierProvider(create: (_) => BudgetNotifier()),
        ChangeNotifierProvider(create: (_) => AnalysisNotifier()),
        ChangeNotifierProvider(create: (_) => BankNotifier()),
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
    bool isAllowed = await AwesomeNotifications().isNotificationAllowed();
  if (!isAllowed) {
    // Ask user for permission
    await AwesomeNotifications().requestPermissionToSendNotifications();
  }
    
}

Future<void> createBudgetNotificationChannel() async {
await AwesomeNotifications().initialize(
    null,
    [
      NotificationChannel(
        channelKey: 'budget_channel',
        channelName: 'Budget Alerts',
        channelDescription: 'Notifications when budget is exceeded',
        defaultColor: Colors.red,
        ledColor: Colors.white,
        importance: NotificationImportance.High,
        channelShowBadge: true,
        playSound: true,
      )
    ],
    debug: true,
  );

  bool isAllowed = await AwesomeNotifications().isNotificationAllowed();
  if (!isAllowed) {
    // Ask user for permission
    await AwesomeNotifications().requestPermissionToSendNotifications();
  }}


Future<void> hiveInit() async {
  await Hive.initFlutter();
  Hive.registerAdapter(HiveListTileModelAdapter()); // Register the generated adapter
  
  // Open the necessary boxes before running the app
  await Hive.openBox<List>('categoryBox');
  await Hive.openBox('settings');
  await Hive.openBox('maps');
  await Hive.openBox('budget'); // for budget limit
  await Hive.openBox('notification'); // to send notification 1 time
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
    AnalysisNotifier analysisNotifier = Provider.of<AnalysisNotifier>(context, listen: false);
    BankNotifier bankNotifier = Provider.of<BankNotifier>(context, listen:false);
    // initConfig(moneyNotifier ,context);
    return MaterialApp(
      title: 'Expense Tracker',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.white),
        useMaterial3: true,
      ),
      home: refreshWrapper(moneyNotifier, analysisNotifier, bankNotifier,
              const LandingPage()),
      // home: const SplashScreen(),
    );
  }


 
}


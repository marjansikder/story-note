import 'package:date_calculator/screen/age_calculator/age_calculator_screen.dart';
import 'package:date_calculator/screen/calender/calendar_screen.dart';
import 'package:date_calculator/screen/dashboard/dashboard_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/adapters.dart';

final navigatorKey = GlobalKey<NavigatorState>();

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  await Hive.openBox('open_note');
  runApp(const ProviderScope(child: MyApp()));
}

final routes = {
  DashboardScreen.route: (context) => const DashboardScreen(),
  CalenderScreen.route: (context) => const CalenderScreen(),
  AgeCalculatorScreen.route: (context) => const AgeCalculatorScreen(),
};

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      navigatorKey: navigatorKey,
      debugShowCheckedModeBanner: false,
      themeMode: ThemeMode.light,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      initialRoute: DashboardScreen.route,
      routes: routes,
    );
  }
}

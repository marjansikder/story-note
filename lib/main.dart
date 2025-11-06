import 'package:date_calculator/screen/dashboard/dashboard_screen.dart';
import 'package:date_calculator/screen/age_calculator/age_calculator_screen.dart';
import 'package:date_calculator/screen/calender/calendar_screen.dart';
import 'package:date_calculator/firebase_options.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:toastification/toastification.dart';
import 'package:date_calculator/widgets/auth_gate.dart';

final navigatorKey = GlobalKey<NavigatorState>();

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
  ]).then((_) {
    runApp(
      const ProviderScope(
        child: MyApp(),
      ),
    );
  });
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
    return ToastificationWrapper(
      child: MaterialApp(
        title: 'Flutter Demo',
        builder: FToastBuilder(),
        navigatorKey: navigatorKey,
        debugShowCheckedModeBanner: false,
        themeMode: ThemeMode.light,
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          useMaterial3: true,
        ),
        routes: routes,
        home: const AuthGate(
          child: DashboardScreen(),
        ),
      ),
    );
  }
}

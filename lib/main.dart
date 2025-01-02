import 'package:flutter/material.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';
import 'resetflag.dart'; // Import ResetFlagObserver
import 'login.dart'; // Import LoginPage

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize OneSignal
  OneSignal.initialize("c409080d-f66a-43e9-bc4e-35433c58e939");

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Airline Business App',
      navigatorObservers: [ResetFlagObserver()], // Add ResetFlagObserver
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: const Color.fromARGB(255, 10, 40, 105)),
        appBarTheme: const AppBarTheme(
          foregroundColor: Colors.white,
        ),
        useMaterial3: true,
      ),
      home: const LoginPage(), // Directly set LoginPage as the home screen
    );
  }
}

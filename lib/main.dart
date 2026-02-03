import 'package:flutter/material.dart';
import 'package:nfw/screens/onboarding_screen.dart';
import 'package:nfw/services/storage_service.dart';
import 'package:nfw/services/workout_service.dart';
import 'package:provider/provider.dart';

// Using a GlobalKey for the navigator to allow navigation from services
// if needed in the future, although not strictly required by the current design.
final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

void main() async {
  // Ensure that plugin services are initialized so that `shared_preferences`
  // can be used before `runApp`.
  WidgetsFlutterBinding.ensureInitialized();

  // Here we would initialize our services.
  final storageService = StorageService();
  // In a real app, you might await for some services to be ready.
  // For now, we'll determine the start screen synchronously for simplicity,
  // but a FutureBuilder is used in the UI to handle async checks properly.

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => WorkoutService()),
        Provider(create: (_) => storageService),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'NFW - Water Tracker',
      navigatorKey: navigatorKey,
      theme: ThemeData(
        brightness: Brightness.dark,
        primaryColor: Colors.teal,
        scaffoldBackgroundColor: const Color(0xFF121212),
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.teal,
          brightness: Brightness.dark,
        ),
        fontFamily: 'Roboto', // A placeholder font
        useMaterial3: true,
      ),
      // For this initial setup, we'll always start with the OnboardingScreen.
      // In Phase 2, this will be replaced with logic to check if onboarding is complete.
      home: const OnboardingScreen(),
    );
  }
}

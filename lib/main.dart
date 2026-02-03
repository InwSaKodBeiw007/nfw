import 'package:flutter/material.dart';
import 'package:nfw/screens/home_screen.dart';
import 'package:nfw/screens/onboarding_screen.dart';
import 'package:nfw/services/notification_service.dart'; // Import NotificationService
import 'package:nfw/services/storage_service.dart';
import 'package:nfw/services/workout_service.dart';
import 'package:provider/provider.dart';

// Using a GlobalKey for the navigator to allow navigation from services
// if needed in the future, although not strictly required by the current design.
final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

void main() async {
  // Ensure that plugin services are initialized so that `shared_preferences`
  // and notification plugins can be used before `runApp`.
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize services
  final storageService = StorageService();
  final notificationService = NotificationService(); // Create an instance
  await notificationService.init(); // Initialize the notification service

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => WorkoutService()),
        Provider(create: (_) => storageService),
        Provider(
          create: (_) => notificationService,
        ), // Provide NotificationService
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
      home: FutureBuilder<bool>(
        future: _hasCompletedOnboarding(context),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Scaffold(
              body: Center(child: CircularProgressIndicator()),
            );
          }
          if (snapshot.hasData && snapshot.data == true) {
            return const HomeScreen();
          }
          return const OnboardingScreen();
        },
      ),
    );
  }

  Future<bool> _hasCompletedOnboarding(BuildContext context) async {
    final storageService = Provider.of<StorageService>(context, listen: false);
    final intensity = await storageService.getWorkoutIntensity();
    return intensity != null;
  }
}

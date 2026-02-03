import 'package:flutter/material.dart';
import 'package:nfw/screens/home_screen.dart';
import 'package:nfw/screens/onboarding_screen.dart';
import 'package:nfw/services/notification_service.dart';
import 'package:nfw/services/storage_service.dart';
import 'package:nfw/services/workout_service.dart';
import 'package:provider/provider.dart';

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final storageService = StorageService();
  final notificationService = NotificationService();
  await notificationService.init();

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) {
            final storage = Provider.of<StorageService>(context, listen: false);
            final notification = Provider.of<NotificationService>(
              context,
              listen: false,
            );
            final workoutService = WorkoutService(storage, notification);
            workoutService.initialize(); // Call initialize here
            return workoutService;
          },
        ),
        Provider(create: (_) => storageService),
        Provider(create: (_) => notificationService),
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
        fontFamily: 'Roboto',
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

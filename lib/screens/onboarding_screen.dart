import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/workout_intensity.dart';
import '../services/storage_service.dart';
import '../services/notification_service.dart';
import 'home_screen.dart'; // Ensure this import points to your home_screen.dart

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  Future<void> _selectIntensity(WorkoutIntensity intensity) async {
    // Check if mounted before using context for Provider.of
    if (!mounted) return;
    final storageService = Provider.of<StorageService>(context, listen: false);

    // Check if mounted before using context for Provider.of
    if (!mounted) return;
    final notificationService = Provider.of<NotificationService>(
      context,
      listen: false,
    );

    // 1. Request Notification Permissions
    final bool granted = await notificationService.requestPermissions();
    if (!granted) {
      // In a real app, show a dialog or snackbar. For now, we'll just log.
      debugPrint(
        'Notification permissions denied. App functionality will be limited.',
      );
    }

    // 2. Save selected intensity
    await storageService.saveWorkoutIntensity(intensity);

    // Check if the widget is still mounted before using its context for navigation
    if (!mounted) return;

    // 3. Navigate to Home Screen
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (context) => const HomeScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Workout Intensity'), centerTitle: true),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'How intense are your workouts normally?',
                style: Theme.of(context).textTheme.headlineSmall,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 40),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () => _selectIntensity(WorkoutIntensity.normal),
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 15),
                    textStyle: const TextStyle(fontSize: 18),
                  ),
                  child: const Text('Normal (ปกติ)'),
                ),
              ),
              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () => _selectIntensity(WorkoutIntensity.heavy),
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 15),
                    textStyle: const TextStyle(fontSize: 18),
                  ),
                  child: const Text('Heavy (หนัก)'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:nfw/services/workout_service.dart';
import 'package:nfw/models/workout_intensity.dart'; // Import for WorkoutIntensity

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  String _formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    final String minutes = twoDigits(duration.inMinutes.remainder(60));
    final String seconds = twoDigits(duration.inSeconds.remainder(60));
    return '$minutes:$seconds';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Hydration Tracker'), centerTitle: true),
      body: Consumer<WorkoutService>(
        builder: (context, workoutService, child) {
          final isWorkoutActive = workoutService.isWorkoutActive;
          final remainingTime = workoutService.remainingTime;
          final workoutIntensity = workoutService.workoutIntensity;

          // Determine water bottle count
          int bottleCount = 0;
          if (isWorkoutActive) {
            if (workoutIntensity == WorkoutIntensity.normal) {
              bottleCount = 1;
            } else if (workoutIntensity == WorkoutIntensity.heavy) {
              bottleCount = 2;
            }
          }

          return Center(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    isWorkoutActive ? 'Next reminder in:' : 'Ready to workout?',
                    style: Theme.of(
                      context,
                    ).textTheme.headlineSmall?.copyWith(color: Colors.white70),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 20),
                  Text(
                    isWorkoutActive ? _formatDuration(remainingTime) : '00:00',
                    style: Theme.of(context).textTheme.displayLarge?.copyWith(
                      fontSize: 80,
                      fontWeight: FontWeight.bold,
                      color: Colors.tealAccent,
                    ),
                  ),
                  const SizedBox(height: 40),
                  if (isWorkoutActive && bottleCount > 0)
                    Column(
                      children: [
                        Text(
                          'Recommended intake:',
                          style: Theme.of(context).textTheme.titleMedium
                              ?.copyWith(color: Colors.white70),
                        ),
                        const SizedBox(height: 10),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: List.generate(
                            bottleCount,
                            (index) => Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 5.0,
                              ),
                              child: Image.asset(
                                'lib/assets/bottle4oz.jpeg',
                                width: 50,
                                height: 50,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  const SizedBox(height: 40),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        if (isWorkoutActive) {
                          workoutService.stopWorkout();
                        } else {
                          workoutService.startWorkout();
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 20),
                        backgroundColor: isWorkoutActive
                            ? Colors.redAccent
                            : Colors.teal,
                        textStyle: const TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      child: Text(
                        isWorkoutActive ? 'End Workout' : 'Start Workout',
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

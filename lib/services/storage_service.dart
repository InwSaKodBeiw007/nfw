import 'package:shared_preferences/shared_preferences.dart';
import '../models/workout_intensity.dart';

class StorageService {
  static const _workoutIntensityKey = 'workout_intensity';

  Future<void> saveWorkoutIntensity(WorkoutIntensity intensity) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_workoutIntensityKey, intensity.name);
  }

  Future<WorkoutIntensity?> getWorkoutIntensity() async {
    final prefs = await SharedPreferences.getInstance();
    final String? intensityName = prefs.getString(_workoutIntensityKey);
    if (intensityName == null) {
      return null;
    }
    return WorkoutIntensity.values.firstWhere(
      (e) => e.name == intensityName,
      orElse: () => WorkoutIntensity.normal, // Default if not found
    );
  }
}

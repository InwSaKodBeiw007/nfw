import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:nfw/models/workout_intensity.dart';
import 'package:nfw/services/storage_service.dart';

void main() {
  group('StorageService', () {
    late StorageService storageService;

    setUp(() {
      // Mock SharedPreferences for testing
      SharedPreferences.setMockInitialValues({});
      storageService = StorageService();
    });

    test('saveWorkoutIntensity saves the correct intensity', () async {
      await storageService.saveWorkoutIntensity(WorkoutIntensity.normal);
      final prefs = await SharedPreferences.getInstance();
      expect(prefs.getString('workout_intensity'), 'normal');
    });

    test('getWorkoutIntensity retrieves the correct intensity', () async {
      await storageService.saveWorkoutIntensity(WorkoutIntensity.heavy);
      final intensity = await storageService.getWorkoutIntensity();
      expect(intensity, WorkoutIntensity.heavy);
    });

    test('getWorkoutIntensity returns null if no intensity is saved', () async {
      final intensity = await storageService.getWorkoutIntensity();
      expect(intensity, null);
    });
  });
}

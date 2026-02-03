import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:nfw/models/workout_intensity.dart';
import 'package:nfw/services/notification_service.dart';
import 'package:nfw/services/storage_service.dart';

class WorkoutService with ChangeNotifier {
  final StorageService _storageService;
  final NotificationService _notificationService;

  WorkoutService(this._storageService, this._notificationService);

  WorkoutIntensity? _workoutIntensity;
  bool _isWorkoutActive = false;
  Duration _remainingTime = Duration.zero;
  Timer? _timer;
  int _notificationId = 0; // Unique ID for each notification

  WorkoutIntensity? get workoutIntensity => _workoutIntensity;
  bool get isWorkoutActive => _isWorkoutActive;
  Duration get remainingTime => _remainingTime;

  Future<void> initialize() async {
    _workoutIntensity = await _storageService.getWorkoutIntensity();
    notifyListeners();
  }

  void startWorkout() {
    if (_isWorkoutActive) return;

    if (_workoutIntensity == null) {
      // Should not happen if onboarding is done, but as a safeguard
      debugPrint('Workout intensity not set. Cannot start workout.');
      return;
    }

    _isWorkoutActive = true;
    _notificationId = 0; // Reset notification ID for a new workout
    _startNewCountdownInterval();
    notifyListeners();
  }

  void stopWorkout() {
    if (!_isWorkoutActive) return;

    _isWorkoutActive = false;
    _timer?.cancel();
    _notificationService.cancelAllNotifications();
    _remainingTime = Duration.zero;
    notifyListeners();
  }

  void _startNewCountdownInterval() {
    _timer?.cancel(); // Cancel any existing timer

    final random = Random();
    int minutes;
    String notificationBodyText;

    if (_workoutIntensity == WorkoutIntensity.normal) {
      minutes = random.nextBool() ? 10 : 15;
      notificationBodyText = '1 glass'; // Placeholder for "1 แก้ว"
    } else {
      // WorkoutIntensity.heavy
      minutes = random.nextBool() ? 15 : 20;
      notificationBodyText = '2 glasses'; // Placeholder for "2 แก้ว"
    }

    _remainingTime = Duration(minutes: minutes);
    final scheduledTime = DateTime.now().add(_remainingTime);

    // Schedule the notification
    _notificationService.scheduleNotification(
      id: _notificationId++,
      title: 'Time to hydrate!',
      body:
          'ถึงเวลาจิบน้ำแล้ว! แนะนำให้ดื่ม $notificationBodyText เพื่อรักษาสมดุลร่างกาย',
      scheduledTime: scheduledTime,
      payload: 'workout_hydration',
    );

    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_remainingTime.inSeconds <= 0) {
        _timer?.cancel();
        _startNewCountdownInterval(); // Start a new interval
      } else {
        _remainingTime = _remainingTime - const Duration(seconds: 1);
        notifyListeners();
      }
    });
  }
}

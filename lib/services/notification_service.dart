import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter/material.dart'; // For context or global navigator key if needed for navigation on notification tap

class NotificationService {
  // Singleton instance
  static final NotificationService _instance = NotificationService._internal();
  factory NotificationService() => _instance;
  NotificationService._internal();

  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  Future<void> init() async {
    // Android initialization
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    // iOS initialization
    const DarwinInitializationSettings initializationSettingsIOS =
        DarwinInitializationSettings(
          requestAlertPermission: false,
          requestBadgePermission: false,
          requestSoundPermission: false,
        );

    const InitializationSettings initializationSettings =
        InitializationSettings(
          android: initializationSettingsAndroid,
          iOS: initializationSettingsIOS,
        );

    // Initialize the plugin
    await flutterLocalNotificationsPlugin.initialize(
      settings:
          initializationSettings, // Corrected: use 'settings' as named parameter
      onDidReceiveNotificationResponse: (NotificationResponse response) async {
        // Handle notification tap
        // In a real app, you might navigate to a specific screen
        debugPrint('onDidReceiveNotificationResponse: ${response.payload}');
      },
    );
  }

  Future<bool> requestPermissions() async {
    // Android doesn't need explicit permission request for basic notifications
    // starting from Android 8.0 (API level 26) it's handled by system.
    // However, for newer Android versions (13+), we might need POST_NOTIFICATIONS permission.
    // The plugin handles this internally for basic requests.

    // Request permissions for iOS
    final bool? result = await flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
          IOSFlutterLocalNotificationsPlugin
        >()
        ?.requestPermissions(alert: true, badge: true, sound: true);
    return result ?? false;
  }

  // Placeholder for scheduling notifications, will be fully implemented in Phase 3
  Future<void> scheduleNotification({
    required int id,
    required String title,
    required String body,
    required DateTime scheduledTime,
    String? payload,
  }) async {
    // Not implemented yet. Will be done in Phase 3.
  }

  Future<void> cancelAllNotifications() async {
    // Not implemented yet. Will be done in Phase 3.
  }
}

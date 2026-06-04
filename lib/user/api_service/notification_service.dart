import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class NotificationService {

  static final FlutterLocalNotificationsPlugin
  flutterLocalNotificationsPlugin =
  FlutterLocalNotificationsPlugin();

  static Future<void> initialize() async {

    const androidSettings =
    AndroidInitializationSettings(
      '@mipmap/ic_launcher',
    );

    const settings =
    InitializationSettings(
      android: androidSettings,
    );

    await flutterLocalNotificationsPlugin
        .initialize(settings);
  }

  static Future<void> showNotification({
    required String title,
    required String body,
  }) async {

    const androidDetails =
    AndroidNotificationDetails(
      'gym_channel',
      'Gym Notifications',
      importance: Importance.max,
      priority: Priority.high,
    );

    const details =
    NotificationDetails(
      android: androidDetails,
    );

    await flutterLocalNotificationsPlugin
        .show(
      0,
      title,
      body,
      details,
    );
  }
}
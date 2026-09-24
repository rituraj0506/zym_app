import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'fcm_api_service.dart';
import 'notification_service.dart';

class FCMService {
  static Function()? onNotificationReceived;

  static Future<void> initialize() async {
    try {
      final messaging = FirebaseMessaging.instance;

      // 1. Request Notification Permission (Industry standard: after login / entering dashboard)
      final settings = await messaging.requestPermission(
        alert: true,
        badge: true,
        sound: true,
        provisional: false,
      );

      print("FCM PERMISSION STATUS => ${settings.authorizationStatus}");

      // Android 13+ runtime permission for local heads-up notification display
      await NotificationService.flutterLocalNotificationsPlugin
          .resolvePlatformSpecificImplementation<
              AndroidFlutterLocalNotificationsPlugin>()
          ?.requestNotificationsPermission();

      // 2. Retrieve FCM Token and sync with Backend database
      try {
        final token = await messaging.getToken();
        print("FCM TOKEN RETRIEVED => $token");
        if (token != null && token.isNotEmpty) {
          await FcmApiServices.saveFcmToken(token);
        }
      } catch (tokenErr) {
        print("FCM TOKEN RETRIEVAL/SAVE ERROR => $tokenErr");
      }

      // 3. FOREGROUND LISTENER (When app is open on screen)
      FirebaseMessaging.onMessage.listen(
        (RemoteMessage message) {
          print(
              "FOREGROUND NOTIFICATION RECEIVED => ${message.notification?.title ?? message.data['title']}");

          final title = message.notification?.title ??
              message.data['title'] ??
              "Gym Notification";
          final body = message.notification?.body ??
              message.data['body'] ??
              message.data['message'] ??
              "";

          // Show heads-up notification banner with sound on screen
          NotificationService.showNotification(
            title: title,
            body: body,
          );

          // Update red dot badge count in real-time without requiring pull-to-refresh
          onNotificationReceived?.call();
        },
      );

      // 4. BACKGROUND TAP LISTENER
      FirebaseMessaging.onMessageOpenedApp.listen(
        (RemoteMessage message) {
          print("BACKGROUND TAP => ${message.notification?.title}");
          onNotificationReceived?.call();
        },
      );

      // 5. APP KILLED TAP LISTENER
      final initialMessage = await messaging.getInitialMessage();
      if (initialMessage != null) {
        print("APP OPENED FROM TERMINATED STATE");
      }
    } catch (e) {
      print("FCM INIT ERROR => $e");
    }
  }
}
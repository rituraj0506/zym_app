import 'package:firebase_messaging/firebase_messaging.dart';

import 'fcm_api_service.dart';
import 'notification_service.dart';

// class FCMService {
//
//   static Future<void> initialize() async {
//
//     try {
//
//       final messaging =
//           FirebaseMessaging.instance;
//
//       NotificationSettings settings =
//       await messaging
//           .getNotificationSettings();
//
//       // First time user
//       if (settings.authorizationStatus ==
//           AuthorizationStatus.notDetermined) {
//
//         settings =
//         await messaging
//             .requestPermission();
//       }
//
//       // Permission allowed
//       if (settings.authorizationStatus ==
//           AuthorizationStatus.authorized) {
//
//         final token =
//         await messaging.getToken();
//
//         print(
//           "FCM TOKEN => $token",
//         );
//
//         if (token != null) {
//
//           await FcmApiServices
//               .saveFcmToken(token);
//         }
//       }
//
//       // User denied
//       else if (
//       settings.authorizationStatus ==
//           AuthorizationStatus.denied) {
//
//         print(
//           "Notification permission denied",
//         );
//       }
//
//     } catch (e) {
//
//       print(
//         "FCM INIT ERROR => $e",
//       );
//     }
//   }
// }


class FCMService {

  static Future<void> initialize() async {

    try {

      final messaging =
          FirebaseMessaging.instance;

      NotificationSettings settings =
      await messaging
          .getNotificationSettings();

      if (settings.authorizationStatus ==
          AuthorizationStatus.notDetermined) {

        settings =
        await messaging
            .requestPermission();
      }

      if (settings.authorizationStatus ==
          AuthorizationStatus.authorized) {

        final token =
        await messaging.getToken();

        print(
          "FCM TOKEN => $token",
        );

        if (token != null) {

          await FcmApiServices
              .saveFcmToken(token);
        }

        // FOREGROUND
        FirebaseMessaging.onMessage.listen(
              (RemoteMessage message) {

            print(
              "FOREGROUND => ${message.notification?.title}",
            );

            NotificationService
                .showNotification(
              title:
              message.notification?.title ??
                  "",
              body:
              message.notification?.body ??
                  "",
            );
          },
        );

        // BACKGROUND TAP
        FirebaseMessaging.onMessageOpenedApp
            .listen(
              (RemoteMessage message) {

            print(
              "BACKGROUND TAP => ${message.notification?.title}",
            );

          },
        );

        // APP KILLED TAP
        final initialMessage =
        await messaging
            .getInitialMessage();

        if (initialMessage != null) {

          print(
            "APP OPENED FROM TERMINATED STATE",
          );

        }
      }

      else if (
      settings.authorizationStatus ==
          AuthorizationStatus.denied) {

        print(
          "Notification permission denied",
        );
      }

    } catch (e) {

      print(
        "FCM INIT ERROR => $e",
      );
    }
  }
}
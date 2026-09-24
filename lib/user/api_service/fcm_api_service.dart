
import '../../../../../network/dio_client.dart';

class FcmApiServices {
  static Future<bool> saveFcmToken(
      String fcmToken,
      ) async {

    try {

      print("SAVE TOKEN API CALLED");
      print("FCM TOKEN => $fcmToken");

      final response =
      await DioClient.dio.put(
      "/notification/save-fcm-token",
        data: {
          "fcmToken": fcmToken,
        },
      );

      print("RESPONSE => ${response.data}");

      final data = response.data;

      return response.statusCode == 200 &&
          data["success"] == true;

    } catch (e) {

      print("SAVE TOKEN ERROR => $e");
      rethrow;
    }
  }

  static Future<void> clearFcmToken() async {
    try {
      await DioClient.dio.put("/notification/clear-fcm-token");
      print("FCM TOKEN CLEARED ON BACKEND");
    } catch (e) {
      print("CLEAR FCM TOKEN ERROR => $e");
    }
  }
}
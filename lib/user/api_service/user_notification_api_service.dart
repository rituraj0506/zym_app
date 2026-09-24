import 'package:dio/dio.dart';
import '../../network/dio_client.dart';
import '../model/user_notification_response.dart';

class UserNotificationApiService {
  /// FETCH USER NOTIFICATIONS
  static Future<UserNotificationResponse> getMyNotifications({
    int page = 1,
    int limit = 30,
  }) async {
    try {
      final response = await DioClient.dio.get(
        "/notification/my-notifications",
        queryParameters: {
          "page": page,
          "limit": limit,
        },
      );

      final data = response.data;
      if (response.statusCode == 200 && data["success"] == true) {
        return UserNotificationResponse.fromJson(data);
      } else {
        throw Exception(
          data["message"] ?? "Failed to fetch notifications",
        );
      }
    } on DioException catch (e) {
      throw Exception(
        e.response?.data["message"] ??
            e.message ??
            "Something went wrong while fetching notifications",
      );
    }
  }

  /// MARK SINGLE NOTIFICATION AS READ
  static Future<bool> markAsRead(String notificationId) async {
    try {
      final response = await DioClient.dio.put(
        "/notification/$notificationId/read",
      );

      final data = response.data;
      return response.statusCode == 200 && data["success"] == true;
    } on DioException catch (e) {
      print("MARK READ ERROR => ${e.message}");
      return false;
    }
  }

  /// MARK ALL NOTIFICATIONS AS READ
  static Future<bool> markAllAsRead() async {
    try {
      final response = await DioClient.dio.put(
        "/notification/mark-all-read",
      );

      final data = response.data;
      return response.statusCode == 200 && data["success"] == true;
    } on DioException catch (e) {
      print("MARK ALL READ ERROR => ${e.message}");
      return false;
    }
  }
}

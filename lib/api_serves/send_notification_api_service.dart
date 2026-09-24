import 'package:dio/dio.dart';
import '../network/dio_client.dart';

class OwnerNotificationHistoryItem {
  final String id;
  final String title;
  final String message;
  final String targetType;
  final int sentCount;
  final DateTime? createdAt;

  OwnerNotificationHistoryItem({
    required this.id,
    required this.title,
    required this.message,
    required this.targetType,
    required this.sentCount,
    this.createdAt,
  });

  factory OwnerNotificationHistoryItem.fromJson(Map<String, dynamic> json) {
    return OwnerNotificationHistoryItem(
      id: json["_id"] ?? "",
      title: json["title"] ?? "",
      message: json["message"] ?? "",
      targetType: json["targetType"] ?? "all",
      sentCount: json["sentCount"] ?? 0,
      createdAt: json["createdAt"] != null
          ? DateTime.tryParse(json["createdAt"].toString())
          : null,
    );
  }
}

class SendNotificationApiService {
  static Future<String> sendNotification({
    required String title,
    required String message,
    required String targetType,
    List<String>? customMembers,
  }) async {
    try {
      final response = await DioClient.dio.post(
        "/notification/send",
        data: {
          "title": title,
          "message": message,
          "targetType": targetType,
          if (customMembers != null && customMembers.isNotEmpty)
            "customMembers": customMembers,
        },
      );

      final data = response.data;

      if ((response.statusCode == 200 || response.statusCode == 201) &&
          data["success"] == true) {
        return data["message"] ?? "Notification sent successfully";
      }

      throw Exception(
        data["message"] ?? "Failed to send notification",
      );
    } on DioException catch (e) {
      throw Exception(
        e.response?.data["message"] ?? e.message ?? "Something went wrong",
      );
    }
  }

  static Future<List<OwnerNotificationHistoryItem>> getHistory({
    int limit = 100,
  }) async {
    try {
      final response = await DioClient.dio.get(
        "/notification/history",
        queryParameters: {"limit": limit},
      );
      final data = response.data;

      if (response.statusCode == 200 && data["success"] == true) {
        final list = data["data"] as List? ?? [];
        return list
            .map((item) => OwnerNotificationHistoryItem.fromJson(item))
            .toList();
      }

      return [];
    } on DioException catch (e) {
      throw Exception(
        e.response?.data["message"] ??
            e.message ??
            "Failed to fetch notification history",
      );
    }
  }
}
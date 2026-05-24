
import 'package:dio/dio.dart';

import '../network/dio_client.dart';
import '../owner/models/expiredplan_response.dart';
import '../owner/models/expiringsoonplan_response.dart';

class ExpiredPlanApiService {

  static Future<ExpiringSoonPlan> planExpiringSoon({
    int page = 1,
    int limit = 10,
  }) async {

    try {

      final response = await DioClient.dio.get(
        "/members/expiring-soon",
        queryParameters: {
          "page": page,
          "limit": limit,
        },
      );

      final data = response.data;

      if (response.statusCode == 200 &&
          data["success"] == true) {

        return ExpiringSoonPlan.fromJson(data);

      } else {

        throw Exception(
          data["message"] ??
              "Failed to fetch data",
        );
      }

    } on DioException catch (e) {

      throw Exception(
        e.response?.data["message"] ??
            e.message ??
            "Something went wrong",
      );
    }
  }

  static Future<ExpiredPlan> planExpired({
    int page = 1,
    int limit = 10,
  }) async {

    try {

      final response = await DioClient.dio.get(
        "/members/expired-members",
        queryParameters: {
          "page": page,
          "limit": limit,
        },
      );

      final data = response.data;

      if (response.statusCode == 200 &&
          data["success"] == true) {

        return ExpiredPlan.fromJson(data);

      } else {

        throw Exception(
          data["message"] ??
              "Failed to fetch data",
        );
      }

    } on DioException catch (e) {

      throw Exception(
        e.response?.data["message"] ??
            e.message ??
            "Something went wrong",
      );
    }
  }
}
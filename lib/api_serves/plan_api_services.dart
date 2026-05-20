import 'package:dio/dio.dart';

import '../network/dio_client.dart';
import '../owner/models/gym_plan_response.dart';

class PlanApiServices {

  /// CREATE PLAN
  static Future<String> createPlan({
    required String planName,
    required int durationInMonths,
    required int price,
    required String description,
  }) async {

    try {

      final response = await DioClient.dio.post(
        "/plans/create",

        data: {
          "planName": planName,
          "durationInMonths": durationInMonths,
          "price": price,
          "description": description,
        },
      );

      final data = response.data;

      if ((response.statusCode == 200 ||
          response.statusCode == 201) &&
          data["success"] == true) {

        return data["message"] ??
            "Plan Created Successfully";

      } else {

        throw Exception(
          data["message"] ??
              "Failed to create plan",
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

  /// GET ALL PLANS
  static Future<GymPlansResponse> gymProfileData() async {

    try {

      final response = await DioClient.dio.get(
        "/plans/allplan",
      );

      final data = response.data;

      if (response.statusCode == 200 &&
          data["success"] == true) {

        return GymPlansResponse.fromJson(data);

      } else {

        throw Exception(
          data["message"] ??
              "Failed to fetch plans",
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


  static Future<String> updatePlan({
    required String id,
    required String planName,
    required int durationInMonths,
    required int price,
    required String description,
  }) async {

    try {

      final response =
      await DioClient.dio.put(

        "/plans/update/$id",

        data: {
          "planName": planName,
          "durationInMonths":
          durationInMonths,
          "price": price,
          "description":
          description,
        },
      );

      final data = response.data;

      if ((response.statusCode == 200 ||
          response.statusCode == 201) &&
          data["success"] == true) {

        return data["message"] ??
            "Plan Updated Successfully";

      } else {

        throw Exception(
          data["message"] ??
              "Failed to update plan",
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


  /// DISABLE PLAN
  static Future<String> disablePlan({
    required String id,
  }) async {

    try {

      final response =
      await DioClient.dio.put(
        "/plans/disable/$id",
      );

      final data = response.data;

      if ((response.statusCode == 200 ||
          response.statusCode == 201) &&
          data["success"] == true) {

        return data["message"] ??
            "Plan Disabled Successfully";

      } else {

        throw Exception(
          data["message"] ??
              "Failed to disable plan",
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
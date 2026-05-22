import 'package:dio/dio.dart';
import '../network/dio_client.dart';
import '../owner/models/today_attendance_response.dart';
import '../owner/models/today_checkoutmember_response.dart';
import '../owner/models/today_presentmember_response.dart';

class TodayAttendanceApiServices {

  static Future<TodayAttendanceResponseModel> todayAttendance() async {

    try {

      final response = await DioClient.dio.get(
        "/attendance/today",
      );

      final data = response.data;

      if (response.statusCode == 200 &&
          data["success"] == true) {

        return TodayAttendanceResponseModel.fromJson(data);

      } else {

        throw Exception(
          data["message"] ??
              "Failed to fetch data",
        );
      }

    } on DioException catch (e) {

      throw Exception(
        e.error.toString(),
      );
    }
  }

  static Future<TodayPresentMembersResponseModel> todayPresentMember() async {

    try {

      final response = await DioClient.dio.get(
        "/attendance/present",
      );

      final data = response.data;

      if (response.statusCode == 200 &&
          data["success"] == true) {

        return TodayPresentMembersResponseModel.fromJson(data);

      } else {

        throw Exception(
          data["message"] ??
              "Failed to fetch data",
        );
      }

    } on DioException catch (e) {

      throw Exception(
        e.error.toString(),
      );
    }
  }

  static Future<TodayCheckedOutResponseModel> todayCheckOutMember() async {

    try {

      final response = await DioClient.dio.get(
        "/attendance/checked-out",
      );

      final data = response.data;

      if (response.statusCode == 200 &&
          data["success"] == true) {

        return TodayCheckedOutResponseModel.fromJson(data);

      } else {

        throw Exception(
          data["message"] ??
              "Failed to fetch data",
        );
      }

    } on DioException catch (e) {

      throw Exception(
        e.error.toString(),
      );
    }
  }



}
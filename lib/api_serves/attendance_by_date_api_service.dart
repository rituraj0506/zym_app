import 'package:dio/dio.dart';
import 'package:intl/intl.dart';

import '../network/dio_client.dart';
import '../owner/models/attendance_by_date_response.dart';

class AttendanceByDateApiService {

  static Future<AttendanceByDateResponseModel>
  attendanceByDate({
    required DateTime selectedDate,
  }) async {

    try {

      final formattedDate =
      DateFormat(
        'yyyy-MM-dd',
      ).format(selectedDate);

      final response =
      await DioClient.dio.get(
        "/attendance/by-date?date=$formattedDate",
      );

      final data = response.data;

      if (response.statusCode == 200 &&
          data["success"] == true) {

        return AttendanceByDateResponseModel
            .fromJson(data);

      } else {

        throw Exception(
          data["message"] ??
              "Failed to fetch attendance",
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
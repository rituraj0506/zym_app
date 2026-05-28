import 'package:dio/dio.dart';

import '../network/dio_client.dart';

class QrScannerApiService {

  static Future<Map<String, dynamic>>
  checkInCheckOut({
    required String qrToken,
  }) async {

    try {

      final response =
      await DioClient.dio.post(
        "/attendance/scan-qr",

        data: {
          "qrToken": qrToken,
        },
      );

      final data =
      Map<String, dynamic>.from(
        response.data,
      );

      /// SUCCESS
      if ((response.statusCode == 200 ||
          response.statusCode == 201) &&
          data["success"] == true) {

        return data;
      }

      /// MANUAL ERROR
      throw {

        "type":
        data["type"] ?? "unknown",

        "message":
        data["message"] ??
            "Attendance failed",
      };

    } on DioException catch (e) {

      print(
        "STATUS CODE : ${e.response?.statusCode}",
      );

      print(
        "DIO ERROR : ${e.message}",
      );

      print(
        "RESPONSE : ${e.response?.data}",
      );

      final data =
      Map<String, dynamic>.from(
        e.response?.data ?? {},
      );

      throw {

        "type":
        data["type"] ??
            "server-error",

        "message":
        data["message"] ??
            "Something went wrong",
      };
    }
  }
}
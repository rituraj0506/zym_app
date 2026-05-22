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

      final data = response.data;

      if ((response.statusCode == 200 ||
          response.statusCode ==
              201) &&
          data["success"] == true) {
        return data;
      } else {
        throw Exception(
          data["message"] ??
              "Attendance Failed",
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
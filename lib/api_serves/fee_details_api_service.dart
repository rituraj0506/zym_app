
import 'package:dio/dio.dart';
import 'package:zymmanagement/owner/models/member_payment_recipt.dart';

import '../network/dio_client.dart';
import '../owner/models/member_payment_history.dart';

class FeeDetailsApiService {

  static Future<PaymentHistoryResponseModel>
  memberPaymentHistory(String memberId) async {

    try {

      final response = await DioClient.dio.get(
        "/payment/member/$memberId",
      );

      final data = response.data;

      if (response.statusCode == 200 &&
          data["success"] == true) {

        return PaymentHistoryResponseModel.fromJson(data);

      } else {

        throw Exception(
          data["message"] ??
              "Failed to fetch payment history",
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

  static Future<PaymentReceiptResponseModel>
  memberPaymentReceipt(String paymentId) async {

    try {

      final response = await DioClient.dio.get(
        "/payment/receipt/$paymentId",
      );

      final data = response.data;

      if (response.statusCode == 200 &&
          data["success"] == true) {

        return PaymentReceiptResponseModel.fromJson(data);

      } else {

        throw Exception(
          data["message"] ??
              "Failed to fetch receipt",
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

  static Future<List<int>>
  memberPaymentReceiptPdf(
      String paymentId) async {

    try {

      final response =
      await DioClient.dio.get(
        "/payment/receipt-pdf/$paymentId",
        options: Options(
          responseType:
          ResponseType.bytes,
        ),
      );

      return List<int>.from(
        response.data,
      );

    } on DioException catch (e) {

      throw Exception(
        e.message ??
            "Something went wrong",
      );
    }
  }

}


import 'package:dio/dio.dart';

import '../network/dio_client.dart';
import '../owner/models/monthly_colllection_response.dart';
import '../owner/models/today_collection_response.dart';
import '../owner/models/transaction_history_response.dart';

class TransactionDetailsApiService {

  static Future<TransactionHistory> transactionData({
    int page = 1,
    int limit = 20,
  }) async {
    try {
      final response = await DioClient.dio.get(
        "/payment/all",
        queryParameters: {
          "page": page,
          "limit": limit,
        },
      );

      final data = response.data;

      if (response.statusCode == 200 &&
          data is Map<String, dynamic> &&
          data["success"] == true) {
        return TransactionHistory.fromJson(data);
      }

      throw Exception(
        data is Map<String, dynamic>
            ? data["message"] ??
            "Failed to fetch transaction history"
            : "Failed to fetch transaction history",
      );
    } on DioException catch (e) {
      throw Exception(_getErrorMessage(e));
    }
  }

  static Future<TodayCollectionResponse>
  todayCollection() async {
    try {
      final response = await DioClient.dio.get(
        "/payment/today-collection",
      );

      final data = response.data;

      if (response.statusCode == 200 &&
          data is Map<String, dynamic> &&
          data["success"] == true) {
        return TodayCollectionResponse.fromJson(data);
      }

      throw Exception(
        data is Map<String, dynamic>
            ? data["message"] ??
            "Failed to fetch today collection"
            : "Failed to fetch today collection",
      );
    } on DioException catch (e) {
      throw Exception(_getErrorMessage(e));
    }
  }

  static Future<MonthlyCollection>
  monthlyCollection() async {
    try {
      final response = await DioClient.dio.get(
        "/payment/month-collection",
      );

      final data = response.data;

      if (response.statusCode == 200 &&
          data is Map<String, dynamic> &&
          data["success"] == true) {
        return MonthlyCollection.fromJson(data);
      }

      throw Exception(
        data is Map<String, dynamic>
            ? data["message"] ??
            "Failed to fetch monthly collection"
            : "Failed to fetch monthly collection",
      );
    } on DioException catch (e) {
      throw Exception(_getErrorMessage(e));
    }
  }

  static String _getErrorMessage(
      DioException e,
      ) {
    final data = e.response?.data;

    if (data is Map<String, dynamic>) {
      return data["message"] ??
          e.message ??
          "Something went wrong";
    }

    if (data is String && data.isNotEmpty) {
      return data;
    }

    return e.message ?? "Something went wrong";
  }
}
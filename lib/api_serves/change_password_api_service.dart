import 'package:dio/dio.dart';
import '../network/dio_client.dart';

class ChangePasswordApiService {
  static Future<String> changePassword({
    required String currentPassword,
    required String newPassword,
  }) async {
    try {
      final response = await DioClient.dio.put(
        "/users/change-password",
        data: {
          "currentPassword": currentPassword,
          "newPassword": newPassword,
        },
      );

      final data = response.data;
      if (response.statusCode == 200 &&
          data is Map<String, dynamic> &&
          data["success"] == true) {
        return data["message"] ?? "Password changed successfully";
      }

      if (data is Map<String, dynamic> && data["message"] != null) {
        throw data["message"].toString();
      }

      throw "Failed to change password";
    } on DioException catch (e) {
      if (e.response?.data is Map && e.response?.data["message"] != null) {
        throw e.response!.data["message"].toString();
      }
      throw e.message ?? "Something went wrong. Please check your connection.";
    } catch (e) {
      rethrow;
    }
  }
}

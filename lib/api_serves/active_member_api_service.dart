import 'package:dio/dio.dart';
import '../network/dio_client.dart';
import '../owner/models/active_member_response.dart';
import '../owner/models/inactive_member_response.dart';

class ActiveMemberApiService {

  static Future<ActiveMembersResponseModel>
  getAllActiveMembers({
    required int page,
    int limit = 10,
  }) async {

    try {

      final Response response =
      await DioClient.dio.get(
        "/members/active-members",
        queryParameters: {
          "page": page,
          "limit": limit,
        },
      );

      print(response.data);

      /// SAFELY HANDLE RESPONSE
      if (response.data is! Map<String, dynamic>) {

        throw Exception(
          "Invalid response format",
        );
      }

      final Map<String, dynamic> data =
          response.data;

      if (response.statusCode == 200 &&
          data["success"] == true) {

        return
          ActiveMembersResponseModel.fromJson(data);

      } else {

        throw Exception(
          data["message"]?.toString() ??
              "Failed to fetch members",
        );
      }

    } on DioException catch (e) {

      print("DIO ERROR : ${e.response?.data}");

      String? errorMessage =
          "Something went wrong";

      if (e.response?.data
      is Map<String, dynamic>) {

        errorMessage =
            e.response?.data["message"]
                ?.toString() ??
                errorMessage;

      } else if (e.response?.data
      is String) {

        errorMessage =
            e.response?.data.toString();
      }

      throw Exception(errorMessage);

    } catch (e) {

      print("ERROR : $e");

      throw Exception(e.toString());
    }
  }


  static Future<INActiveMembersResponseModel>
  getAllINActiveMembers({
    required int page,
    int limit = 10,
  }) async {

    try {

      final Response response =
      await DioClient.dio.get(
        "/members/inactive-members",
        queryParameters: {
          "page": page,
          "limit": limit,
        },
      );

      print(response.data);

      /// SAFELY HANDLE RESPONSE
      if (response.data is! Map<String, dynamic>) {

        throw Exception(
          "Invalid response format",
        );
      }

      final Map<String, dynamic> data =
          response.data;

      if (response.statusCode == 200 &&
          data["success"] == true) {

        return
          INActiveMembersResponseModel.fromJson(data);

      } else {

        throw Exception(
          data["message"]?.toString() ??
              "Failed to fetch members",
        );
      }

    } on DioException catch (e) {

      print("DIO ERROR : ${e.response?.data}");

      String? errorMessage =
          "Something went wrong";

      if (e.response?.data
      is Map<String, dynamic>) {

        errorMessage =
            e.response?.data["message"]
                ?.toString() ??
                errorMessage;

      } else if (e.response?.data
      is String) {

        errorMessage =
            e.response?.data.toString();
      }

      throw Exception(errorMessage);

    } catch (e) {

      print("ERROR : $e");

      throw Exception(e.toString());
    }
  }


}
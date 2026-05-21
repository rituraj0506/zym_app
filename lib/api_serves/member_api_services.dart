import 'package:dio/dio.dart';

import '../network/dio_client.dart';
import '../owner/models/member_response.dart';

class MemberApiServices {

  static Future<MembersResponseModel>
  getAllMembers({
    required int page,
    int limit = 10,
  }) async {

    try {

      final Response response =
      await DioClient.dio.get(
        "/members/all",
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

        return MembersResponseModel
            .fromJson(data);

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




  static Future<String> addMember({
    required FormData formData,
  }) async {
    try {
      final response = await DioClient.dio.post(
        "/members/add",
        data: formData,
      );

      final data = response.data;

      if ((response.statusCode == 200 ||
          response.statusCode == 201) &&
          data["success"] == true) {
        return data["message"] ??
            "Member added successfully";
      } else {
        throw Exception(
          data["message"] ??
              "Failed to add member",
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
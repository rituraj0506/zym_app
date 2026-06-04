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

      /// SAFE RESPONSE
      if (response.data
      is! Map<String, dynamic>) {

        throw "Invalid response format";
      }

      final Map<String, dynamic> data =
      Map<String, dynamic>.from(
        response.data,
      );

      /// SUCCESS
      if (data["success"] == true) {

        return MembersResponseModel
            .fromJson(data);
      }

      /// BACKEND ERROR
      throw data["message"] ??
          "Failed to fetch members";

    } on DioException catch (e) {

      print(
        "DIO ERROR : "
            "${e.response?.data}",
      );

      throw e.error ??
          e.response?.data["message"] ??
          "Something went wrong";

    } catch (e) {

      print("ERROR : $e");

      throw e.toString();
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


  static Future<String> updateMember({
    required String memberId,
    required FormData formData,
  }) async {

    try {

      final Response response =
      await DioClient.dio.put(
        "/members/update/$memberId",
        data: formData,
      );

      final data = response.data;

      if ((response.statusCode == 200 ||
          response.statusCode == 201) &&
          data["success"] == true) {

        return data["message"] ??
            "Member updated successfully";
      }

      throw Exception(
        data["message"] ??
            "Failed to update member",
      );

    } on DioException catch (e) {

      throw Exception(

        e.response?.data?["message"] ??

            e.message ??

            "Something went wrong",
      );
    }
  }



}
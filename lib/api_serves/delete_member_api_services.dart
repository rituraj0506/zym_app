import 'package:dio/dio.dart';

import '../network/dio_client.dart';

class DeleteMemberApiServices {

  static Future<String> deleteMember({

    required String memberId,

  }) async {

    try {

      final response =
      await DioClient.dio.delete(

        "/members/delete/$memberId",
      );

      final data = response.data;

      if ((response.statusCode == 200 ||
          response.statusCode == 201) &&

          data["success"] == true) {

        return data["message"] ??
            "Member deleted successfully";
      }

      throw Exception(

        data["message"] ??
            "Failed to delete member",
      );

    } on DioException catch (e) {

      throw Exception(

        e.response?.data["message"] ??

            e.message ??

            "Something went wrong",
      );
    }
  }
}
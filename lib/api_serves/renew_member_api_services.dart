import 'package:dio/dio.dart';

import '../network/dio_client.dart';

class RenewMemberApiServices {

  static Future<String> renewMember({

    required String memberId,
    required String planId,

  }) async {

    try {

      final response =
      await DioClient.dio.put(

        "/members/renew-member/$memberId",

        data: {

          "planId": planId,
        },
      );

      final data =
          response.data;

      if ((response.statusCode == 200 ||
          response.statusCode == 201) &&

          data["success"] == true) {

        return data["message"] ??
            "Renew Successfully";
      }

      throw Exception(

        data["message"] ??
            "Failed to renew member",
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
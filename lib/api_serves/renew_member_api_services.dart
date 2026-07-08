import 'package:dio/dio.dart';

import '../network/dio_client.dart';

class RenewMemberApiServices {

  static Future<String> renewMember({

    required String memberId,
    required String planId,
    required String paymentMode,
  }) async {

    try {

      final response =
      await DioClient.dio.put(

        "/members/renew-member/$memberId",

        data: {
          "paymentMode" : paymentMode,
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


  // REJOIN MEMBER
  static Future<String> rejoinMember({
    required String memberId,
    required String planId,
    required String paymentMode,
  }) async {

    try {

      final response =
      await DioClient.dio.put(

        "/members/rejoin-member/$memberId",

        data: {
          "paymentMode": paymentMode,
          "planId": planId,
        },
      );

      final data = response.data;

      if ((response.statusCode == 200 ||
          response.statusCode == 201) &&
          data["success"] == true) {

        return data["message"] ??
            "Member Rejoined Successfully";
      }

      throw Exception(
        data["message"] ??
            "Failed to rejoin member",
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
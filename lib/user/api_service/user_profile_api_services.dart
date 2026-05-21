
import 'package:dio/dio.dart';

import '../../network/dio_client.dart';
import '../model/user_profile_response.dart';

class UserProfileApiServices {

  static Future<UserProfileResponse>
  userProfileData() async {

    try {

      final response =
      await DioClient.dio.get(
        "/members/my-profile",
      );

      final data = response.data;

      if (response.statusCode == 200 &&
          data["success"] == true) {

        return UserProfileResponse
            .fromJson(data);

      } else {

        throw Exception(
          data["message"] ??
              "Failed to fetch profile data",
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
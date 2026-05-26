import 'package:dio/dio.dart';
import '../../network/dio_client.dart';
import '../model/user_dashboard_response.dart';

class UserDashboardApiServices {


  static Future<MemberDashBoardDetailsResponse >
  userProfileData() async {

    try {

      final response =
      await DioClient.dio.get(
        "/member-dashboard/summary",
      );

      final data = response.data;

      if (response.statusCode == 200 &&
          data["success"] == true) {

        return MemberDashBoardDetailsResponse
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


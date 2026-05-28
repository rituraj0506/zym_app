import 'package:dio/dio.dart';

import '../owner/models/gym_profile_response.dart';
import '../owner/models/owner_dashboard_response.dart';
import '../network/dio_client.dart';

class DashboardApiService {

  /// GET DASHBOARD
  static Future<OwnerDashboardResponse>
  getDashBoardDetails() async {

    try {

      final response =
      await DioClient.dio.get(
        "/owner-dashboard/summary",
      );

      final data =
      Map<String, dynamic>.from(
        response.data,
      );

      /// SUCCESS
      if (data["success"] == true) {

        return OwnerDashboardResponse
            .fromJson(data);
      }

      /// CUSTOM ERROR
      throw data["message"] ??
          "Failed to fetch dashboard";

    } on DioException catch (e) {

      throw e.error ??
          e.response?.data["message"] ??
          "Something went wrong";
    }
  }


  /// CREATE GYM PROFILE

  static Future<String>
  createGymProfile({

    required FormData formData,

  }) async {

    try {

      final response =
      await DioClient.dio.post(

        "/gym-profile/create",

        data: formData,
      );

      final data = response.data;

      if ((response.statusCode == 200 ||
          response.statusCode == 201) &&
          data["success"] == true) {

        return data["message"] ??
            "Gym profile created successfully";

      } else {

        throw Exception(
          data["message"] ??
              "Failed to create gym profile",
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



 static Future<GymProfileResponse>gymProfileData() async {

   try {

     final response =
     await DioClient.dio.get(
       "/gym-profile/my-profile",
     );

     final data = response.data;

     if (response.statusCode == 200 &&
         data["success"] == true) {

       return GymProfileResponse
           .fromJson(data);

     } else {

       throw Exception(
         data["message"] ??
             "Failed to Profile Data",
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


  /// UPDATE GYM PROFILE
  static Future<String> updateGymProfile({
    required FormData formData,
  }) async {
    try {
      final response = await DioClient.dio.put(
        "/gym-profile/update",
        data: formData,
      );

      final data = response.data;

      if ((response.statusCode == 200 ||
          response.statusCode == 201) &&
          data["success"] == true) {
        return data["message"] ??
            "Gym profile updated successfully";
      } else {
        throw Exception(
          data["message"] ??
              "Failed to update gym profile",
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
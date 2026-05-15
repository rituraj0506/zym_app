// import 'dart:io';
// import 'package:bloc/bloc.dart';
// import 'package:dio/dio.dart';
// import '../../../../../network/dio_client.dart';
// import 'gym_profile_state.dart';
//
// class GymProfileCubit
//     extends Cubit<GymProfileState> {
//
//   GymProfileCubit()
//       : super(
//     GymProfileInitial(),
//   );
//
//   Future<void> createGymProfile({
//
//     required String gymName,
//     required String address,
//     required String city,
//     required String stateName,
//     required String pincode,
//     required String description,
//     required String openingTime,
//     required String closingTime,
//     required File? image,
//
//   }) async {
//
//     try {
//
//       emit(
//         GymProfileLoading(),
//       );
//
//       FormData formData =
//       FormData.fromMap({
//
//         "gymName": gymName,
//         "address": address,
//         "city": city,
//         "state": stateName,
//         "pincode": pincode,
//         "description": description,
//         "openingTime": openingTime,
//         "closingTime": closingTime,
//
//         if (image != null)
//
//           "gymImage":
//           await MultipartFile
//               .fromFile(
//             image.path,
//
//             filename:
//             image.path
//                 .split("/")
//                 .last,
//           ),
//       });
//
//       final response =
//       await DioClient.dio.post(
//
//         "/gym-profile/create",
//
//         data: formData,
//       );
//
//       if (response.statusCode == 201 ||
//           response.statusCode == 200) {
//
//         emit(
//           GymProfileSuccess(
//             response.data["message"] ??
//                 "Gym created successfully",
//           ),
//         );
//
//       } else {
//
//         emit(
//           GymProfileError(
//             "Failed to create gym",
//           ),
//         );
//       }
//
//     } catch (e) {
//
//       emit(
//         GymProfileError(
//           e.toString(),
//         ),
//       );
//     }
//   }
// }


import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';

import '../../../../../api_serves/dashboard_api_service.dart';
import 'gym_profile_state.dart';

class GymProfileCubit
    extends Cubit<GymProfileState> {

  GymProfileCubit()
      : super(GymProfileInitial());

  /// CREATE GYM PROFILE

  Future<void> createGymProfile({

    required String gymName,
    required String address,
    required String city,
    required String stateName,
    required String pincode,
    required String description,
    required String openingTime,
    required String closingTime,
    required File? image,

  }) async {

    try {

      /// CREATE LOADING
      emit(
        GymProfileCreateLoading(),
      );

      FormData formData =
      FormData.fromMap({

        "gymName": gymName,
        "address": address,
        "city": city,
        "state": stateName,
        "pincode": pincode,
        "description": description,
        "openingTime": openingTime,
        "closingTime": closingTime,

        if (image != null)

          "gymImage":
          await MultipartFile.fromFile(

            image.path,

            filename:
            image.path
                .split("/")
                .last,
          ),
      });

      /// SERVICE CALL
      final message =
      await DashboardApiService
          .createGymProfile(

        formData: formData,
      );

      emit(
        GymProfileSuccess(message),
      );

    } catch (e) {

      emit(
        GymProfileError(
          e.toString(),
        ),
      );
    }
  }

  /// GET GYM PROFILE DATA

  Future<void> getGymProfile() async {

    try {

      /// FETCH LOADING
      emit(
        GymProfileFetchingLoading(),
      );

      final response =
      await DashboardApiService
          .gymProfileData();

      emit(
        GymProfileDataSuccess(
          response,
        ),
      );

    } catch (e) {

      emit(
        GymProfileError(
          e.toString(),
        ),
      );
    }
  }
}
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




  /// UPDATE GYM PROFILE
  Future<void> updateGymProfile({
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

      /// UPDATE LOADING
      emit(
        GymProfileUpdateLoading(),
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

      final message =
      await DashboardApiService
          .updateGymProfile(
        formData: formData,
      );

      /// REFRESH PROFILE
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
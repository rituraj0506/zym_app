
import 'dart:convert';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../api_service/user_profile_api_services.dart';
import '../../../../model/user_profile_response.dart';
import 'user_profile_state.dart';

class UserProfileCubit
    extends Cubit<UserProfileState> {

  UserProfileCubit()
      : super(UserProfileInitial());

  UserProfileResponse?
  userProfileResponse;

  static const String
  profileCacheKey =
      "cached_user_profile";

  Future<void> getUserProfile({
    bool forceRefresh = false,
  }) async {

    try {

      final prefs =
      await SharedPreferences.getInstance();

      /// =========================
      /// LOAD CACHE
      /// =========================

      final cachedData =
      prefs.getString(
        profileCacheKey,
      );

      bool hasCache = false;

      if (cachedData != null) {

        hasCache = true;

        final decodedData =
        jsonDecode(cachedData);

        final cachedProfile =
        UserProfileResponse.fromJson(
          decodedData,
        );

        userProfileResponse =
            cachedProfile;

        emit(
          UserProfileDataSuccess(
            cachedProfile,
          ),
        );
      }

      /// SHOW LOADER ONLY
      /// IF CACHE NOT EXISTS

      if (!hasCache) {

        emit(
          UserProfileFetchingLoading(),
        );
      }

      /// =========================
      /// BACKGROUND API REFRESH
      /// =========================

      final freshResponse =
      await UserProfileApiServices
          .userProfileData();

      userProfileResponse =
          freshResponse;

      /// SAVE CACHE

      await prefs.setString(
        profileCacheKey,

        jsonEncode(
          freshResponse.toJson(),
        ),
      );

      /// UPDATE UI SILENTLY

      emit(
        UserProfileDataSuccess(
          freshResponse,
        ),
      );

    } catch (e) {

      if (userProfileResponse != null) {

        emit(
          UserProfileDataSuccess(
            userProfileResponse!,
          ),
        );

      } else {

        emit(
          UserProfileError(
            e.toString(),
          ),
        );
      }
    }
  }

  /// =========================
  /// CLEAR CACHE ON LOGOUT
  /// =========================

  Future<void> clearProfileCache() async {

    final prefs =
    await SharedPreferences
        .getInstance();

    await prefs.remove(
      profileCacheKey,
    );
  }
}
import 'dart:convert';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../../api_service/user_dashboard_api_services.dart';
import '../../../../model/user_dashboard_response.dart';
import 'user_dashboard_state.dart';

class UserDashboardCubit
    extends Cubit<UserDashboardState> {

  UserDashboardCubit()
      : super(UserDashboardInitial());

  MemberDashBoardDetailsResponse?
  userDashboardResponse;

  static const String
  dashboardCacheKey =
      "dashboard_cache";

  /// FETCH DASHBOARD
  Future<void> fetchUserDashboard({
    bool forceRefresh = false,
  }) async {

    try {

      /// LOAD CACHE FIRST
      if (!forceRefresh) {

        final prefs =
        await SharedPreferences
            .getInstance();

        final cachedData =
        prefs.getString(
          dashboardCacheKey,
        );

        if (cachedData != null) {

          final decoded =
          jsonDecode(cachedData);

          userDashboardResponse =
              MemberDashBoardDetailsResponse
                  .fromJson(decoded);

          emit(
            UserDashboardLoaded(
              userDashboardData:
              userDashboardResponse!,
            ),
          );
        } else {

          emit(UserDashboardLoading());
        }
      } else {

        emit(UserDashboardLoading());
      }

      /// API CALL
      final response =
      await UserDashboardApiServices
          .userProfileData();

      userDashboardResponse = response;

      /// SAVE CACHE
      final prefs =
      await SharedPreferences
          .getInstance();

      await prefs.setString(
        dashboardCacheKey,
        jsonEncode(response.toJson()),
      );

      emit(
        UserDashboardLoaded(
          userDashboardData: response,
        ),
      );

    } catch (e) {

      /// ONLY SHOW ERROR
      /// IF NO CACHE AVAILABLE
      if (userDashboardResponse == null) {

        emit(
          UserDashboardError(
            message: e.toString(),
          ),
        );
      }
    }
  }

  /// CLEAR CACHE
  Future<void> clearDashboardCache()
  async {

    final prefs =
    await SharedPreferences
        .getInstance();

    await prefs.remove(
      dashboardCacheKey,
    );
  }
}
import 'dart:convert';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../../../api_serves/dashboard_api_service.dart';
import '../../../../models/owner_dashboard_response.dart';
import 'owner_dashboard_state.dart';

class OwnerDashboardCubit extends Cubit<OwnerDashboardState> {
  OwnerDashboardCubit() : super(OwnerDashboardInitial());

  Future<void> initializeDashboard() async {
    await loadCachedData();

    await getDashboardData();
  }

  Future<void> loadCachedData() async {
    final prefs = await SharedPreferences.getInstance();

    final cache = prefs.getString("dashboard_cache");

    if (cache != null) {
      final data = jsonDecode(cache);

      final dashboardData = OwnerDashboardResponse.fromJson(data);

      final gym = dashboardData.data?.gym;

      final isGymSetupComplete =
          gym != null && gym.gymName != null && gym.gymName!.isNotEmpty;

      emit(
        OwnerDashboardLoaded(
          dashboardData: dashboardData,
          isGymSetupComplete: isGymSetupComplete,
        ),
      );
    }
  }

  Future<void> getDashboardData() async {
    try {
      /// ONLY SHOW LOADER
      /// IF DATA NOT AVAILABLE

      if (state is! OwnerDashboardLoaded) {
        emit(OwnerDashboardLoading());
      }

      final response = await DashboardApiService.getDashBoardDetails();

      final gym = response.data?.gym;

      final isGymSetupComplete =
          gym != null && gym.gymName != null && gym.gymName!.isNotEmpty;

      final prefs = await SharedPreferences.getInstance();

      prefs.setString("dashboard_cache", jsonEncode(response.toJson()));

      emit(
        OwnerDashboardLoaded(
          dashboardData: response,
          isGymSetupComplete: isGymSetupComplete,
        ),
      );
    } catch (e) {
      String errorMessage = e.toString();

      /// REMOVE "Exception:"
      if (errorMessage.startsWith("Exception:")) {
        errorMessage = errorMessage.replaceFirst("Exception:", "").trim();
      }

      emit(OwnerDashboardError(errorMessage));
    }
  }

  void clearDashboard() {
    emit(OwnerDashboardInitial());
  }
}

import '../../../../models/owner_dashboard_response.dart';

abstract class OwnerDashboardState {}

class OwnerDashboardInitial
    extends OwnerDashboardState {}

class OwnerDashboardLoading
    extends OwnerDashboardState {}

class OwnerDashboardLoaded
    extends OwnerDashboardState {

  final OwnerDashboardResponse
  dashboardData;

  final bool isGymSetupComplete;

  OwnerDashboardLoaded({
    required this.dashboardData,
    required this.isGymSetupComplete,
  });
}

class OwnerDashboardError
    extends OwnerDashboardState {

  final String message;

  OwnerDashboardError(this.message);
}


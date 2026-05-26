import '../../../../model/user_dashboard_response.dart';

abstract class UserDashboardState {}

/// INITIAL
class UserDashboardInitial
    extends UserDashboardState {}

/// LOADING
class UserDashboardLoading
    extends UserDashboardState {}

/// SUCCESS
class UserDashboardLoaded
    extends UserDashboardState {

  final MemberDashBoardDetailsResponse
  userDashboardData;

  UserDashboardLoaded({
    required this.userDashboardData,
  });
}

/// ERROR
class UserDashboardError
    extends UserDashboardState {

  final String message;

  UserDashboardError({
    required this.message,
  });
}
import '../../../../model/user_notification_response.dart';

abstract class UserNotificationState {}

class UserNotificationInitial extends UserNotificationState {}

class UserNotificationLoading extends UserNotificationState {}

class UserNotificationLoaded extends UserNotificationState {
  final List<UserNotificationItem> notifications;
  final int unreadCount;

  UserNotificationLoaded({
    required this.notifications,
    required this.unreadCount,
  });
}

class UserNotificationError extends UserNotificationState {
  final String message;

  UserNotificationError(this.message);
}

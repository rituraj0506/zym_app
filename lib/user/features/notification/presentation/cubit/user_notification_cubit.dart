import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../api_service/user_notification_api_service.dart';
import '../../../../model/user_notification_response.dart';
import 'user_notification_state.dart';

class UserNotificationCubit extends Cubit<UserNotificationState> {
  UserNotificationCubit() : super(UserNotificationInitial());

  List<UserNotificationItem> _notifications = [];

  List<UserNotificationItem> get notifications => _notifications;

  int get unreadCount => _notifications.where((n) => !n.isRead).length;

  /// FETCH NOTIFICATIONS
  Future<void> fetchNotifications({bool isRefresh = false}) async {
    if (!isRefresh && _notifications.isEmpty) {
      emit(UserNotificationLoading());
    }

    try {
      final response =
          await UserNotificationApiService.getMyNotifications(page: 1, limit: 50);

      _notifications = response.data ?? [];

      emit(
        UserNotificationLoaded(
          notifications: List.from(_notifications),
          unreadCount: unreadCount,
        ),
      );
    } catch (e) {
      emit(
        UserNotificationError(
          e.toString().replaceFirst("Exception: ", ""),
        ),
      );
    }
  }

  /// MARK SINGLE AS READ (Optimistic UI update)
  Future<void> markAsRead(String notificationId) async {
    final index = _notifications.indexWhere((n) => n.id == notificationId);
    if (index != -1 && !_notifications[index].isRead) {
      _notifications[index] = _notifications[index].copyWith(
        isRead: true,
        readAt: DateTime.now(),
      );

      emit(
        UserNotificationLoaded(
          notifications: List.from(_notifications),
          unreadCount: unreadCount,
        ),
      );

      // Async backend call
      await UserNotificationApiService.markAsRead(notificationId);
    }
  }

  /// MARK ALL AS READ (Optimistic UI update)
  Future<void> markAllAsRead() async {
    if (unreadCount == 0) return;

    final now = DateTime.now();
    _notifications = _notifications.map((n) {
      return n.copyWith(isRead: true, readAt: now);
    }).toList();

    emit(
      UserNotificationLoaded(
        notifications: List.from(_notifications),
        unreadCount: 0,
      ),
    );

    // Async backend call
    await UserNotificationApiService.markAllAsRead();
  }
}

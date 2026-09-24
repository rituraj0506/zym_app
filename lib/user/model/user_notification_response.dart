class UserNotificationResponse {
  final bool success;
  final int? currentPage;
  final int? totalPages;
  final int? total;
  final List<UserNotificationItem>? data;

  UserNotificationResponse({
    required this.success,
    this.currentPage,
    this.totalPages,
    this.total,
    this.data,
  });

  factory UserNotificationResponse.fromJson(Map<String, dynamic> json) {
    return UserNotificationResponse(
      success: json['success'] ?? false,
      currentPage: json['currentPage'],
      totalPages: json['totalPages'],
      total: json['total'],
      data: json['data'] != null
          ? (json['data'] as List)
              .map((item) => UserNotificationItem.fromJson(item))
              .toList()
          : [],
    );
  }
}

class UserNotificationItem {
  final String id;
  final String? user;
  final String? notification;
  final String title;
  final String message;
  final bool isRead;
  final DateTime? readAt;
  final DateTime? createdAt;

  UserNotificationItem({
    required this.id,
    this.user,
    this.notification,
    required this.title,
    required this.message,
    this.isRead = false,
    this.readAt,
    this.createdAt,
  });

  factory UserNotificationItem.fromJson(Map<String, dynamic> json) {
    return UserNotificationItem(
      id: json['_id'] ?? '',
      user: json['user'] is String ? json['user'] : json['user']?['_id'],
      notification: json['notification'] is String
          ? json['notification']
          : json['notification']?['_id'],
      title: json['title'] ?? 'Notification',
      message: json['message'] ?? '',
      isRead: json['isRead'] ?? false,
      readAt: json['readAt'] != null
          ? DateTime.tryParse(json['readAt'].toString())
          : null,
      createdAt: json['createdAt'] != null
          ? DateTime.tryParse(json['createdAt'].toString())
          : null,
    );
  }

  UserNotificationItem copyWith({
    bool? isRead,
    DateTime? readAt,
  }) {
    return UserNotificationItem(
      id: id,
      user: user,
      notification: notification,
      title: title,
      message: message,
      isRead: isRead ?? this.isRead,
      readAt: readAt ?? this.readAt,
      createdAt: createdAt,
    );
  }
}

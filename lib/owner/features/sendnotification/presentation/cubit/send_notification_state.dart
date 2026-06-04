abstract class SendNotificationState {}

class SendNotificationInitial extends SendNotificationState {}

class SendNotificationLoading extends SendNotificationState {}

class SendNotificationSuccess extends SendNotificationState {
  final String message;

  SendNotificationSuccess(this.message);
}

class SendNotificationError extends SendNotificationState {
  final String message;

  SendNotificationError(this.message);
}
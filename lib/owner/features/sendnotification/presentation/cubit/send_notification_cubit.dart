import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../../api_serves/send_notification_api_service.dart';
import 'send_notification_state.dart';

class SendNotificationCubit
    extends Cubit<SendNotificationState> {
  SendNotificationCubit()
      : super(SendNotificationInitial());

  Future<void> sendNotification({
    required String title,
    required String message,
    required String targetType,
    List<String>? customMembers,
  }) async {
    emit(SendNotificationLoading());

    try {
      final response =
      await SendNotificationApiService
          .sendNotification(
        title: title,
        message: message,
        targetType: targetType,
        customMembers: customMembers,
      );

      emit(
        SendNotificationSuccess(response),
      );
    } catch (e) {
      emit(
        SendNotificationError(
          e.toString().replaceFirst(
            'Exception: ',
            '',
          ),
        ),
      );
    }
  }
}
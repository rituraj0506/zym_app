import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../../api_serves/qr_scanner_api_service.dart';
import 'scan_qr_state.dart';

class ScanQrCubit
    extends Cubit<ScanQrState> {
  ScanQrCubit()
      : super(ScanQrInitial());

  Future<void> checkInCheckOut({
    required String qrToken,
  }) async {
    try {
      emit(ScanQrLoading());

      final response =
      await QrScannerApiService
          .checkInCheckOut(
        qrToken: qrToken,
      );

      final member =
      response["data"]["member"];

      final attendance =
      response["data"]["attendance"];

      emit(
        ScanQrSuccess(
          type: response["type"],

          memberName:
          member["name"] ?? "",

          message:
          response["message"] ?? "",

          voiceText:
          response["voiceText"] ?? "",

          checkInTime:
          attendance["checkInTime"]
              .toString(),

          checkOutTime:
          attendance["checkOutTime"]
              ?.toString(),

          attendanceDate:
          attendance["attendanceDate"]
              .toString(),

          profilePhoto:
          member["profilePhoto"],
        ),
      );
    } catch (e) {
      emit(
        ScanQrError(e.toString()),
      );
    }
  }
}
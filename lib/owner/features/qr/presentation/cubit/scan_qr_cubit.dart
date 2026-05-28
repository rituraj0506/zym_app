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
      Map<String, dynamic>.from(
        response["data"]["member"],
      );

      final attendance =
      Map<String, dynamic>.from(
        response["data"]["attendance"],
      );

      emit(

        ScanQrSuccess(

          type:
          response["type"]
              ?.toString() ??
              "",

          memberName:
          member["name"]
              ?.toString() ??
              "",

          message:
          response["message"]
              ?.toString() ??
              "",

          voiceText:
          response["voiceText"]
              ?.toString() ??
              "",

          checkInTime:
          attendance["checkInTime"]
              ?.toString() ??
              "",

          checkOutTime:
          attendance["checkOutTime"]
              ?.toString(),

          attendanceDate:
          attendance["attendanceDate"]
              ?.toString() ??
              "",

          profilePhoto:
          member["profilePhoto"]
              ?.toString(),
        ),
      );

    } catch (e) {

      print(
        "SCAN QR ERROR : $e",
      );

      if (e is Map) {

        final error =
        Map<String, dynamic>.from(e);

        emit(
          ScanQrError(

            type:
            error["type"]
                ?.toString() ??
                "unknown",

            message:
            error["message"]
                ?.toString() ??
                "Something went wrong",
          ),
        );

      } else {

        emit(
          ScanQrError(

            type: "unknown",

            message:
            e.toString(),
          ),
        );
      }
    }
  }
}
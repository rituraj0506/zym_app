import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../api_serves/today_attendance_api_services.dart';

import '../../../../models/today_attendance_response.dart';
import '../../../../models/today_checkoutmember_response.dart';
import '../../../../models/today_presentmember_response.dart';

import 'attendance_state.dart';

class AttendanceCubit
    extends Cubit<AttendanceState> {

  AttendanceCubit()
      : super(
    const AttendanceInitial(),
  );

  /// TODAY ATTENDANCE
  TodayAttendanceResponseModel?
  todayAttendanceResponseModel;

  /// TODAY PRESENT MEMBERS
  TodayPresentMembersResponseModel?
  todayPresentMembersResponseModel;

  /// TODAY CHECKED OUT MEMBERS
  TodayCheckedOutResponseModel?
  todayCheckedOutResponseModel;

  /// FETCH ALL DATA
  Future<void>
  fetchAttendanceData() async {

    try {

      emit(
        const AttendanceLoading(),
      );

      final responses =
      await Future.wait([

        TodayAttendanceApiServices
            .todayAttendance(),

        TodayAttendanceApiServices
            .todayPresentMember(),

        TodayAttendanceApiServices
            .todayCheckOutMember(),
      ]);

      /// ALL ATTENDANCE
      todayAttendanceResponseModel =
      responses[0]
      as TodayAttendanceResponseModel;

      /// PRESENT MEMBERS
      todayPresentMembersResponseModel =
      responses[1]
      as TodayPresentMembersResponseModel;

      /// CHECKED OUT MEMBERS
      todayCheckedOutResponseModel =
      responses[2]
      as TodayCheckedOutResponseModel;

      emit(
        const AttendanceLoaded(),
      );

    } catch (e) {

      emit(
        AttendanceError(
          _getErrorMessage(e),
        ),
      );
    }
  }

  /// CLEAN ERROR MESSAGE
  String _getErrorMessage(
      dynamic error) {

    final errorString =
    error.toString();

    if (errorString.startsWith(
      "Exception: ",
    )) {

      return errorString.replaceFirst(
        "Exception: ",
        "",
      );
    }

    return errorString;
  }
}
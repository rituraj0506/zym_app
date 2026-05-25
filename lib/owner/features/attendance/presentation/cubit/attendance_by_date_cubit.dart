
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../../api_serves/attendance_by_date_api_service.dart';
import '../../../../models/attendance_by_date_response.dart';
import 'attendance_by_date_state.dart';

class AttendanceByDateCubit
    extends Cubit<AttendanceByDateState> {

  AttendanceByDateCubit()
      : super(
    const AttendanceByDateInitial(),
  );

  AttendanceByDateResponseModel?
  attendanceResponse;

  Future<void> fetchAttendanceByDate({
    required DateTime selectedDate,
  }) async {

    try {

      emit(
        const AttendanceByDateLoading(),
      );

      final response =
      await AttendanceByDateApiService
          .attendanceByDate(
        selectedDate: selectedDate,
      );

      attendanceResponse = response;

      emit(
        AttendanceByDateLoaded(
          attendance: response,
        ),
      );

    } catch (e) {

      emit(
        AttendanceByDateError(
          message: e.toString(),
        ),
      );
    }
  }
}
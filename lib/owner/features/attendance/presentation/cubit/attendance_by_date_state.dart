import '../../../../models/attendance_by_date_response.dart';

abstract class AttendanceByDateState {

  const AttendanceByDateState();
}

/// INITIAL
class AttendanceByDateInitial
    extends AttendanceByDateState {

  const AttendanceByDateInitial();
}

/// LOADING
class AttendanceByDateLoading
    extends AttendanceByDateState {

  const AttendanceByDateLoading();
}

/// SUCCESS
class AttendanceByDateLoaded
    extends AttendanceByDateState {

  final AttendanceByDateResponseModel
  attendance;

  const AttendanceByDateLoaded({
    required this.attendance,
  });
}

/// ERROR
class AttendanceByDateError
    extends AttendanceByDateState {

  final String message;

  const AttendanceByDateError({
    required this.message,
  });
}
// import '../../../../models/today_attendance_response.dart';
// import '../../../../models/today_checkoutmember_response.dart';
// import '../../../../models/today_presentmember_response.dart';
//
// abstract class AttendanceState {
//   const AttendanceState();
// }
//
// /// INITIAL
// class AttendanceInitial extends AttendanceState {
//   const AttendanceInitial();
// }
//
// /// LOADING
// class AttendanceLoading extends AttendanceState {
//   const AttendanceLoading();
// }
//
// /// TODAY ATTENDANCE LOADED
// class AttendanceLoaded extends AttendanceState {
//
//   final TodayAttendanceResponseModel
//   response;
//
//   const AttendanceLoaded(
//       this.response,
//       );
// }
//
// /// TODAY PRESENT MEMBERS LOADED
// class PresentMembersLoaded
//     extends AttendanceState {
//
//   final TodayPresentMembersResponseModel
//   response;
//
//   const PresentMembersLoaded(
//       this.response,
//       );
// }
//
// /// TODAY CHECKED OUT MEMBERS LOADED
// class CheckedOutMembersLoaded
//     extends AttendanceState {
//
//   final TodayCheckedOutResponseModel
//   response;
//
//   const CheckedOutMembersLoaded(
//       this.response,
//       );
// }
//
// /// ERROR
// class AttendanceError
//     extends AttendanceState {
//
//   final String message;
//
//   const AttendanceError(
//       this.message,
//       );
// }


abstract class AttendanceState {

  const AttendanceState();
}

/// INITIAL
class AttendanceInitial
    extends AttendanceState {

  const AttendanceInitial();
}

/// LOADING
class AttendanceLoading
    extends AttendanceState {

  const AttendanceLoading();
}

/// SUCCESS
class AttendanceLoaded
    extends AttendanceState {

  const AttendanceLoaded();
}

/// ERROR
class AttendanceError
    extends AttendanceState {

  final String message;

  const AttendanceError(
      this.message,
      );
}
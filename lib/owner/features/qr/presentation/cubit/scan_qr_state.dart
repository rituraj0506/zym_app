abstract class ScanQrState {}

/// INITIAL
class ScanQrInitial extends ScanQrState {}

/// LOADING
class ScanQrLoading extends ScanQrState {}

/// SUCCESS
class ScanQrSuccess extends ScanQrState {
  final String type;

  final String memberName;

  final String message;

  final String voiceText;

  final String checkInTime;

  final String? checkOutTime;

  final String attendanceDate;

  final String? profilePhoto;

  ScanQrSuccess({
    required this.type,
    required this.memberName,
    required this.message,
    required this.voiceText,
    required this.checkInTime,
    this.checkOutTime,
    required this.attendanceDate,
    this.profilePhoto,
  });
}

/// ERROR
class ScanQrError extends ScanQrState {
  final String message;

  ScanQrError(this.message);
}
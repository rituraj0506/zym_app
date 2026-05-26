class MemberDashBoardDetailsResponse {
  final bool? success;
  final MemberDetailsData? data;

  MemberDashBoardDetailsResponse({
    this.success,
    this.data,
  });

  factory MemberDashBoardDetailsResponse.fromJson(
      Map<String, dynamic> json,
      ) {
    return MemberDashBoardDetailsResponse(
      success: json['success'],
      data: json['data'] != null
          ? MemberDetailsData.fromJson(json['data'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'success': success,
      'data': data?.toJson(),
    };
  }
}

class MemberDetailsData {
  final Member? member;
  final Plan? plan;
  final Gym? gym;
  final TodayAttendance? todayAttendance;
  final AttendanceSummary? attendanceSummary;

  MemberDetailsData({
    this.member,
    this.plan,
    this.gym,
    this.todayAttendance,
    this.attendanceSummary,
  });

  factory MemberDetailsData.fromJson(Map<String, dynamic> json) {
    return MemberDetailsData(
      member: json['member'] != null
          ? Member.fromJson(json['member'])
          : null,
      plan: json['plan'] != null
          ? Plan.fromJson(json['plan'])
          : null,
      gym: json['gym'] != null
          ? Gym.fromJson(json['gym'])
          : null,
      todayAttendance: json['todayAttendance'] != null
          ? TodayAttendance.fromJson(json['todayAttendance'])
          : null,
      attendanceSummary: json['attendanceSummary'] != null
          ? AttendanceSummary.fromJson(json['attendanceSummary'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'member': member?.toJson(),
      'plan': plan?.toJson(),
      'gym': gym?.toJson(),
      'todayAttendance': todayAttendance?.toJson(),
      'attendanceSummary': attendanceSummary?.toJson(),
    };
  }
}

class Member {
  final String? id;
  final String? name;
  final String? email;
  final int? mobNo;
  final String? profilePhoto;
  final String? memberStatus;
  final String? qrToken;
  final DateTime? joiningDate;

  Member({
    this.id,
    this.name,
    this.email,
    this.mobNo,
    this.profilePhoto,
    this.memberStatus,
    this.qrToken,
    this.joiningDate,
  });

  factory Member.fromJson(Map<String, dynamic> json) {
    return Member(
      id: json['_id'],
      name: json['name'],
      email: json['email'],
      mobNo: json['mobNo'],
      profilePhoto: json['profilePhoto'],
      memberStatus: json['memberStatus'],
      qrToken: json['qrToken'],
      joiningDate: json['joiningDate'] != null
          ? DateTime.parse(json['joiningDate'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'name': name,
      'email': email,
      'mobNo': mobNo,
      'profilePhoto': profilePhoto,
      'memberStatus': memberStatus,
      'qrToken': qrToken,
      'joiningDate': joiningDate?.toIso8601String(),
    };
  }
}

class Plan {
  final String? planName;
  final int? price;
  final DateTime? expiryDate;
  final int? daysLeft;

  Plan({
    this.planName,
    this.price,
    this.expiryDate,
    this.daysLeft,
  });

  factory Plan.fromJson(Map<String, dynamic> json) {
    return Plan(
      planName: json['planName'],
      price: json['price'],
      expiryDate: json['expiryDate'] != null
          ? DateTime.parse(json['expiryDate'])
          : null,
      daysLeft: json['daysLeft'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'planName': planName,
      'price': price,
      'expiryDate': expiryDate?.toIso8601String(),
      'daysLeft': daysLeft,
    };
  }
}

class Gym {
  final String? gymName;
  final String? gymImage;
  final String? address;
  final String? openingTime;
  final String? closingTime;

  Gym({
    this.gymName,
    this.gymImage,
    this.address,
    this.openingTime,
    this.closingTime,
  });

  factory Gym.fromJson(Map<String, dynamic> json) {
    return Gym(
      gymName: json['gymName'],
      gymImage: json['gymImage'],
      address: json['address'],
      openingTime: json['openingTime'],
      closingTime: json['closingTime'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'gymName': gymName,
      'gymImage': gymImage,
      'address': address,
      'openingTime': openingTime,
      'closingTime': closingTime,
    };
  }
}

class TodayAttendance {
  final bool? checkedIn;
  final String? checkInTime;
  final String? checkOutTime;

  TodayAttendance({
    this.checkedIn,
    this.checkInTime,
    this.checkOutTime,
  });

  factory TodayAttendance.fromJson(Map<String, dynamic> json) {
    return TodayAttendance(
      checkedIn: json['checkedIn'],
      checkInTime: json['checkInTime'],
      checkOutTime: json['checkOutTime'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'checkedIn': checkedIn,
      'checkInTime': checkInTime,
      'checkOutTime': checkOutTime,
    };
  }
}

class AttendanceSummary {
  final int? presentDays;
  final int? absentDays;
  final int? totalDaysCurrentMonth;

  AttendanceSummary({
    this.presentDays,
    this.absentDays,
    this.totalDaysCurrentMonth,
  });

  factory AttendanceSummary.fromJson(Map<String, dynamic> json) {
    return AttendanceSummary(
      presentDays: json['presentDays'],
      absentDays: json['absentDays'],
      totalDaysCurrentMonth: json['totalDaysCurrentMonth'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'presentDays': presentDays,
      'absentDays': absentDays,
      'totalDaysCurrentMonth': totalDaysCurrentMonth,
    };
  }
}
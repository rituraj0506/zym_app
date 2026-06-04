class AttendanceByDateResponseModel {
  final bool? success;
  final int? totalAttendance;
  final String? selectedDate;
  final List<AttendanceData>? data;

  AttendanceByDateResponseModel({
    this.success,
    this.totalAttendance,
    this.selectedDate,
    this.data,
  });

  factory AttendanceByDateResponseModel.fromJson(
      Map<String, dynamic> json,
      ) {
    return AttendanceByDateResponseModel(
      success: json['success'],
      totalAttendance: json['totalAttendance'],
      selectedDate: json['selectedDate'],
      data: json['data'] != null
          ? (json['data'] as List)
          .map(
            (e) => AttendanceData.fromJson(e),
      )
          .toList()
          : [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'success': success,
      'totalAttendance': totalAttendance,
      'selectedDate': selectedDate,
      'data': data?.map((e) => e.toJson()).toList(),
    };
  }
}

class AttendanceData {
  final String? id;
  final Member? member;
  final String? owner;
  final String? gym;
  final String? checkInTime;
  final String? attendanceDate;
  final String? status;
  final bool? autoCheckout;
  final String? createdAt;
  final String? updatedAt;
  final int? v;
  final String? checkOutTime;

  AttendanceData({
    this.id,
    this.member,
    this.owner,
    this.gym,
    this.checkInTime,
    this.attendanceDate,
    this.status,
    this.autoCheckout,
    this.createdAt,
    this.updatedAt,
    this.v,
    this.checkOutTime,
  });

  factory AttendanceData.fromJson(
      Map<String, dynamic> json,
      ) {
    return AttendanceData(
      id: json['_id'],
      member: json['member'] != null
          ? Member.fromJson(json['member'])
          : null,
      owner: json['owner'],
      gym: json['gym'],
      checkInTime: json['checkInTime'],
      attendanceDate: json['attendanceDate'],
      status: json['status'],
      autoCheckout: json['autoCheckout'],
      createdAt: json['createdAt'],
      updatedAt: json['updatedAt'],
      v: json['__v'],
      checkOutTime: json['checkOutTime'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'member': member?.toJson(),
      'owner': owner,
      'gym': gym,
      'checkInTime': checkInTime,
      'attendanceDate': attendanceDate,
      'status': status,
      'autoCheckout': autoCheckout,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
      '__v': v,
      'checkOutTime': checkOutTime,
    };
  }
}

class Member {
  final String? id;
  final User? user;
  final String? owner;
  final String? gym;

  final String? name;
  final String? mobNo;

  final int? age;
  final String? aadhaarNo;
  final String? profilePhoto;
  final String? plan;
  final String? expiryDate;
  final String? memberStatus;
  final String? qrToken;
  final bool? isDeleted;
  final String? joiningDate;
  final String? createdAt;
  final String? updatedAt;
  final int? v;
  final String? lastAttendanceDate;

  Member({
    this.id,
    this.user,
    this.owner,
    this.gym,
    this.name,
    this.mobNo,
    this.age,
    this.aadhaarNo,
    this.profilePhoto,
    this.plan,
    this.expiryDate,
    this.memberStatus,
    this.qrToken,
    this.isDeleted,
    this.joiningDate,
    this.createdAt,
    this.updatedAt,
    this.v,
    this.lastAttendanceDate,
  });

  factory Member.fromJson(Map<String, dynamic> json) {
    return Member(
      id: json['_id'],
      user: json['user'] != null
          ? User.fromJson(json['user'])
          : null,
      owner: json['owner'],
      gym: json['gym'],
      name: json['name'],
      mobNo: json['mobNo']?.toString(),
      age: json['age'],
      aadhaarNo: json['aadhaarNo'],
      profilePhoto: json['profilePhoto'],
      plan: json['plan'],
      expiryDate: json['expiryDate'],
      memberStatus: json['memberStatus'],
      qrToken: json['qrToken'],
      isDeleted: json['isDeleted'],
      joiningDate: json['joiningDate'],
      createdAt: json['createdAt'],
      updatedAt: json['updatedAt'],
      v: json['__v'],
      lastAttendanceDate: json['lastAttendanceDate'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'user': user?.toJson(),
      'owner': owner,
      'gym': gym,
      'name': name,
      'mobNo': mobNo,
      'age': age,
      'aadhaarNo': aadhaarNo,
      'profilePhoto': profilePhoto,
      'plan': plan,
      'expiryDate': expiryDate,
      'memberStatus': memberStatus,
      'qrToken': qrToken,
      'isDeleted': isDeleted,
      'joiningDate': joiningDate,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
      '__v': v,
      'lastAttendanceDate': lastAttendanceDate,
    };
  }
}

class User {
  final String? id;
  final String? name;
  final String? email;
  final String? mobNo;

  User({
    this.id,
    this.name,
    this.email,
    this.mobNo,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['_id'],
      name: json['name'],
      email: json['email'],
      mobNo: json['mobNo']?.toString(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'name': name,
      'email': email,
      'mobNo': mobNo,
    };
  }
}
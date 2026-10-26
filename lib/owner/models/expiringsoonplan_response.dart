class ExpiringSoonPlan {
  final bool? success;
  final PaginationData? pagination;
  final List<MemberData>? data;

  ExpiringSoonPlan({
    this.success,
    this.pagination,
    this.data,
  });

  factory ExpiringSoonPlan.fromJson(
      Map<String, dynamic> json,
      ) {
    return ExpiringSoonPlan(
      success: json['success'],
      pagination: json['pagination'] != null
          ? PaginationData.fromJson(
        json['pagination'],
      )
          : null,
      data: json['data'] != null
          ? List<MemberData>.from(
        json['data'].map(
              (x) => MemberData.fromJson(x),
        ),
      )
          : [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'success': success,
      'pagination': pagination?.toJson(),
      'data': data?.map((e) => e.toJson()).toList(),
    };
  }
}

class PaginationData {
  final int? totalMembers;
  final int? totalPages;
  final int? currentPage;
  final int? limit;
  final bool? hasNextPage;
  final bool? hasPrevPage;

  PaginationData({
    this.totalMembers,
    this.totalPages,
    this.currentPage,
    this.limit,
    this.hasNextPage,
    this.hasPrevPage,
  });

  factory PaginationData.fromJson(
      Map<String, dynamic> json,
      ) {
    return PaginationData(
      totalMembers: json['totalMembers'],
      totalPages: json['totalPages'],
      currentPage: json['currentPage'],
      limit: json['limit'],
      hasNextPage: json['hasNextPage'],
      hasPrevPage: json['hasPrevPage'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'totalMembers': totalMembers,
      'totalPages': totalPages,
      'currentPage': currentPage,
      'limit': limit,
      'hasNextPage': hasNextPage,
      'hasPrevPage': hasPrevPage,
    };
  }
}

class MemberData {
  final String? id;
  final MemberUser? user;
  final String? owner;
  final String? gym;

  final String? name;
  final String? mobNo;

  final int? age;
  final String? aadhaarNo;
  final String? profilePhoto;
  final MemberPlan? plan;
  final DateTime? expiryDate;
  final String? memberStatus;
  final String? qrToken;
  final bool? isDeleted;
  final DateTime? joiningDate;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final int? v;
  final DateTime? lastAttendanceDate;

  MemberData({
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

  factory MemberData.fromJson(
      Map<String, dynamic> json,
      ) {
    return MemberData(
      id: json['_id'],
      user: json['user'] != null
          ? MemberUser.fromJson(json['user'])
          : null,
      owner: json['owner'],
      gym: json['gym'],

      name: json['name'],
      mobNo: json['mobNo']?.toString(),

      age: json['age'],
      aadhaarNo: json['aadhaarNo'],
      profilePhoto: json['profilePhoto'],

      plan: json['plan'] != null
          ? MemberPlan.fromJson(json['plan'])
          : null,

      expiryDate: json['expiryDate'] != null
          ? DateTime.parse(json['expiryDate']).toLocal()
          : null,

      memberStatus: json['memberStatus'],
      qrToken: json['qrToken'],
      isDeleted: json['isDeleted'],

      joiningDate: json['joiningDate'] != null
          ? DateTime.parse(json['joiningDate']).toLocal()
          : null,

      createdAt: json['createdAt'] != null
          ? DateTime.parse(json['createdAt']).toLocal()
          : null,

      updatedAt: json['updatedAt'] != null
          ? DateTime.parse(json['updatedAt']).toLocal()
          : null,

      v: json['__v'],

      lastAttendanceDate:
      json['lastAttendanceDate'] != null
          ? DateTime.parse(
        json['lastAttendanceDate'],
      ).toLocal()
          : null,
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
      'plan': plan?.toJson(),
      'expiryDate': expiryDate?.toIso8601String(),
      'memberStatus': memberStatus,
      'qrToken': qrToken,
      'isDeleted': isDeleted,
      'joiningDate': joiningDate?.toIso8601String(),
      'createdAt': createdAt?.toIso8601String(),
      'updatedAt': updatedAt?.toIso8601String(),
      '__v': v,
      'lastAttendanceDate':
      lastAttendanceDate?.toIso8601String(),
    };
  }
}

class MemberUser {
  final String? id;
  final String? name;
  final String? email;
  final String? mobNo;
  final String? role;

  MemberUser({
    this.id,
    this.name,
    this.email,
    this.mobNo,
    this.role,
  });

  factory MemberUser.fromJson(
      Map<String, dynamic> json,
      ) {
    return MemberUser(
      id: json['_id'],
      name: json['name'],
      email: json['email'],
      mobNo: json['mobNo']?.toString(),
      role: json['role'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'name': name,
      'email': email,
      'mobNo': mobNo,
      'role': role,
    };
  }
}

class MemberPlan {
  final String? id;
  final String? planName;

  MemberPlan({
    this.id,
    this.planName,
  });

  factory MemberPlan.fromJson(
      Map<String, dynamic> json,
      ) {
    return MemberPlan(
      id: json['_id'],
      planName: json['planName'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'planName': planName,
    };
  }
}
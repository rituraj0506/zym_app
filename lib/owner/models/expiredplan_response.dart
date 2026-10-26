class ExpiredPlan {
  final bool? success;
  final ExpiredPagination? pagination;
  final List<ExpiredMemberData>? data;

  ExpiredPlan({
    this.success,
    this.pagination,
    this.data,
  });

  factory ExpiredPlan.fromJson(
      Map<String, dynamic> json,
      ) {
    return ExpiredPlan(
      success: json['success'],
      pagination: json['pagination'] != null
          ? ExpiredPagination.fromJson(
        json['pagination'],
      )
          : null,
      data: json['data'] != null
          ? List<ExpiredMemberData>.from(
        json['data'].map(
              (x) => ExpiredMemberData.fromJson(x),
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

class ExpiredPagination {
  final int? totalMembers;
  final int? totalPages;
  final int? currentPage;
  final int? limit;
  final bool? hasNextPage;
  final bool? hasPrevPage;

  ExpiredPagination({
    this.totalMembers,
    this.totalPages,
    this.currentPage,
    this.limit,
    this.hasNextPage,
    this.hasPrevPage,
  });

  factory ExpiredPagination.fromJson(
      Map<String, dynamic> json,
      ) {
    return ExpiredPagination(
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

class ExpiredMemberData {
  final String? id;
  final ExpiredUser? user;
  final String? owner;
  final String? gym;

  final String? name;
  final String? mobNo;

  final int? age;
  final String? aadhaarNo;
  final String? profilePhoto;
  final ExpiredPlanDetails? plan;
  final DateTime? expiryDate;
  final String? memberStatus;
  final String? qrToken;
  final bool? isDeleted;
  final DateTime? joiningDate;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final int? v;
  final DateTime? lastAttendanceDate;

  ExpiredMemberData({
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

  factory ExpiredMemberData.fromJson(
      Map<String, dynamic> json,
      ) {
    return ExpiredMemberData(
      id: json['_id'],
      user: json['user'] != null
          ? ExpiredUser.fromJson(json['user'])
          : null,
      owner: json['owner'],
      gym: json['gym'],

      name: json['name'],
      mobNo: json['mobNo']?.toString(),

      age: json['age'],
      aadhaarNo: json['aadhaarNo'],
      profilePhoto: json['profilePhoto'],

      plan: json['plan'] != null
          ? ExpiredPlanDetails.fromJson(
        json['plan'],
      )
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

class ExpiredUser {
  final String? id;
  final String? name;
  final String? email;
  final String? mobNo;
  final String? role;

  ExpiredUser({
    this.id,
    this.name,
    this.email,
    this.mobNo,
    this.role,
  });

  factory ExpiredUser.fromJson(
      Map<String, dynamic> json,
      ) {
    return ExpiredUser(
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

class ExpiredPlanDetails {
  final String? id;
  final String? planName;

  ExpiredPlanDetails({
    this.id,
    this.planName,
  });

  factory ExpiredPlanDetails.fromJson(
      Map<String, dynamic> json,
      ) {
    return ExpiredPlanDetails(
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
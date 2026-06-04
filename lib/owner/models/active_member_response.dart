class ActiveMembersResponseModel {
  final bool? success;
  final Pagination? pagination;
  final List<MemberData>? data;

  ActiveMembersResponseModel({
    this.success,
    this.pagination,
    this.data,
  });

  factory ActiveMembersResponseModel.fromJson(
      Map<String, dynamic> json,
      ) {
    return ActiveMembersResponseModel(
      success: json['success'],
      pagination: json['pagination'] != null
          ? Pagination.fromJson(json['pagination'])
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

class Pagination {
  final int? totalMembers;
  final int? totalPages;
  final int? currentPage;
  final int? limit;
  final bool? hasNextPage;
  final bool? hasPrevPage;

  Pagination({
    this.totalMembers,
    this.totalPages,
    this.currentPage,
    this.limit,
    this.hasNextPage,
    this.hasPrevPage,
  });

  factory Pagination.fromJson(
      Map<String, dynamic> json,
      ) {
    return Pagination(
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
  final User? user;
  final String? owner;
  final String? gym;
  final int? age;
  final String? aadhaarNo;
  final String? profilePhoto;
  final Plan? plan;
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
          ? User.fromJson(json['user'])
          : null,
      owner: json['owner'],
      gym: json['gym'],
      age: json['age'],
      aadhaarNo: json['aadhaarNo'],
      profilePhoto: json['profilePhoto'],
      plan: json['plan'] != null
          ? Plan.fromJson(json['plan'])
          : null,
      expiryDate: json['expiryDate'] != null
          ? DateTime.tryParse(json['expiryDate'])
          : null,
      memberStatus: json['memberStatus'],
      qrToken: json['qrToken'],
      isDeleted: json['isDeleted'],
      joiningDate: json['joiningDate'] != null
          ? DateTime.tryParse(json['joiningDate'])
          : null,
      createdAt: json['createdAt'] != null
          ? DateTime.tryParse(json['createdAt'])
          : null,
      updatedAt: json['updatedAt'] != null
          ? DateTime.tryParse(json['updatedAt'])
          : null,
      v: json['__v'],
      lastAttendanceDate:
      json['lastAttendanceDate'] != null
          ? DateTime.tryParse(
        json['lastAttendanceDate'],
      )
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'user': user?.toJson(),
      'owner': owner,
      'gym': gym,
      'age': age,
      'aadhaarNo': aadhaarNo,
      'profilePhoto': profilePhoto,
      'plan': plan?.toJson(),
      'expiryDate':
      expiryDate?.toIso8601String(),
      'memberStatus': memberStatus,
      'qrToken': qrToken,
      'isDeleted': isDeleted,
      'joiningDate':
      joiningDate?.toIso8601String(),
      'createdAt':
      createdAt?.toIso8601String(),
      'updatedAt':
      updatedAt?.toIso8601String(),
      '__v': v,
      'lastAttendanceDate':
      lastAttendanceDate
          ?.toIso8601String(),
    };
  }
}

class User {
  final String? id;
  final String? name;
  final String? email;
  final String? mobNo;
  final String? role;

  User({
    this.id,
    this.name,
    this.email,
    this.mobNo,
    this.role,
  });

  factory User.fromJson(
      Map<String, dynamic> json,
      ) {
    return User(
      id: json['_id'],
      name: json['name'],
      email: json['email'],
      mobNo: json["mobNo"]?.toString(),
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

class Plan {
  final String? id;
  final String? planName;
  final int? price;

  Plan({
    this.id,
    this.planName,
    this.price,
  });

  factory Plan.fromJson(
      Map<String, dynamic> json,
      ) {
    return Plan(
      id: json['_id'],
      planName: json['planName'],
      price: json['price'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'planName': planName,
      'price': price,
    };
  }
}
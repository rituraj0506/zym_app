class MembersResponseModel {

  final bool? success;

  final PaginationModel? pagination;

  final List<MemberData> data;

  MembersResponseModel({
    this.success,
    this.pagination,
    this.data = const [],
  });

  factory MembersResponseModel.fromJson(
      Map<String, dynamic> json,
      ) {

    return MembersResponseModel(

      success:
      json["success"] as bool?,

      pagination:
      json["pagination"]
      is Map<String, dynamic>
          ? PaginationModel.fromJson(
        json["pagination"],
      )
          : null,

      data:
      json["data"] is List
          ? List<MemberData>.from(
        (json["data"]
        as List<dynamic>)
            .map(
              (e) => MemberData
              .fromJson(
            e as Map<
                String,
                dynamic>,
          ),
        ),
      )
          : [],
    );
  }

  Map<String, dynamic> toJson() {

    return {

      "success": success,

      "pagination":
      pagination?.toJson(),

      "data":
      data
          .map(
            (e) => e.toJson(),
      )
          .toList(),
    };
  }
}

/// =================================
/// PAGINATION MODEL
/// =================================

class PaginationModel {

  final int totalMembers;

  final int totalPages;

  final int currentPage;

  final int limit;

  final bool hasNextPage;

  final bool hasPrevPage;

  PaginationModel({
    this.totalMembers = 0,
    this.totalPages = 0,
    this.currentPage = 1,
    this.limit = 10,
    this.hasNextPage = false,
    this.hasPrevPage = false,
  });

  factory PaginationModel.fromJson(
      Map<String, dynamic> json,
      ) {

    return PaginationModel(

      totalMembers:
      (json["totalMembers"]
      as num?)
          ?.toInt() ??
          0,

      totalPages:
      (json["totalPages"]
      as num?)
          ?.toInt() ??
          0,

      currentPage:
      (json["currentPage"]
      as num?)
          ?.toInt() ??
          1,

      limit:
      (json["limit"]
      as num?)
          ?.toInt() ??
          10,

      hasNextPage:
      json["hasNextPage"]
      as bool? ??
          false,

      hasPrevPage:
      json["hasPrevPage"]
      as bool? ??
          false,
    );
  }

  Map<String, dynamic> toJson() {

    return {

      "totalMembers":
      totalMembers,

      "totalPages":
      totalPages,

      "currentPage":
      currentPage,

      "limit":
      limit,

      "hasNextPage":
      hasNextPage,

      "hasPrevPage":
      hasPrevPage,
    };
  }
}

/// =================================
/// MEMBER DATA MODEL
/// =================================

class MemberData {
  final String id;

  final UserModel? user;

  final String owner;

  final String gym;

  final String name;

  final String mobNo;

  final int age;

  final String aadhaarNo;

  final String profilePhoto;

  final PlanModel? plan;

  final DateTime? expiryDate;

  final String memberStatus;

  final String qrToken;

  final DateTime? lastAttendanceDate;

  final bool isDeleted;

  final DateTime? joiningDate;

  final DateTime? createdAt;

  final DateTime? updatedAt;

  final int v;

  MemberData({
    this.id = "",
    this.user,
    this.owner = "",
    this.gym = "",
    this.name = "",
    this.mobNo = "",
    this.age = 0,
    this.aadhaarNo = "",
    this.profilePhoto = "",
    this.plan,
    this.expiryDate,
    this.memberStatus = "",
    this.qrToken = "",
    this.lastAttendanceDate,
    this.isDeleted = false,
    this.joiningDate,
    this.createdAt,
    this.updatedAt,
    this.v = 0,
  });

  factory MemberData.fromJson(
      Map<String, dynamic> json,
      ) {
    return MemberData(
      id: json["_id"]?.toString() ?? "",

      user: json["user"] is Map<String, dynamic>
          ? UserModel.fromJson(
        json["user"],
      )
          : null,

      owner: json["owner"]?.toString() ?? "",

      gym: json["gym"]?.toString() ?? "",

      name: json["name"]?.toString() ?? "",

      mobNo: json["mobNo"]?.toString() ?? "",

      age: (json["age"] as num?)?.toInt() ?? 0,

      aadhaarNo: json["aadhaarNo"]?.toString() ?? "",

      profilePhoto:
      (json["profilePhoto"] != null &&
          json["profilePhoto"]
              .toString()
              .trim()
              .isNotEmpty)
          ? json["profilePhoto"].toString()
          : "",

      plan: json["plan"] is Map<String, dynamic>
          ? PlanModel.fromJson(
        json["plan"],
      )
          : null,

      expiryDate: json["expiryDate"] != null
          ? DateTime.tryParse(
        json["expiryDate"].toString(),
      )
          : null,

      memberStatus:
      json["memberStatus"]?.toString() ?? "",

      qrToken: json["qrToken"]?.toString() ?? "",

      lastAttendanceDate:
      json["lastAttendanceDate"] != null
          ? DateTime.tryParse(
        json["lastAttendanceDate"]
            .toString(),
      )
          : null,

      isDeleted:
      json["isDeleted"] as bool? ?? false,

      joiningDate:
      json["joiningDate"] != null
          ? DateTime.tryParse(
        json["joiningDate"]
            .toString(),
      )
          : null,

      createdAt:
      json["createdAt"] != null
          ? DateTime.tryParse(
        json["createdAt"]
            .toString(),
      )
          : null,

      updatedAt:
      json["updatedAt"] != null
          ? DateTime.tryParse(
        json["updatedAt"]
            .toString(),
      )
          : null,

      v: (json["__v"] as num?)?.toInt() ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "_id": id,

      "user": user?.toJson(),

      "owner": owner,

      "gym": gym,

      "name": name,

      "mobNo": mobNo,

      "age": age,

      "aadhaarNo": aadhaarNo,

      "profilePhoto": profilePhoto,

      "plan": plan?.toJson(),

      "expiryDate":
      expiryDate?.toIso8601String(),

      "memberStatus": memberStatus,

      "qrToken": qrToken,

      "lastAttendanceDate":
      lastAttendanceDate?.toIso8601String(),

      "isDeleted": isDeleted,

      "joiningDate":
      joiningDate?.toIso8601String(),

      "createdAt":
      createdAt?.toIso8601String(),

      "updatedAt":
      updatedAt?.toIso8601String(),

      "__v": v,
    };
  }
}

/// =================================
/// USER MODEL
/// =================================

class UserModel {

  final String id;

  final String name;

  final String email;

  final String mobNo;

  final String role;

  UserModel({
    this.id = "",
    this.name = "",
    this.email = "",
    this.mobNo = "",
    this.role = "",
  });

  factory UserModel.fromJson(
      Map<String, dynamic> json,
      ) {

    return UserModel(

      id:
      json["_id"]
          ?.toString() ??
          "",

      name:
      json["name"]
          ?.toString() ??
          "",

      email:
      json["email"]
          ?.toString() ??
          "",

      mobNo:
      json["mobNo"]
          ?.toString() ??
          "",

      role:
      json["role"]
          ?.toString() ??
          "",
    );
  }

  Map<String, dynamic> toJson() {

    return {

      "_id":
      id,

      "name":
      name,

      "email":
      email,

      "mobNo":
      mobNo,

      "role":
      role,
    };
  }
}

/// =================================
/// PLAN MODEL
/// =================================

class PlanModel {

  final String id;

  final String planName;

  final int durationInMonths;

  final int price;

  PlanModel({
    this.id = "",
    this.planName = "",
    this.durationInMonths = 0,
    this.price = 0,
  });

  factory PlanModel.fromJson(
      Map<String, dynamic> json,
      ) {

    return PlanModel(

      id:
      json["_id"]
          ?.toString() ??
          "",

      planName:
      json["planName"]
          ?.toString() ??
          "",

      durationInMonths:
      (json["durationInMonths"]
      as num?)
          ?.toInt() ??
          0,

      price:
      (json["price"]
      as num?)
          ?.toInt() ??
          0,
    );
  }

  Map<String, dynamic> toJson() {

    return {

      "_id":
      id,

      "planName":
      planName,

      "durationInMonths":
      durationInMonths,

      "price":
      price,
    };
  }
}
class SearchMemberResponse {
  final bool? success;
  final int? totalMembers;
  final List<SearchMember>? data;

  SearchMemberResponse({
    this.success,
    this.totalMembers,
    this.data,
  });

  factory SearchMemberResponse.fromJson(
      Map<String, dynamic> json,
      ) {
    return SearchMemberResponse(
      success: json["success"],
      totalMembers: json["totalMembers"],
      data: json["data"] == null
          ? []
          : List<SearchMember>.from(
        json["data"].map(
              (x) => SearchMember.fromJson(x),
        ),
      ),
    );
  }
}

class SearchMember {
  final String? id;
  final UserModel? user;
  final String? owner;
  final String? gym;
  final String? name;
  final String? mobNo;
  final int? age;
  final String? aadhaarNo;
  final String? profilePhoto;
  final PlanModel? plan;
  final DateTime? expiryDate;
  final String? memberStatus;
  final String? qrToken;
  final DateTime? lastAttendanceDate;
  final bool? isDeleted;
  final DateTime? joiningDate;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final int? v;

  SearchMember({
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
    this.lastAttendanceDate,
    this.isDeleted,
    this.joiningDate,
    this.createdAt,
    this.updatedAt,
    this.v,
  });

  factory SearchMember.fromJson(
      Map<String, dynamic> json,
      ) {
    return SearchMember(
      id: json["_id"],
      user: json["user"] == null
          ? null
          : UserModel.fromJson(json["user"]),
      owner: json["owner"],
      gym: json["gym"],
      name: json["name"],
      mobNo: json["mobNo"],
      age: json["age"],
      aadhaarNo: json["aadhaarNo"],
      profilePhoto: json["profilePhoto"],
      plan: json["plan"] == null
          ? null
          : PlanModel.fromJson(json["plan"]),
      expiryDate: json["expiryDate"] == null
          ? null
          : DateTime.parse(json["expiryDate"]),
      memberStatus: json["memberStatus"],
      qrToken: json["qrToken"],
      lastAttendanceDate:
      json["lastAttendanceDate"] == null
          ? null
          : DateTime.parse(
        json["lastAttendanceDate"],
      ),
      isDeleted: json["isDeleted"],
      joiningDate: json["joiningDate"] == null
          ? null
          : DateTime.parse(
        json["joiningDate"],
      ),
      createdAt: json["createdAt"] == null
          ? null
          : DateTime.parse(
        json["createdAt"],
      ),
      updatedAt: json["updatedAt"] == null
          ? null
          : DateTime.parse(
        json["updatedAt"],
      ),
      v: json["__v"],
    );
  }
}

class UserModel {
  final String? id;
  final String? name;
  final String? email;
  final String? mobNo;
  final String? role;

  UserModel({
    this.id,
    this.name,
    this.email,
    this.mobNo,
    this.role,
  });

  factory UserModel.fromJson(
      Map<String, dynamic> json,
      ) {
    return UserModel(
      id: json["_id"],
      name: json["name"],
      email: json["email"],
      mobNo: json["mobNo"]?.toString(),
      role: json["role"],
    );
  }
}

class PlanModel {
  final String? id;
  final String? planName;
  final int? durationInMonths;
  final int? price;

  PlanModel({
    this.id,
    this.planName,
    this.durationInMonths,
    this.price,
  });

  factory PlanModel.fromJson(
      Map<String, dynamic> json,
      ) {
    return PlanModel(
      id: json["_id"],
      planName: json["planName"],
      durationInMonths:
      json["durationInMonths"],
      price: json["price"],
    );
  }
}
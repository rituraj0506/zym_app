class UserProfileResponse {
  final bool? success;
  final MemberData? data;

  UserProfileResponse({
    this.success,
    this.data,
  });

  factory UserProfileResponse.fromJson(
      Map<String, dynamic> json) {
    return UserProfileResponse(
      success: json["success"],
      data: json["data"] != null
          ? MemberData.fromJson(json["data"])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "success": success,
      "data": data?.toJson(),
    };
  }
}

class MemberData {
  final String? lastAttendanceDate;
  final String? id;
  final UserModel? user;
  final String? owner;
  final GymModel? gym;
  final int? age;
  final String? aadhaarNo;
  final String? profilePhoto;
  final PlanModel? plan;
  final String? expiryDate;
  final String? memberStatus;
  final String? qrToken;
  final bool? isDeleted;
  final String? joiningDate;
  final String? createdAt;
  final String? updatedAt;
  final int? v;

  MemberData({
    this.lastAttendanceDate,
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
  });

  factory MemberData.fromJson(
      Map<String, dynamic> json) {
    return MemberData(
      lastAttendanceDate:
      json["lastAttendanceDate"],

      id: json["_id"],

      user: json["user"] != null
          ? UserModel.fromJson(json["user"])
          : null,

      owner: json["owner"],

      gym: json["gym"] != null
          ? GymModel.fromJson(json["gym"])
          : null,

      age: json["age"],

      aadhaarNo: json["aadhaarNo"],

      profilePhoto: json["profilePhoto"],

      plan: json["plan"] != null
          ? PlanModel.fromJson(json["plan"])
          : null,

      expiryDate: json["expiryDate"],

      memberStatus: json["memberStatus"],

      qrToken: json["qrToken"],

      isDeleted: json["isDeleted"],

      joiningDate: json["joiningDate"],

      createdAt: json["createdAt"],

      updatedAt: json["updatedAt"],

      v: json["__v"],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "lastAttendanceDate":
      lastAttendanceDate,

      "_id": id,

      "user": user?.toJson(),

      "owner": owner,

      "gym": gym?.toJson(),

      "age": age,

      "aadhaarNo": aadhaarNo,

      "profilePhoto": profilePhoto,

      "plan": plan?.toJson(),

      "expiryDate": expiryDate,

      "memberStatus": memberStatus,

      "qrToken": qrToken,

      "isDeleted": isDeleted,

      "joiningDate": joiningDate,

      "createdAt": createdAt,

      "updatedAt": updatedAt,

      "__v": v,
    };
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
      Map<String, dynamic> json) {
    return UserModel(
      id: json["_id"],
      name: json["name"],
      email: json["email"],
      mobNo: json["mobNo"].toString(),
      role: json["role"],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "_id": id,
      "name": name,
      "email": email,
      "mobNo": mobNo,
      "role": role,
    };
  }
}

class GymModel {
  final String? id;
  final String? gymName;
  final String? gymImage;
  final String? address;

  GymModel({
    this.id,
    this.gymName,
    this.gymImage,
    this.address,
  });

  factory GymModel.fromJson(
      Map<String, dynamic> json) {
    return GymModel(
      id: json["_id"],
      gymName: json["gymName"],
      gymImage: json["gymImage"],
      address: json["address"],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "_id": id,
      "gymName": gymName,
      "gymImage": gymImage,
      "address": address,
    };
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
      Map<String, dynamic> json) {
    return PlanModel(
      id: json["_id"],
      planName: json["planName"],
      durationInMonths:
      json["durationInMonths"],
      price: json["price"],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "_id": id,
      "planName": planName,
      "durationInMonths":
      durationInMonths,
      "price": price,
    };
  }
}
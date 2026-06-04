class OwnerDashboardResponse {
  final bool? success;
  final OwnerDashboardData? data;

  OwnerDashboardResponse({
    this.success,
    this.data,
  });

  factory OwnerDashboardResponse.fromJson(
      Map<String, dynamic> json,
      ) {
    return OwnerDashboardResponse(
      success: json["success"],
      data: json["data"] != null
          ? OwnerDashboardData.fromJson(json["data"])
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

class OwnerDashboardData {
  final OwnerModel? owner;
  final GymModel? gym;
  final StatsModel? stats;

  OwnerDashboardData({
    this.owner,
    this.gym,
    this.stats,
  });

  factory OwnerDashboardData.fromJson(
      Map<String, dynamic> json,
      ) {
    return OwnerDashboardData(
      owner: json["owner"] != null
          ? OwnerModel.fromJson(json["owner"])
          : null,

      gym: json["gym"] != null
          ? GymModel.fromJson(json["gym"])
          : null,

      stats: json["stats"] != null
          ? StatsModel.fromJson(json["stats"])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "owner": owner?.toJson(),
      "gym": gym?.toJson(),
      "stats": stats?.toJson(),
    };
  }
}

class OwnerModel {
  final String? id;
  final String? name;
  final String? email;
  final String? mobNo;
  final String? role;

  OwnerModel({
    this.id,
    this.name,
    this.email,
    this.mobNo,
    this.role,
  });

  factory OwnerModel.fromJson(Map<String, dynamic> json) {

    return OwnerModel(
      id: json["_id"],
      name: json["name"],
      email: json["email"],
      mobNo: json["mobNo"],
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
  final String? city;
  final String? state;
  final String? pincode;
  final String? openingTime;
  final String? closingTime;

  GymModel({
    this.id,
    this.gymName,
    this.gymImage,
    this.address,
    this.city,
    this.state,
    this.pincode,
    this.openingTime,
    this.closingTime,
  });

  factory GymModel.fromJson(
      Map<String, dynamic> json,
      ) {
    return GymModel(
      id: json["_id"],
      gymName: json["gymName"],
      gymImage: json["gymImage"],
      address: json["address"],
      city: json["city"],
      state: json["state"],
      pincode: json["pincode"],
      openingTime: json["openingTime"],
      closingTime: json["closingTime"],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "_id": id,
      "gymName": gymName,
      "gymImage": gymImage,
      "address": address,
      "city": city,
      "state": state,
      "pincode": pincode,
      "openingTime": openingTime,
      "closingTime": closingTime,
    };
  }
}

class StatsModel {
  final int? totalMembers;
  final int? activeMembers;
  final int? expiredPlans;
  final int? checkInsToday;
  final int? presentInsideGym;

  StatsModel({
    this.totalMembers,
    this.activeMembers,
    this.expiredPlans,
    this.checkInsToday,
    this.presentInsideGym,
  });

  factory StatsModel.fromJson(
      Map<String, dynamic> json,
      ) {
    return StatsModel(
      totalMembers: json["totalMembers"],
      activeMembers: json["activeMembers"],
      expiredPlans: json["expiredPlans"],
      checkInsToday: json["checkInsToday"],
      presentInsideGym: json["presentInsideGym"],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "totalMembers": totalMembers,
      "activeMembers": activeMembers,
      "expiredPlans": expiredPlans,
      "checkInsToday": checkInsToday,
      "presentInsideGym": presentInsideGym,
    };
  }
}
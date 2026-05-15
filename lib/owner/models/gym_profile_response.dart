class GymProfileResponse {
  final bool? success;
  final GymData? data;

  GymProfileResponse({
    this.success,
    this.data,
  });

  factory GymProfileResponse.fromJson(Map<String, dynamic> json) {
    return GymProfileResponse(
      success: json['success'],
      data: json['data'] != null
          ? GymData.fromJson(json['data'])
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

class GymData {
  final String? id;
  final Owner? owner;
  final String? gymName;
  final String? gymImage;
  final String? address;
  final String? city;
  final String? state;
  final String? pincode;
  final String? description;
  final String? openingTime;
  final String? closingTime;
  final String? createdAt;
  final String? updatedAt;
  final int? v;

  GymData({
    this.id,
    this.owner,
    this.gymName,
    this.gymImage,
    this.address,
    this.city,
    this.state,
    this.pincode,
    this.description,
    this.openingTime,
    this.closingTime,
    this.createdAt,
    this.updatedAt,
    this.v,
  });

  factory GymData.fromJson(Map<String, dynamic> json) {
    return GymData(
      id: json['_id'],
      owner: json['owner'] != null
          ? Owner.fromJson(json['owner'])
          : null,
      gymName: json['gymName'],
      gymImage: json['gymImage'],
      address: json['address'],
      city: json['city'],
      state: json['state'],
      pincode: json['pincode'],
      description: json['description'],
      openingTime: json['openingTime'],
      closingTime: json['closingTime'],
      createdAt: json['createdAt'],
      updatedAt: json['updatedAt'],
      v: json['__v'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'owner': owner?.toJson(),
      'gymName': gymName,
      'gymImage': gymImage,
      'address': address,
      'city': city,
      'state': state,
      'pincode': pincode,
      'description': description,
      'openingTime': openingTime,
      'closingTime': closingTime,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
      '__v': v,
    };
  }
}

class Owner {
  final String? id;
  final String? name;
  final String? email;
  final int? mobNo;
  final String? role;

  Owner({
    this.id,
    this.name,
    this.email,
    this.mobNo,
    this.role,
  });

  factory Owner.fromJson(Map<String, dynamic> json) {
    return Owner(
      id: json['_id'],
      name: json['name'],
      email: json['email'],
      mobNo: json['mobNo'],
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
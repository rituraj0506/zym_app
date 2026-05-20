class GymPlansResponse {
  final bool? success;
  final int? totalPlans;
  final List<GymPlan>? data;

  GymPlansResponse({
    this.success,
    this.totalPlans,
    this.data,
  });

  factory GymPlansResponse.fromJson(Map<String, dynamic> json) {
    return GymPlansResponse(
      success: json['success'] as bool?,
      totalPlans: json['totalPlans'] as int?,
      data: json['data'] != null
          ? (json['data'] as List)
          .map((e) => GymPlan.fromJson(e))
          .toList()
          : [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'success': success,
      'totalPlans': totalPlans,
      'data': data?.map((e) => e.toJson()).toList(),
    };
  }
}

class GymPlan {
  final String? id;
  final String? owner;
  final String? gym;
  final String? planName;
  final int? durationInMonths;
  final int? price;
  final String? description;
  final bool? isActive;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final int? v;

  GymPlan({
    this.id,
    this.owner,
    this.gym,
    this.planName,
    this.durationInMonths,
    this.price,
    this.description,
    this.isActive,
    this.createdAt,
    this.updatedAt,
    this.v,
  });

  factory GymPlan.fromJson(Map<String, dynamic> json) {
    return GymPlan(
      id: json['_id'] as String?,
      owner: json['owner'] as String?,
      gym: json['gym'] as String?,
      planName: json['planName'] as String?,
      durationInMonths: json['durationInMonths'] as int?,
      price: json['price'] as int?,
      description: json['description'] as String?,
      isActive: json['isActive'] as bool?,
      createdAt: json['createdAt'] != null
          ? DateTime.tryParse(json['createdAt'])
          : null,
      updatedAt: json['updatedAt'] != null
          ? DateTime.tryParse(json['updatedAt'])
          : null,
      v: json['__v'] as int?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'owner': owner,
      'gym': gym,
      'planName': planName,
      'durationInMonths': durationInMonths,
      'price': price,
      'description': description,
      'isActive': isActive,
      'createdAt': createdAt?.toIso8601String(),
      'updatedAt': updatedAt?.toIso8601String(),
      '__v': v,
    };
  }
}
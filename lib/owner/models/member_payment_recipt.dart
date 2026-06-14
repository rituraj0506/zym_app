class PaymentReceiptResponseModel {
  final bool? success;
  final PaymentReceiptData? data;

  PaymentReceiptResponseModel({
    this.success,
    this.data,
  });

  factory PaymentReceiptResponseModel.fromJson(
      Map<String, dynamic> json) {
    return PaymentReceiptResponseModel(
      success: json['success'] as bool?,
      data: json['data'] != null
          ? PaymentReceiptData.fromJson(json['data'])
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

class PaymentReceiptData {
  final String? id;
  final MemberInfo? member;
  final String? owner;
  final GymInfo? gym;
  final PlanInfo? plan;
  final int? amount;
  final String? receiptNumber;
  final String? paymentMode;
  final String? transactionId;
  final String? paymentType;
  final String? notes;
  final DateTime? startDate;
  final DateTime? endDate;
  final DateTime? paidDate;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final int? v;

  PaymentReceiptData({
    this.id,
    this.member,
    this.owner,
    this.gym,
    this.plan,
    this.amount,
    this.receiptNumber,
    this.paymentMode,
    this.transactionId,
    this.paymentType,
    this.notes,
    this.startDate,
    this.endDate,
    this.paidDate,
    this.createdAt,
    this.updatedAt,
    this.v,
  });

  factory PaymentReceiptData.fromJson(
      Map<String, dynamic> json) {
    return PaymentReceiptData(
      id: json['_id'] as String?,
      member: json['member'] != null
          ? MemberInfo.fromJson(json['member'])
          : null,
      owner: json['owner'] as String?,
      gym: json['gym'] != null
          ? GymInfo.fromJson(json['gym'])
          : null,
      plan: json['plan'] != null
          ? PlanInfo.fromJson(json['plan'])
          : null,
      amount: json['amount'] as int?,
      receiptNumber: json['receiptNumber'] as String?,
      paymentMode: json['paymentMode'] as String?,
      transactionId: json['transactionId'] as String?,
      paymentType: json['paymentType'] as String?,
      notes: json['notes'] as String?,
      startDate: json['startDate'] != null
          ? DateTime.tryParse(json['startDate'])
          : null,
      endDate: json['endDate'] != null
          ? DateTime.tryParse(json['endDate'])
          : null,
      paidDate: json['paidDate'] != null
          ? DateTime.tryParse(json['paidDate'])
          : null,
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
      'member': member?.toJson(),
      'owner': owner,
      'gym': gym?.toJson(),
      'plan': plan?.toJson(),
      'amount': amount,
      'receiptNumber': receiptNumber,
      'paymentMode': paymentMode,
      'transactionId': transactionId,
      'paymentType': paymentType,
      'notes': notes,
      'startDate': startDate?.toIso8601String(),
      'endDate': endDate?.toIso8601String(),
      'paidDate': paidDate?.toIso8601String(),
      'createdAt': createdAt?.toIso8601String(),
      'updatedAt': updatedAt?.toIso8601String(),
      '__v': v,
    };
  }
}

class MemberInfo {
  final String? id;
  final String? name;
  final String? mobNo;
  final DateTime? expiryDate;

  MemberInfo({
    this.id,
    this.name,
    this.mobNo,
    this.expiryDate,
  });

  factory MemberInfo.fromJson(
      Map<String, dynamic> json) {
    return MemberInfo(
      id: json['_id'] as String?,
      name: json['name'] as String?,
      mobNo: json['mobNo'] as String?,
      expiryDate: json['expiryDate'] != null
          ? DateTime.tryParse(json['expiryDate'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'name': name,
      'mobNo': mobNo,
      'expiryDate': expiryDate?.toIso8601String(),
    };
  }
}

class GymInfo {
  final String? id;
  final String? gymName;
  final String? address;

  GymInfo({
    this.id,
    this.gymName,
    this.address,
  });

  factory GymInfo.fromJson(
      Map<String, dynamic> json) {
    return GymInfo(
      id: json['_id'] as String?,
      gymName: json['gymName'] as String?,
      address: json['address'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'gymName': gymName,
      'address': address,
    };
  }
}

class PlanInfo {
  final String? id;
  final String? planName;
  final int? price;

  PlanInfo({
    this.id,
    this.planName,
    this.price,
  });

  factory PlanInfo.fromJson(
      Map<String, dynamic> json) {
    return PlanInfo(
      id: json['_id'] as String?,
      planName: json['planName'] as String?,
      price: json['price'] as int?,
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
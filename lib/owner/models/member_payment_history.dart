class PaymentHistoryResponseModel {
  final bool? success;
  final int? count;
  final List<PaymentHistoryData>? data;

  PaymentHistoryResponseModel({
    this.success,
    this.count,
    this.data,
  });

  factory PaymentHistoryResponseModel.fromJson(
      Map<String, dynamic> json) {
    return PaymentHistoryResponseModel(
      success: json['success'] as bool?,
      count: json['count'] as int?,
      data: (json['data'] as List?)
          ?.map((e) => PaymentHistoryData.fromJson(e))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'success': success,
      'count': count,
      'data': data?.map((e) => e.toJson()).toList(),
    };
  }
}

class PaymentHistoryData {
  final String? id;
  final String? member;
  final String? owner;
  final String? gym;
  final PaymentPlan? plan;
  final String? receiptNumber;
  final int? amount;
  final String? paymentMode;
  final String? transactionId;
  final String? paymentType;
  final DateTime? startDate;
  final DateTime? endDate;
  final String? notes;
  final DateTime? paidDate;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final int? v;

  PaymentHistoryData({
    this.id,
    this.member,
    this.owner,
    this.gym,
    this.plan,
    this.receiptNumber,
    this.amount,
    this.paymentMode,
    this.transactionId,
    this.paymentType,
    this.startDate,
    this.endDate,
    this.notes,
    this.paidDate,
    this.createdAt,
    this.updatedAt,
    this.v,
  });

  factory PaymentHistoryData.fromJson(
      Map<String, dynamic> json) {
    return PaymentHistoryData(
      id: json['_id'] as String?,
      member: json['member'] as String?,
      owner: json['owner'] as String?,
      gym: json['gym'] as String?,
      plan: json['plan'] != null
          ? PaymentPlan.fromJson(json['plan'])
          : null,
      receiptNumber: json['receiptNumber'] as String?,
      amount: json['amount'] as int?,
      paymentMode: json['paymentMode'] as String?,
      transactionId: json['transactionId'] as String?,
      paymentType: json['paymentType'] as String?,
      startDate: json['startDate'] != null
          ? DateTime.tryParse(json['startDate'])
          : null,
      endDate: json['endDate'] != null
          ? DateTime.tryParse(json['endDate'])
          : null,
      notes: json['notes'] as String?,
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
      'member': member,
      'owner': owner,
      'gym': gym,
      'plan': plan?.toJson(),
      'receiptNumber': receiptNumber,
      'amount': amount,
      'paymentMode': paymentMode,
      'transactionId': transactionId,
      'paymentType': paymentType,
      'startDate': startDate?.toIso8601String(),
      'endDate': endDate?.toIso8601String(),
      'notes': notes,
      'paidDate': paidDate?.toIso8601String(),
      'createdAt': createdAt?.toIso8601String(),
      'updatedAt': updatedAt?.toIso8601String(),
      '__v': v,
    };
  }
}

class PaymentPlan {
  final String? id;
  final String? planName;
  final int? durationInMonths;
  final int? price;

  PaymentPlan({
    this.id,
    this.planName,
    this.durationInMonths,
    this.price,
  });

  factory PaymentPlan.fromJson(
      Map<String, dynamic> json) {
    return PaymentPlan(
      id: json['_id'] as String?,
      planName: json['planName'] as String?,
      durationInMonths: json['durationInMonths'] as int?,
      price: json['price'] as int?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'planName': planName,
      'durationInMonths': durationInMonths,
      'price': price,
    };
  }
}
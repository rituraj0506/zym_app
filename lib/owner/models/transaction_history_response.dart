class TransactionHistory {
  final bool? success;
  final TransactionPagination? pagination;
  final List<TransactionData>? data;

  TransactionHistory({
    this.success,
    this.pagination,
    this.data,
  });

  factory TransactionHistory.fromJson(Map<String, dynamic> json) {
    return TransactionHistory(
      success: json['success'] as bool?,
      pagination: json['pagination'] != null
          ? TransactionPagination.fromJson(
        json['pagination'] as Map<String, dynamic>,
      )
          : null,
      data: (json['data'] as List<dynamic>?)
          ?.map(
            (e) => TransactionData.fromJson(
          e as Map<String, dynamic>,
        ),
      )
          .toList() ??
          [],
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

class TransactionPagination {
  final int? totalPayments;
  final int? currentPage;
  final int? totalPages;

  TransactionPagination({
    this.totalPayments,
    this.currentPage,
    this.totalPages,
  });

  factory TransactionPagination.fromJson(
      Map<String, dynamic> json,
      ) {
    return TransactionPagination(
      totalPayments: json['totalPayments'] as int?,
      currentPage: json['currentPage'] as int?,
      totalPages: json['totalPages'] as int?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'totalPayments': totalPayments,
      'currentPage': currentPage,
      'totalPages': totalPages,
    };
  }
}

class TransactionData {
  final String? id;
  final TransactionMember? member;
  final String? owner;
  final String? gym;
  final TransactionPlan? plan;
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

  TransactionData({
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

  factory TransactionData.fromJson(
      Map<String, dynamic> json,
      ) {
    return TransactionData(
      id: json['_id'] as String?,
      member: json['member'] != null
          ? TransactionMember.fromJson(
        json['member'] as Map<String, dynamic>,
      )
          : null,
      owner: json['owner'] as String?,
      gym: json['gym'] as String?,
      plan: json['plan'] != null
          ? TransactionPlan.fromJson(
        json['plan'] as Map<String, dynamic>,
      )
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
      'member': member?.toJson(),
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

class TransactionMember {
  final String? id;
  final String? name;
  final String? mobNo;

  TransactionMember({
    this.id,
    this.name,
    this.mobNo,
  });

  factory TransactionMember.fromJson(
      Map<String, dynamic> json,
      ) {
    return TransactionMember(
      id: json['_id'] as String?,
      name: json['name'] as String?,
      mobNo: json['mobNo'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'name': name,
      'mobNo': mobNo,
    };
  }
}

class TransactionPlan {
  final String? id;
  final String? planName;

  TransactionPlan({
    this.id,
    this.planName,
  });

  factory TransactionPlan.fromJson(
      Map<String, dynamic> json,
      ) {
    return TransactionPlan(
      id: json['_id'] as String?,
      planName: json['planName'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'planName': planName,
    };
  }
}
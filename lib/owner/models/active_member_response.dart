import 'member_response.dart';
export 'member_response.dart' show MemberData, UserModel, PlanModel;

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

typedef User = UserModel;
typedef Plan = PlanModel;
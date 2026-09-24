import 'member_response.dart';
export 'member_response.dart' show MemberData, UserModel, PlanModel;

class SearchMemberResponse {
  final bool? success;
  final int? totalMembers;
  final List<MemberData>? data;

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
          : List<MemberData>.from(
        json["data"].map(
              (x) => MemberData.fromJson(x),
        ),
      ),
    );
  }
}

typedef SearchMember = MemberData;
class TodayCollectionResponse {
  final bool? success;
  final int? totalCollection;

  TodayCollectionResponse({
    this.success,
    this.totalCollection,
  });

  factory TodayCollectionResponse.fromJson(
      Map<String, dynamic> json,
      ) {
    return TodayCollectionResponse(
      success: json['success'] as bool?,
      totalCollection: json['totalCollection'] as int?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'success': success,
      'totalCollection': totalCollection,
    };
  }
}
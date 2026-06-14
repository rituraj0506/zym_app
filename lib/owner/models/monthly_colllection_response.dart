class MonthlyCollection {
  final bool? success;
  final int? totalCollection;

  MonthlyCollection({
    this.success,
    this.totalCollection,
  });

  factory MonthlyCollection.fromJson(
      Map<String, dynamic> json,
      ) {
    return MonthlyCollection(
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
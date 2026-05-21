import '../../../../models/member_response.dart';

abstract class MemberState {
  const MemberState();
}

/// INITIAL
class MemberInitial extends MemberState {
  const MemberInitial();
}

/// GET MEMBERS
class MemberLoading extends MemberState {
  const MemberLoading();
}

class MemberLoaded extends MemberState {
  final List<MemberData> members;

  final bool hasNextPage;

  final int currentPage;

  final bool isLoadingMore;

  const MemberLoaded({
    required this.members,
    required this.hasNextPage,
    required this.currentPage,
    this.isLoadingMore = false,
  });

  MemberLoaded copyWith({
    List<MemberData>? members,
    bool? hasNextPage,
    int? currentPage,
    bool? isLoadingMore,
  }) {
    return MemberLoaded(
      members: members ?? this.members,
      hasNextPage: hasNextPage ?? this.hasNextPage,
      currentPage: currentPage ?? this.currentPage,
      isLoadingMore: isLoadingMore ?? this.isLoadingMore,
    );
  }
}

/// ADD MEMBER LOADING
class AddMemberLoading extends MemberState {
  const AddMemberLoading();
}

/// ADD MEMBER SUCCESS
class AddMemberSuccess extends MemberState {
  final String message;

  const AddMemberSuccess(this.message);
}

/// ERROR
class MemberError extends MemberState {
  final String message;

  const MemberError(this.message);
}
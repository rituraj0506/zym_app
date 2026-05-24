import '../../../../../owner/models/inactive_member_response.dart';

abstract class InActiveMemberState {
  const InActiveMemberState();
}

/// INITIAL
class InActiveMemberInitial
    extends InActiveMemberState {
  const InActiveMemberInitial();
}

/// FIRST LOADING
class InActiveMemberLoading
    extends InActiveMemberState {
  const InActiveMemberLoading();
}

/// PAGINATION LOADING
class InActiveMemberPaginationLoading
    extends InActiveMemberState {

  final List<MemberData> members;

  const InActiveMemberPaginationLoading(
      this.members,
      );
}

/// SUCCESS
class InActiveMemberLoaded
    extends InActiveMemberState {

  final List<MemberData> members;

  final bool hasMore;

  final int inactiveAfterDays;

  const InActiveMemberLoaded({
    required this.members,
    required this.hasMore,
    required this.inactiveAfterDays,
  });
}

/// ERROR
class InActiveMemberError
    extends InActiveMemberState {

  final String message;

  const InActiveMemberError(
      this.message,
      );
}
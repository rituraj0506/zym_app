import '../../../../../owner/models/active_member_response.dart';

abstract class ActiveMemberState {
  const ActiveMemberState();
}

/// INITIAL
class ActiveMemberInitial
    extends ActiveMemberState {
  const ActiveMemberInitial();
}

/// FIRST LOADING
class ActiveMemberLoading
    extends ActiveMemberState {
  const ActiveMemberLoading();
}

/// PAGINATION LOADING
class ActiveMemberPaginationLoading
    extends ActiveMemberState {

  final List<MemberData> members;

  const ActiveMemberPaginationLoading(
      this.members,
      );
}

/// SUCCESS
class ActiveMemberLoaded
    extends ActiveMemberState {

  final List<MemberData> members;

  final bool hasMore;

  const ActiveMemberLoaded({
    required this.members,
    required this.hasMore,
  });
}

/// ERROR
class ActiveMemberError
    extends ActiveMemberState {

  final String message;

  const ActiveMemberError(
      this.message,
      );
}
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../api_serves/active_member_api_service.dart';
import '../../../../../owner/models/inactive_member_response.dart';

import 'inactive_member_state.dart';

class InActiveMemberCubit
    extends Cubit<InActiveMemberState> {

  InActiveMemberCubit()
      : super(
    const InActiveMemberInitial(),
  );

  int _page = 1;

  bool _hasMore = true;

  bool _isFetching = false;

  final List<MemberData> _members = [];

  List<MemberData> get members =>
      _members;

  Future<void> getINActiveMembers({
    bool isRefresh = false,
  }) async {

    try {

      /// PREVENT MULTIPLE API CALLS
      if (_isFetching) return;

      /// REFRESH
      if (isRefresh) {

        _page = 1;

        _hasMore = true;

        _members.clear();
      }

      /// STOP IF NO MORE DATA
      if (!_hasMore) return;

      _isFetching = true;

      /// FIRST LOADING
      if (_page == 1) {

        emit(
          const InActiveMemberLoading(),
        );
      }

      /// PAGINATION LOADING
      else {

        emit(
          InActiveMemberPaginationLoading(
            List.from(_members),
          ),
        );
      }

      final response =
      await ActiveMemberApiService
          .getAllINActiveMembers(
        page: _page,
      );

      final newMembers =
          response.data ?? [];

      /// SAFE ADD (NO DUPLICATES)
      for (final member
      in newMembers) {

        final alreadyExists =
        _members.any(
              (e) =>
          e.id == member.id,
        );

        if (!alreadyExists) {

          _members.add(member);
        }
      }

      _hasMore =
          response.pagination
              ?.hasNextPage ??
              false;

      emit(
        InActiveMemberLoaded(

          members: List.from(
            _members,
          ),

          hasMore: _hasMore,

          inactiveAfterDays:
          response
              .inactiveAfterDays ??
              0,
        ),
      );

      /// NEXT PAGE
      if (_hasMore) {

        _page++;
      }

    } catch (e) {

      emit(
        InActiveMemberError(
          e.toString(),
        ),
      );

    } finally {

      _isFetching = false;
    }
  }
}
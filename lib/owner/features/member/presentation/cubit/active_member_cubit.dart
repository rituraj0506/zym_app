import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../api_serves/active_member_api_service.dart';
import '../../../../../owner/models/active_member_response.dart';

import 'active_member_state.dart';

class ActiveMemberCubit
    extends Cubit<ActiveMemberState> {

  ActiveMemberCubit()
      : super(
    const ActiveMemberInitial(),
  );

  int _page = 1;

  bool _hasMore = true;

  bool _isFetching = false;

  final List<MemberData> _members = [];

  List<MemberData> get members =>
      _members;

  Future<void> getActiveMembers({
    bool isRefresh = false,
  }) async {

    try {

      /// PREVENT MULTIPLE CALLS
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

      /// FIRST PAGE LOADING
      if (_page == 1) {

        emit(
          const ActiveMemberLoading(),
        );
      }

      /// PAGINATION LOADING
      else {

        emit(
          ActiveMemberPaginationLoading(
            List.from(_members),
          ),
        );
      }

      final response =
      await ActiveMemberApiService
          .getAllActiveMembers(
        page: _page,
      );

      final newMembers =
          response.data ?? [];

      /// DUPLICATE SAFE ADD
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
        ActiveMemberLoaded(
          members: List.from(
            _members,
          ),
          hasMore: _hasMore,
        ),
      );

      if (_hasMore) {

        _page++;
      }

    } catch (e) {

      emit(
        ActiveMemberError(
          e.toString(),
        ),
      );

    } finally {

      _isFetching = false;
    }
  }
}
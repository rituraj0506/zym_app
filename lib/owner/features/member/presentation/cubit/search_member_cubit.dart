import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../../api_serves/search_member_api_service.dart';
import 'search_member_state.dart';

class SearchMemberCubit
    extends Cubit<SearchMemberState> {

  SearchMemberCubit()
      : super(
    SearchMemberInitial(),
  );

  Future<void> searchMembers({
    required String keyword,
  }) async {

    try {

      if (keyword.trim().isEmpty) {

        emit(
          SearchMemberInitial(),
        );

        return;
      }

      emit(
        SearchMemberLoading(),
      );

      final response =
      await SearchMemberApiService
          .searchMembers(
        keyword,
      );

      emit(
        SearchMemberLoaded(
          response,
        ),
      );

    } catch (e) {

      emit(
        SearchMemberError(
          e.toString(),
        ),
      );
    }
  }

}
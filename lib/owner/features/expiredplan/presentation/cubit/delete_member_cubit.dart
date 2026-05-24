import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../api_serves/delete_member_api_services.dart';
import 'delete_member_state.dart';


class DeleteMemberCubit
    extends Cubit<DeleteMemberState> {

  DeleteMemberCubit()
      : super(
    const DeleteMemberInitial(),
  );

  Future<void> deleteMember({

    required String memberId,

  }) async {

    emit(
      const DeleteMemberLoading(),
    );

    try {

      final message =
      await DeleteMemberApiServices
          .deleteMember(

        memberId: memberId,
      );

      emit(
        DeleteMemberSuccess(
          message,
        ),
      );

    } catch (e) {

      emit(
        DeleteMemberError(
          e.toString(),
        ),
      );
    }
  }
}
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:zymmanagement/api_serves/renew_member_api_services.dart';

import 'renew_member_state.dart';

class RenewMemberCubit
    extends Cubit<RenewMemberState> {

  RenewMemberCubit()
      : super(
    RenewMemberInitial(),
  );

  Future<void> renewMember({

    required String memberId,
    required String planId,

  }) async {

    emit(
      RenewMemberLoading(),
    );

    try {

      final message =
      await RenewMemberApiServices
          .renewMember(

        memberId: memberId,
        planId: planId,
      );

      emit(
        RenewMemberSuccess(
          message,
        ),
      );

    } catch (e) {

      emit(
        RenewMemberError(
          e.toString(),
        ),
      );
    }
  }
}
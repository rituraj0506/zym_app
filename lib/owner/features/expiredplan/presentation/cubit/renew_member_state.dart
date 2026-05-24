abstract class RenewMemberState {}

class RenewMemberInitial
    extends RenewMemberState {}

class RenewMemberLoading
    extends RenewMemberState {}

class RenewMemberSuccess
    extends RenewMemberState {

  final String message;

  RenewMemberSuccess(
      this.message,
      );
}

class RenewMemberError
    extends RenewMemberState {

  final String message;

  RenewMemberError(
      this.message,
      );
}
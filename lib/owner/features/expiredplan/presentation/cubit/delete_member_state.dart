abstract class DeleteMemberState {
  const DeleteMemberState();
}

class DeleteMemberInitial
    extends DeleteMemberState {

  const DeleteMemberInitial();
}

class DeleteMemberLoading
    extends DeleteMemberState {

  const DeleteMemberLoading();
}

class DeleteMemberSuccess
    extends DeleteMemberState {

  final String message;

  const DeleteMemberSuccess(
      this.message,
      );
}

class DeleteMemberError
    extends DeleteMemberState {

  final String message;

  const DeleteMemberError(
      this.message,
      );
}

abstract class ExpiredPlanState {
  const ExpiredPlanState();
}

class ExpiredPlanInitial
    extends ExpiredPlanState {

  const ExpiredPlanInitial();
}

class ExpiredPlanLoading
    extends ExpiredPlanState {

  const ExpiredPlanLoading();
}

class ExpiredPlanLoaded
    extends ExpiredPlanState {

  const ExpiredPlanLoaded();
}

class ExpiredPlanError
    extends ExpiredPlanState {

  final String message;

  const ExpiredPlanError(
      this.message,
      );
}
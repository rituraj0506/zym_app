import '../../../../models/gym_plan_response.dart';

abstract class PlanState {}

class PlanInitial extends PlanState {}

/// CREATE PLAN

class PlanCreateLoading extends PlanState {}

class PlanCreateSuccess extends PlanState {

  final String message;

  PlanCreateSuccess(this.message);
}

class PlanCreateError extends PlanState {

  final String message;

  PlanCreateError(this.message);
}

/// GET PLAN DETAILS

class PlanDetailsLoading extends PlanState {}

class PlanDetailsLoaded extends PlanState {

  final GymPlansResponse plans;

  PlanDetailsLoaded(this.plans);
}

class PlanDetailsError extends PlanState {

  final String message;

  PlanDetailsError(this.message);
}
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../../api_serves/plan_api_services.dart';
import 'plan_state.dart';

class PlanCubit extends Cubit<PlanState> {

  PlanCubit() : super(PlanInitial());

  /// =========================
  /// CREATE PLAN
  /// =========================

  Future<void> createPlan({
    required String planName,
    required int durationInMonths,
    required int price,
    required String description,
  }) async {

    emit(PlanCreateLoading());

    try {

      final message =
      await PlanApiServices.createPlan(
        planName: planName,
        durationInMonths: durationInMonths,
        price: price,
        description: description,
      );

      emit(
        PlanCreateSuccess(message),
      );

    } catch (e) {

      emit(
        PlanCreateError(
          e.toString(),
        ),
      );
    }
  }

  /// =========================
  /// GET ALL PLANS
  /// =========================

  Future<void> getAllPlans() async {

    emit(PlanDetailsLoading());

    try {

      final plans =
      await PlanApiServices.gymProfileData();

      emit(
        PlanDetailsLoaded(plans),
      );

    } catch (e) {

      emit(
        PlanDetailsError(
          e.toString(),
        ),
      );
    }
  }

  /// =========================
  /// UPDATE PLAN
  /// =========================

  Future<void> updatePlan({
    required String id,
    required String planName,
    required int durationInMonths,
    required int price,
    required String description,
  }) async {

    emit(PlanUpdateLoading());

    try {

      final message =
      await PlanApiServices.updatePlan(
        id: id,
        planName: planName,
        durationInMonths:
        durationInMonths,
        price: price,
        description: description,
      );

      emit(
        PlanUpdateSuccess(message),
      );

    } catch (e) {

      emit(
        PlanUpdateError(
          e.toString(),
        ),
      );
    }
  }

  /// =========================
  /// DISABLE PLAN
  /// =========================

  Future<void> disablePlan({
    required String id,
  }) async {

    emit(PlanDisableLoading());

    try {

      final message =
      await PlanApiServices.disablePlan(
        id: id,
      );

      emit(
        PlanDisableSuccess(message),
      );

      await getAllPlans();

    } catch (e) {

      emit(
        PlanDisableError(
          e.toString(),
        ),
      );
    }
  }
}
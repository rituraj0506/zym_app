import 'dart:convert';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../../api_serves/expiredplan_api_service.dart';
import '../../../../models/expiredplan_response.dart';
import '../../../../models/expiringsoonplan_response.dart';
import 'expired_plan_state.dart';

class ExpiredPlanCubit
    extends Cubit<ExpiredPlanState> {

  ExpiredPlanCubit()
      : super(
    const ExpiredPlanInitial(),
  );

  ExpiredPlan? expiredPlan;

  ExpiringSoonPlan? expiringSoonPlan;

  /// PAGINATION VARIABLES
  int expiredPage = 1;

  int expiringSoonPage = 1;

  final int limit = 10;

  bool isExpiredLoadingMore = false;

  bool isExpiringLoadingMore = false;

  /// FETCH INITIAL DATA
  Future<void> fetchAll() async {

    try {

      emit(
        const ExpiredPlanLoading(),
      );

      /// LOAD CACHE FIRST
      await loadCache(
        showState: false,
      );

      expiredPage = 1;

      expiringSoonPage = 1;

      /// PARALLEL API CALL
      final results = await Future.wait([
        ExpiredPlanApiService.planExpired(
          page: expiredPage,
          limit: limit,
        ),
        ExpiredPlanApiService
            .planExpiringSoon(
          page: expiringSoonPage,
          limit: limit,
        ),
      ]);

      expiredPlan =
      results[0] as ExpiredPlan;

      expiringSoonPlan =
      results[1]
      as ExpiringSoonPlan;

      /// SAVE CACHE
      await Future.wait([
        saveExpiredCache(),
        saveExpiringSoonCache(),
      ]);

      emit(
        const ExpiredPlanLoaded(),
      );

    } catch (e) {

      /// SHOW OLD CACHE IF EXISTS
      if (expiredPlan != null ||
          expiringSoonPlan != null) {

        emit(
          const ExpiredPlanLoaded(),
        );

      } else {

        emit(
          ExpiredPlanError(
            e.toString(),
          ),
        );
      }
    }
  }

  /// LOAD MORE EXPIRED MEMBERS
  Future<void> loadMoreExpired() async {

    if (isExpiredLoadingMore) return;

    final hasNextPage =
        expiredPlan
            ?.pagination
            ?.hasNextPage ??
            false;

    if (!hasNextPage) return;

    try {

      isExpiredLoadingMore = true;

      expiredPage++;

      final response =
      await ExpiredPlanApiService
          .planExpired(
        page: expiredPage,
        limit: limit,
      );

      final oldList =
          expiredPlan?.data ?? [];

      final newList =
          response.data ?? [];

      expiredPlan = ExpiredPlan(
        success: response.success,
        pagination: response.pagination,
        data: [
          ...oldList,
          ...newList,
        ],
      );

      await saveExpiredCache();

      emit(
        const ExpiredPlanLoaded(),
      );

    } catch (_) {

      expiredPage--;

    } finally {

      isExpiredLoadingMore = false;
    }
  }

  /// LOAD MORE EXPIRING SOON MEMBERS
  Future<void>
  loadMoreExpiringSoon() async {

    if (isExpiringLoadingMore) return;

    final hasNextPage =
        expiringSoonPlan
            ?.pagination
            ?.hasNextPage ??
            false;

    if (!hasNextPage) return;

    try {

      isExpiringLoadingMore = true;

      expiringSoonPage++;

      final response =
      await ExpiredPlanApiService
          .planExpiringSoon(
        page: expiringSoonPage,
        limit: limit,
      );

      final oldList =
          expiringSoonPlan?.data ?? [];

      final newList =
          response.data ?? [];

      expiringSoonPlan =
          ExpiringSoonPlan(
            success: response.success,
            pagination:
            response.pagination,
            data: [
              ...oldList,
              ...newList,
            ],
          );

      await saveExpiringSoonCache();

      emit(
        const ExpiredPlanLoaded(),
      );

    } catch (_) {

      expiringSoonPage--;

    } finally {

      isExpiringLoadingMore = false;
    }
  }

  /// SAVE EXPIRED CACHE
  Future<void>
  saveExpiredCache() async {

    final prefs =
    await SharedPreferences
        .getInstance();

    if (expiredPlan != null) {

      await prefs.setString(
        "expired_plan_cache",
        jsonEncode(
          expiredPlan!.toJson(),
        ),
      );
    }
  }

  /// SAVE EXPIRING SOON CACHE
  Future<void>
  saveExpiringSoonCache() async {

    final prefs =
    await SharedPreferences
        .getInstance();

    if (expiringSoonPlan != null) {

      await prefs.setString(
        "expiring_soon_cache",
        jsonEncode(
          expiringSoonPlan!.toJson(),
        ),
      );
    }
  }

  /// LOAD CACHE
  Future<void> loadCache({
    bool showState = true,
  }) async {

    try {

      final prefs =
      await SharedPreferences
          .getInstance();

      /// EXPIRED CACHE
      final expiredCache =
      prefs.getString(
        "expired_plan_cache",
      );

      if (expiredCache != null) {

        expiredPlan =
            ExpiredPlan.fromJson(
              jsonDecode(
                expiredCache,
              ),
            );
      }

      /// EXPIRING SOON CACHE
      final expiringSoonCache =
      prefs.getString(
        "expiring_soon_cache",
      );

      if (expiringSoonCache != null) {

        expiringSoonPlan =
            ExpiringSoonPlan
                .fromJson(
              jsonDecode(
                expiringSoonCache,
              ),
            );
      }

      if (showState) {

        emit(
          const ExpiredPlanLoaded(),
        );
      }

    } catch (_) {}
  }

  /// REFRESH
  Future<void> refresh() async {

    expiredPage = 1;

    expiringSoonPage = 1;

    await fetchAll();
  }


  void clearMemberShip() {
    emit(ExpiredPlanInitial());
  }


}
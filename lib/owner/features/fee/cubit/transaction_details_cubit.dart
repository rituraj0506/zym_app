import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../api_serves/transaction_details_api_service.dart';
import '../../../models/monthly_colllection_response.dart';
import '../../../models/today_collection_response.dart';
import '../../../models/transaction_history_response.dart';
import 'transaction_details_state.dart';

class TransactionDetailsCubit
    extends Cubit<TransactionState> {
  TransactionDetailsCubit()
      : super(TransactionInitial());

  final List<TransactionData> transactions = [];

  TodayCollectionResponse? todayCollection;
  MonthlyCollection? monthlyCollection;

  int currentPage = 1;
  int totalPages = 1;

  bool isLoadingMore = false;
  bool hasMore = true;

  Future<void> fetchTransactionDetails({
    bool forceRefresh = false,
  }) async {
    if (!forceRefresh &&
        transactions.isNotEmpty &&
        todayCollection != null &&
        monthlyCollection != null) {
      emit(
        TransactionLoaded(
          transactionHistory: TransactionHistory(
            data: transactions,
          ),
          todayCollection: todayCollection!,
          monthlyCollection: monthlyCollection!,
        ),
      );
      return;
    }

    emit(TransactionLoading());

    try {
      final results = await Future.wait([
        TransactionDetailsApiService.transactionData(
          page: 1,
        ),
        TransactionDetailsApiService.todayCollection(),
        TransactionDetailsApiService.monthlyCollection(),
      ]);

      final transactionHistory =
      results[0] as TransactionHistory;

      final today =
      results[1] as TodayCollectionResponse;

      final monthly =
      results[2] as MonthlyCollection;

      transactions.clear();

      transactions.addAll(
        transactionHistory.data ?? [],
      );

      currentPage =
          transactionHistory.pagination?.currentPage ??
              1;

      totalPages =
          transactionHistory.pagination?.totalPages ??
              1;

      hasMore = currentPage < totalPages;

      todayCollection = today;
      monthlyCollection = monthly;

      emit(
        TransactionLoaded(
          transactionHistory: transactionHistory,
          todayCollection: today,
          monthlyCollection: monthly,
        ),
      );
    } catch (e) {
      emit(
        TransactionError(
          e.toString(),
        ),
      );
    }
  }

  Future<void> loadMore() async {
    if (isLoadingMore || !hasMore) return;

    isLoadingMore = true;

    try {
      final response =
      await TransactionDetailsApiService
          .transactionData(
        page: currentPage + 1,
      );

      transactions.addAll(
        response.data ?? [],
      );

      currentPage =
          response.pagination?.currentPage ??
              currentPage;

      totalPages =
          response.pagination?.totalPages ??
              totalPages;

      hasMore = currentPage < totalPages;

      if (todayCollection != null &&
          monthlyCollection != null) {
        emit(
          TransactionLoaded(
            transactionHistory:
            TransactionHistory(
              success: true,
              pagination:
              response.pagination,
              data: transactions,
            ),
            todayCollection:
            todayCollection!,
            monthlyCollection:
            monthlyCollection!,
          ),
        );
      }
    } catch (_) {}

    isLoadingMore = false;
  }

  Future<void> refresh() async {
    await fetchTransactionDetails(
      forceRefresh: true,
    );
  }

  void clearTransaction() {
    emit(TransactionInitial());
  }

}
import '../../../models/monthly_colllection_response.dart';
import '../../../models/today_collection_response.dart';
import '../../../models/transaction_history_response.dart';

abstract class TransactionState {}

class TransactionInitial extends TransactionState {}

class TransactionLoading extends TransactionState {}

class TransactionLoaded extends TransactionState {
  final TransactionHistory transactionHistory;
  final TodayCollectionResponse todayCollection;
  final MonthlyCollection monthlyCollection;

  TransactionLoaded({
    required this.transactionHistory,
    required this.todayCollection,
    required this.monthlyCollection,
  });
}

class TransactionError extends TransactionState {
  final String message;

  TransactionError(this.message);
}
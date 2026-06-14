import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../api_serves/fee_details_api_service.dart';
import 'member_fee_state.dart';


class MemberFeeCubit extends Cubit<MemberFeeState> {

  MemberFeeCubit()
      : super(MemberFeeInitial());

  Future<void> getPaymentHistory(
      String memberId) async {

    try {

      emit(MemberFeeLoading());

      final response =
      await FeeDetailsApiService
          .memberPaymentHistory(memberId);

      emit(
        MemberPaymentHistoryLoaded(
          response,
        ),
      );

    } catch (e) {

      emit(
        MemberFeeError(
          e.toString(),
        ),
      );
    }
  }

  Future<void> getPaymentReceipt(
      String paymentId) async {

    try {

      emit(MemberFeeLoading());

      final response =
      await FeeDetailsApiService
          .memberPaymentReceipt(paymentId);

      emit(
        MemberPaymentReceiptLoaded(
          response,
        ),
      );

    } catch (e) {

      emit(
        MemberFeeError(
          e.toString(),
        ),
      );
    }
  }


  Future<void> downloadLatestReceiptPdf(
      String memberId) async {

    try {

      emit(MemberFeeLoading());

      final history =
      await FeeDetailsApiService
          .memberPaymentHistory(memberId);

      if (history.data == null ||
          history.data!.isEmpty) {

        emit(
          MemberFeeError(
            "No payment history found",
          ),
        );

        return;
      }

      final paymentId =
          history.data!.first.id ?? "";

      final pdfBytes =
      await FeeDetailsApiService
          .memberPaymentReceiptPdf(
          paymentId);

      emit(
        PdfDownloadedState(
          pdfBytes,
        ),
      );

    } catch (e) {

      emit(
        MemberFeeError(
          e.toString(),
        ),
      );
    }
  }

}
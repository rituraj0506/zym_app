import '../../../models/member_payment_history.dart';
import '../../../models/member_payment_recipt.dart';

abstract class MemberFeeState {}

class MemberFeeInitial
    extends MemberFeeState {}

class MemberFeeLoading
    extends MemberFeeState {}

class MemberPaymentHistoryLoaded
    extends MemberFeeState {

  final PaymentHistoryResponseModel data;

  MemberPaymentHistoryLoaded(
      this.data);
}

class MemberPaymentReceiptLoaded
    extends MemberFeeState {

  final PaymentReceiptResponseModel data;

  MemberPaymentReceiptLoaded(
      this.data);
}


class PdfDownloadedState
    extends MemberFeeState {

  final List<int> pdfBytes;

  PdfDownloadedState(
      this.pdfBytes,
      );
}


class MemberFeeError
    extends MemberFeeState {

  final String message;

  MemberFeeError(
      this.message);
}
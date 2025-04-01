import 'package:base_project/src/modules/payments/domain/entity/detail_row_entity.dart';
import 'package:base_project/src/modules/payments/domain/domain.dart';
import '../../../../../core/utils/payments_formatter.dart' show PaymentsFormatter;

class DetailRowBuilder {
  final List<String> activeFilters;

  const DetailRowBuilder(this.activeFilters);

  List<DetailRowData> buildRows(PaymentsTransactionsEntity transaction) {
    List<DetailRowData> rows = [];

    _addProcessDateAndAmountRow(transaction, rows);
    _addTypeAndPrincipalRow(transaction, rows);
    _addLateFeeAndInterestRow(transaction, rows);
    _addBalanceAndPostDateRow(transaction, rows);

    return rows;
  }

  void _addProcessDateAndAmountRow(
      PaymentsTransactionsEntity transaction, List<DetailRowData> rows) {
    final showProcessDate = activeFilters.contains("processDate");
    final showAmount = activeFilters.contains("actualPaymentAmount");
    
    if (showProcessDate || showAmount) {
      rows.add(DetailRowData(
        leftLabel: showProcessDate ? 'Process date' : '',
        leftValue: showProcessDate 
            ? PaymentsFormatter.formatDate(transaction.processDate) 
            : '',
        rightLabel: showAmount ? 'Amount' : '',
        rightValue: showAmount 
            ? PaymentsFormatter.formatCurrency(transaction.actualPaymentAmount) 
            : '',
      ));
    }
  }

  void _addTypeAndPrincipalRow(
      PaymentsTransactionsEntity transaction, List<DetailRowData> rows) {
    final showType = activeFilters.contains("type");
    final showPrincipal = activeFilters.contains("actualPrincipalPaymentAmount");
    
    if (showType || showPrincipal) {
      rows.add(DetailRowData(
        leftLabel: showType ? 'Type' : '',
        leftValue: showType ? transaction.paymentType : '',
        rightLabel: showPrincipal ? 'Principal' : '',
        rightValue: showPrincipal 
            ? PaymentsFormatter.formatCurrency(transaction.actualPrincipalPaymentAmount) 
            : '',
      ));
    }
  }

  void _addLateFeeAndInterestRow(
      PaymentsTransactionsEntity transaction, List<DetailRowData> rows) {
    final showLateFee = activeFilters.contains("actualFee");
    final showInterest = activeFilters.contains("actualInterestPaymentAmount");
    
    if (showLateFee || showInterest) {
      rows.add(DetailRowData(
        leftLabel: showLateFee ? 'Late Fee' : '',
        leftValue: showLateFee 
            ? (transaction.actualFee > 0 
                ? PaymentsFormatter.formatCurrency(transaction.actualFee) 
                : '--') 
            : '',
        rightLabel: showInterest ? 'Interest' : '',
        rightValue: showInterest 
            ? PaymentsFormatter.formatCurrency(transaction.actualInterestPaymentAmount) 
            : '',
      ));
    }
  }

  void _addBalanceAndPostDateRow(
      PaymentsTransactionsEntity transaction, List<DetailRowData> rows) {
    final showPrincipalBalance = activeFilters.contains("outstandingPrincipalBalance");
    final showPostDate = activeFilters.contains("actualPaymentPostDate");
    
    if (showPrincipalBalance || showPostDate) {
      rows.add(DetailRowData(
        leftLabel: showPrincipalBalance ? 'Principal Balance' : '',
        leftValue: showPrincipalBalance 
            ? PaymentsFormatter.formatCurrency(transaction.outstandingPrincipalBalance) 
            : '',
        rightLabel: showPostDate ? 'Post date' : '',
        rightValue: showPostDate 
            ? PaymentsFormatter.formatDate(transaction.actualPaymentPostDate) 
            : '',
      ));
    }
  }
}

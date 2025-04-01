import 'package:flutter/material.dart';
import 'package:base_project/src/modules/payments/domain/domain.dart';
import 'transactions_detail_card_component.dart';


class TransactionListWidget extends StatelessWidget {
  final List<PaymentsTransactionsEntity> transactions;

  const TransactionListWidget({
    super.key,
    required this.transactions,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: transactions.map(
        (transaction) => Padding(
          padding: const EdgeInsets.only(bottom: 12),
          child: TransactionDetailCardComponent(
            transaction: transaction,
          ),
        ),
      ).toList(),
    );
  }
}
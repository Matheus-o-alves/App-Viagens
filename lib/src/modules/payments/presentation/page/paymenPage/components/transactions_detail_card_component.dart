import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../../core/core.dart';
import '../../../../domain/domain.dart';
import '../../../../domain/entity/detail_row_entity.dart';
import '../../presentation.dart';


class TransactionDetailCardComponent extends StatelessWidget {
  final PaymentsTransactionsEntity transaction;

  const TransactionDetailCardComponent({super.key, required this.transaction});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PaymentsBloc, PaymentsState>(
      builder: (context, state) {
        final rows = context.watch<PaymentsBloc>().getTransactionDetailRows(transaction);

        final children = rows.where((r) => !r.isEmpty).expand((row) => [
          _buildDetailRow(row),
          const SizedBox(height: 12),
        ]).toList();

        if (children.isNotEmpty) {
          children.removeLast();
        }

        return Container(
          padding: const EdgeInsets.all(16),
          margin: const EdgeInsets.symmetric(horizontal: 16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(8),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                spreadRadius: 2,
                blurRadius: 4,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: children,
          ),
        );
      },
    );
  }

  Widget _buildDetailRow(DetailRowData row) {
    bool hasLeftSymbol = row.leftValue.contains('R\$');
    bool hasRightSymbol = row.rightValue.contains('R\$');
    String cleanLeftValue = row.leftValue.replaceAll('R\$', '').trim();
    String cleanRightValue = row.rightValue.replaceAll('R\$', '').trim();

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: row.leftLabel.isNotEmpty
              ? Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(row.leftLabel, style: AppTextStyles.cardTitle),
                    const SizedBox(height: 4),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.baseline,
                      textBaseline: TextBaseline.alphabetic,
                      children: [
                        Text.rich(
                          TextSpan(
                            children: [
                              if (hasLeftSymbol)
                                WidgetSpan(
                                  alignment: PlaceholderAlignment.top,
                                  child: Transform.translate(
                                    offset: const Offset(0, -2),
                                    child: Text(
                                      'R\$',
                                      style: AppTextStyles.currencySymbol,
                                    ),
                                  ),
                                ),
                              TextSpan(
                                text: ' $cleanLeftValue',
                                style: AppTextStyles.amount,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                )
              : const SizedBox.shrink(),
        ),
        const SizedBox(width: 24),
        Expanded(
          child: row.rightLabel.isNotEmpty
              ? Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(row.rightLabel, style: AppTextStyles.cardTitle),
                    const SizedBox(height: 4),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.baseline,
                      textBaseline: TextBaseline.alphabetic,
                      children: [
                        Text.rich(
                          TextSpan(
                            children: [
                              if (hasRightSymbol)
                                WidgetSpan(
                                  alignment: PlaceholderAlignment.top,
                                  child: Transform.translate(
                                    offset: const Offset(0, -2),
                                    child: Text(
                                      'R\$',
                                      style: AppTextStyles.currencySymbol,
                                    ),
                                  ),
                                ),
                              TextSpan(
                                text: ' $cleanRightValue',
                                style: AppTextStyles.amount,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                )
              : const SizedBox.shrink(),
        ),
      ],
    );
  }
}

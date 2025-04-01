import 'package:flutter/material.dart';

import '../../../../domain/domain.dart';
import 'components.dart';



class FinancialCardListComponent extends StatelessWidget {
  final List<PaymentsSummaryEntity> summaryList;

  const FinancialCardListComponent({
    super.key,
    required this.summaryList,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 100,
      margin: const EdgeInsets.only(top: 16, bottom: 20),
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        shrinkWrap: true,
        itemCount: summaryList.length,
        separatorBuilder: (_, __) => const SizedBox(width: 8),
        itemBuilder: (context, index) {
          final item = summaryList[index];
          return BuildFinancialCardComponent(
            title: item.label,
            amount: item.value.toStringAsFixed(2),
          );
        },
      ),
    );
  }
}
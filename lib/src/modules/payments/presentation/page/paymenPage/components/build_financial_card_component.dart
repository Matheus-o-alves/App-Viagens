import 'package:flutter/material.dart';
import '../../../../../../core/theme/theme.dart';

class BuildFinancialCardComponent extends StatelessWidget {
  const BuildFinancialCardComponent({
    super.key,
    required this.title,
    required this.amount,
  });

  final String title;
  final String amount;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      constraints: const BoxConstraints(minWidth: 144),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: AppTextStyles.cardTitle,
          ),
          const SizedBox(height: 4),
          Row(
            crossAxisAlignment: CrossAxisAlignment.baseline,
            textBaseline: TextBaseline.alphabetic,
            children: [
              Text.rich(
                TextSpan(
                  children: [
                    WidgetSpan(
                      alignment: PlaceholderAlignment.top,
                      child: Transform.translate(
                        offset: const Offset(0, -2),
                        child: Text(
                          '\$',
                          style: AppTextStyles.currencySymbol,
                        ),
                      ),
                    ),
                    TextSpan(
                      text: ' $amount',
                      style: AppTextStyles.amount,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

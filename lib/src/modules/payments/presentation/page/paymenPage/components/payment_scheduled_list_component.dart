
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../../core/core.dart';
import '../../presentation.dart';


class PaymentScheduleDashboard extends StatelessWidget {
  const PaymentScheduleDashboard({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PaymentsBloc, PaymentsState>(
      builder: (context, state) {
        if (state.status == PaymentsStatus.loading) {
          return const Center(child: CircularProgressIndicator());
        }
        if (state.status == PaymentsStatus.error) {
          return Center(child: Text('Error: ${state.errorMessage}'));
        }
        final info = state.paymentsInfo;
        if (info == null) {
          return const Center(child: Text('No payment data available.'));
        }
        final scheduleList = info.paymentsScheduled;

        return Container(
          color: AppColors.background,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Column(
            children: [
              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: scheduleList.length,
                itemBuilder: (context, index) {
                  final paymentItem = scheduleList[index];
                  final isNext = (index == 0);
                  return _buildPaymentItem(
                    date: paymentItem.paymentDateFormatted,
                    amount: paymentItem.total.toStringAsFixed(2),
                    isNext: isNext,
                    context: context,
                  );
                },
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildPaymentItem({
    required String date,
    required String amount,
    required BuildContext context,
    bool isNext = false,
  }) {
    final screenHeight = MediaQuery.of(context).size.height;
    final cardHeight = screenHeight * 0.07;

    final amountPadding = isNext ? 40.0 : 92.0;

    return Container(
      height: cardHeight.clamp(50.0, 72.0),
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Center(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              date,
              style: AppTextStyles.primaryLabel,
            ),
            Row(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Padding(
                  padding: EdgeInsets.only(right: amountPadding),
                  child: Text.rich(
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
                          style: AppTextStyles.primaryAmount,
                        ),
                      ],
                    ),
                  ),
                ),
                if (isNext)
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                    decoration: BoxDecoration(
                      color: AppColors.tagBlue.withOpacity(0.08),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      'Next',
                      style: AppTextStyles.tag,
                    ),
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

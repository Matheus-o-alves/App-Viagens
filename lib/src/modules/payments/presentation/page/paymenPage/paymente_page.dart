
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../core/core.dart';
import '../../bloc/payments_bloc/bloc.dart';
import 'pages.dart';


class PaymentsPage extends StatelessWidget {
  const PaymentsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return Container(
          color: AppColors.background,
          width: constraints.maxWidth,
          height: constraints.maxHeight,
          child: SingleChildScrollView(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 480),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: BlocBuilder<PaymentsBloc, PaymentsState>(
                  builder: (context, state) {
                    final isPaymentsTab = state.selectedTab == PaymentsTab.payments;

                    if (state.status == PaymentsStatus.loading) {
                      return _buildLoadingState(context, isPaymentsTab);
                    }

                    final info = state.paymentsInfo;
                    if (info == null) {
                      return const Center(child: CircularProgressIndicator());
                    }

                    return _buildContent(context, state, info, isPaymentsTab);
                  },
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  
  Widget _buildLoadingState(BuildContext context, bool isPaymentsTab) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const SizedBox(height: 8),
        TabNavigationWidget(
          isPaymentsTab: isPaymentsTab,
          onFilterPressed: () => _showFilterBottomSheet(context),
        ),
        const SizedBox(height: 16),
        const ShimmerLoadingWidget(),
      ],
    );
  }

 Widget _buildContent(BuildContext context, PaymentsState state, 
    dynamic info, bool isPaymentsTab) {
  final scheduledList = info.paymentsScheduled;
  final isScheduledEmpty = scheduledList == null || scheduledList.isEmpty;
  final summaryList = info.summary;

  return Column(
    crossAxisAlignment: CrossAxisAlignment.stretch,
    children: [
      const SizedBox(height: 8),
      isPaymentsTab
          ? _buildPaymentsTabContent(
              context, isScheduledEmpty, summaryList, isPaymentsTab)
          : _buildTransactionsTabContent(
              context, info, summaryList, isPaymentsTab),
    ],
  );
}

  Widget _buildPaymentsTabContent(BuildContext context, bool isScheduledEmpty, 
      dynamic summaryList, bool isPaymentsTab) {
    if (isScheduledEmpty) {
      return Column(
        children: [
          TabNavigationWidget(
            isPaymentsTab: isPaymentsTab,
            onFilterPressed: () => _showFilterBottomSheet(context),
          ),
          const EmptyStateWidget(
            message: 'Once your loan is booked your payment schedule will appear here. '
                'This process may take 1-2 business days.',
          ),
        ],
      );
    } else {
      return Column(
        children: [
          FinancialCardListComponent(summaryList: summaryList),
          const MakePaymentComponent(),
          TabNavigationWidget(
            isPaymentsTab: isPaymentsTab,
            onFilterPressed: () => _showFilterBottomSheet(context),
          ),
          const PaymentScheduleDashboard(),
        ],
      );
    }
  }

  Widget _buildTransactionsTabContent(BuildContext context, dynamic info, 
      dynamic summaryList, bool isPaymentsTab) {
    if (info.transactions.isNotEmpty) {
      return Column(
        children: [
          FinancialCardListComponent(summaryList: summaryList),
          const MakePaymentComponent(),
          TabNavigationWidget(
            isPaymentsTab: isPaymentsTab,
            onFilterPressed: () => _showFilterBottomSheet(context),
          ),
          TransactionListWidget(transactions: info.transactions),
        ],
      );
    } else {
      return 
      
       Column(
         children: [
             TabNavigationWidget(
            isPaymentsTab: isPaymentsTab,
            onFilterPressed: () => _showFilterBottomSheet(context),
          ),
           EmptyStateWidget(
            message: 'Here you will see your latest transaction history and payment activities.',
                 ),
         ],
       );
    }
  }

  void _showFilterBottomSheet(BuildContext context) {
    final state = context.read<PaymentsBloc>().state;
    showTransactionFilterBottomSheet(
      context,
      state.paymentsInfo?.transactionFilter ?? [],
      state.activeTransactionFilterKeys,
    );
  }
}
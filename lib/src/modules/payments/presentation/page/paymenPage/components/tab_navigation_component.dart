import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../../core/core.dart';
import '../../presentation.dart';



class TabNavigationWidget extends StatelessWidget {
  final bool isPaymentsTab;
  final VoidCallback onFilterPressed;

  const TabNavigationWidget({
    super.key,
    required this.isPaymentsTab,
    required this.onFilterPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: _buildTab(
            context,
            label: 'SCHEDULE',
            isSelected: isPaymentsTab,
            tab: PaymentsTab.payments,
          ),
        ),
        Expanded(
          child: _buildTab(
            context,
            label: 'TRANSACTIONS',
            isSelected: !isPaymentsTab,
            tab: PaymentsTab.transactions,
          ),
        ),
        IconButton(
          icon: Icon(
            Icons.more_vert,
            color: AppColors.softGrey.withOpacity(0.75),
          ),
          onPressed: onFilterPressed,
        ),
      ],
    );
  }

  Widget _buildTab(BuildContext context, {
    required String label,
    required bool isSelected,
    required PaymentsTab tab,
  }) {
    return GestureDetector(
      onTap: () {
        context.read<PaymentsBloc>().add(PaymentsTabChanged(tab));
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 10),
        decoration: BoxDecoration(
          border: Border(
            bottom: BorderSide(
              color: isSelected ? AppColors.greenAccent : AppColors.greyLine,
              width: isSelected ? 2 : 1,
            ),
          ),
        ),
        child: Text(
          label,
          textAlign: TextAlign.center,
          style: isSelected ? AppTextStyles.tabSelected : AppTextStyles.tabUnselected,
        ),
      ),
    );
  }
}
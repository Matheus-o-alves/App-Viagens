import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../bloc/payments_bloc/bloc.dart';
import 'shimmers.dart';



class ShimmerLoadingWidget extends StatelessWidget {
  const ShimmerLoadingWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          height: 100,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            itemCount: 3,
            separatorBuilder: (_, __) => const SizedBox(width: 8),
            itemBuilder: (_, __) => const ShimmerFinancialCardComponent(),
          ),
        ),
        const SizedBox(height: 16),
        BlocBuilder<PaymentsBloc, PaymentsState>(
          builder: (context, state) {
            return state.selectedTab == PaymentsTab.payments 
                ? ShimmerScheduleComponent() 
                : TransactionDetailCardShimmer();
          },
        ),
      ],
    );
  }
}

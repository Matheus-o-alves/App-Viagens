import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../presentation.dart';


class TransactionsListViewComponent extends StatelessWidget {
  const TransactionsListViewComponent({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PaymentsBloc, PaymentsState>(
      builder: (context, state) {
        final transactions = context.watch<PaymentsBloc>().getFilteredTransactions();

        if (transactions.isEmpty) {
          return const Center(child: Text('Nenhuma transação encontrada.'));
        }

        return ListView.builder(
          itemCount: transactions.length,
          itemBuilder: (context, index) {
            return TransactionDetailCardComponent(transaction: transactions[index]);
          },
        );
      },
    );
  }
}

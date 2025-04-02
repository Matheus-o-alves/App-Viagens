// presentation/pages/travel_expenses_page.dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart' show NumberFormat;
import 'package:onfly_viagens_app/src/modules/presentation/bloc/homePageBloc/home_page_event.dart' show FetchTravelExpenses, RefreshTravelExpenses;
import '../../../domain/domain.dart';
import '../../bloc/homePageBloc/home_page_bloc.dart';
import '../../bloc/homePageBloc/home_page_state.dart';

import '../components/error_component.dart';

import 'components/loading_travels_component.dart';
import 'components/payment_card_component.dart';


class TravelExpensesPage extends StatelessWidget {
  const TravelExpensesPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      appBar: AppBar(
        backgroundColor: const Color(0xFF1A73E8),
        elevation: 0,
        title: const Text(
          'Travel Expenses',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.filter_list, color: Colors.white),
            onPressed: () {
              // Implement filter functionality
            },
          ),
        ],
      ),
      body: BlocBuilder<TravelExpensesBloc, TravelExpensesState>(
        builder: (context, state) {
          if (state is TravelExpensesInitial) {
            // Trigger loading when in initial state
            context.read<TravelExpensesBloc>().add(const FetchTravelExpenses());
            return const LoadingView();
          } else if (state is TravelExpensesLoading) {
            return const LoadingView();
          } else if (state is TravelExpensesLoaded) {
            return _buildLoadedContent(context, state.expenses);
          } else if (state is TravelExpensesError) {
            return ErrorView(
              message: state.message,
              onRetry: () => context.read<TravelExpensesBloc>().add(const FetchTravelExpenses()),
            );
          } else {
            return const Center(
              child: Text('Unknown state'),
            );
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: const Color(0xFF1A73E8),
        child: const Icon(Icons.add),
        onPressed: () {
          // Implement add new expense functionality
        },
      ),
    );
  }

  Widget _buildLoadedContent(BuildContext context, List<TravelExpenseEntity> expenses) {
    if (expenses.isEmpty) {
      return const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.receipt_long,
              size: 72,
              color: Color(0xFFBDBDBD),
            ),
            SizedBox(height: 16),
            Text(
              'No travel expenses found',
              style: TextStyle(
                fontSize: 18,
                color: Color(0xFF757575),
              ),
            ),
            SizedBox(height: 8),
            Text(
              'Add your first expense with the + button',
              style: TextStyle(
                color: Color(0xFFBDBDBD),
              ),
            ),
          ],
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: () async {
        context.read<TravelExpensesBloc>().add(const RefreshTravelExpenses());
      },
      child: Column(
        children: [
          // Expense summary
          _buildExpenseSummary(expenses),
          
          // Expense list
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: expenses.length,
              itemBuilder: (context, index) {
                final expense = expenses[index];
                return ExpenseCard(expense: expense);
              },
            ),
          ),
        ],
      ),
    );
  }
  
  Widget _buildExpenseSummary(List<TravelExpenseEntity> expenses) {
    final totalExpenses = expenses.fold(0.0, (sum, expense) => sum + expense.amount);
    final reimbursableTotal = expenses
        .where((expense) => expense.reimbursable && !expense.isReimbursed)
        .fold(0.0, (sum, expense) => sum + expense.amount);
        
    final currencyFormatter = NumberFormat.currency(locale: 'en_US', symbol: '\$');
    
    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Total Expenses',
                style: TextStyle(
                  fontWeight: FontWeight.w500,
                  color: Color(0xFF757575),
                ),
              ),
              Text(
                currencyFormatter.format(totalExpenses),
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          const Divider(),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Pending Reimbursement',
                style: TextStyle(
                  fontWeight: FontWeight.w500,
                  color: Color(0xFF757575),
                ),
              ),
              Text(
                currencyFormatter.format(reimbursableTotal),
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                  color: reimbursableTotal > 0 ? Colors.blue : Colors.grey,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
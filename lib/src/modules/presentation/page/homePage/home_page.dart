
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:intl/intl.dart';

import '../../../../exports.dart';

final sl = GetIt.instance;

class TravelExpensesPage extends StatelessWidget {
  const TravelExpensesPage({Key? key}) : super(key: key);

  void _navigateToExpenseForm(BuildContext context, TravelExpenseEntity? expense) {
    final travelExpensesBloc = context.read<TravelExpensesBloc>();
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (innerContext) {
          // Usamos MultiBlocProvider para fornecer ambos os blocos:
          return MultiBlocProvider(
            providers: [
              BlocProvider.value(value: travelExpensesBloc),
              BlocProvider(create: (_) => sl<ExpenseFormBloc>()),
            ],
            child: ExpenseFormPage(expense: expense),
          );
        },
      ),
    );
  }

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
              _showFilterOptions(context);
            },
          ),
        ],
      ),
      body: BlocConsumer<TravelExpensesBloc, TravelExpensesState>(
        listener: (context, state) {
          if (state is TravelExpenseActionSuccess) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: Colors.green,
              ),
            );
          }
        },
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
            return const Center(child: Text('Unknown state'));
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: const Color(0xFF1A73E8),
        child: const Icon(Icons.add),
        onPressed: () {
          _navigateToExpenseForm(context, null);
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
            Icon(Icons.receipt_long, size: 72, color: Color(0xFFBDBDBD)),
            SizedBox(height: 16),
            Text(
              'No travel expenses found',
              style: TextStyle(fontSize: 18, color: Color(0xFF757575)),
            ),
            SizedBox(height: 8),
            Text(
              'Add your first expense with the + button',
              style: TextStyle(color: Color(0xFFBDBDBD)),
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
          _buildExpenseSummary(expenses),
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: expenses.length,
              itemBuilder: (context, index) {
                final expense = expenses[index];
                return Dismissible(
                  key: Key('expense_${expense.id}'),
                  background: Container(
                    color: Colors.red,
                    alignment: Alignment.centerRight,
                    padding: const EdgeInsets.only(right: 20),
                    child: const Icon(Icons.delete, color: Colors.white),
                  ),
                  direction: DismissDirection.endToStart,
                  confirmDismiss: (direction) async {
                    return await _showDeleteConfirmationDialog(context, expense);
                  },
                  onDismissed: (direction) {
                    context.read<TravelExpensesBloc>().add(DeleteTravelExpense(expense.id));
                  },
                  child: GestureDetector(
                    onTap: () {
                      _navigateToExpenseForm(context, expense);
                    },
                    child: ExpenseCard(expense: expense),
                  ),
                );
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
                style: TextStyle(fontWeight: FontWeight.w500, color: Color(0xFF757575)),
              ),
              Text(
                currencyFormatter.format(totalExpenses),
                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
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
                style: TextStyle(fontWeight: FontWeight.w500, color: Color(0xFF757575)),
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

  Future<bool?> _showDeleteConfirmationDialog(BuildContext context, TravelExpenseEntity expense) {
    return showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Confirm Delete'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text(
                  'Are you sure you want to delete this expense?\n\n'
                  '${expense.description}\n'
                  'Amount: \$${expense.amount.toStringAsFixed(2)}'
                ),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop(false);
              },
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                foregroundColor: Colors.white,
              ),
              child: const Text('Delete'),
              onPressed: () {
                Navigator.of(context).pop(true);
              },
            ),
          ],
        );
      },
    );
  }

  void _showFilterOptions(BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 24.0, horizontal: 16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Filter Expenses',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),
              const Text(
                'Date Range',
                style: TextStyle(fontWeight: FontWeight.w500, fontSize: 16),
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  _buildFilterChip(context, 'All', true),
                  _buildFilterChip(context, 'This Month', false),
                  _buildFilterChip(context, 'Last Month', false),
                ],
              ),
              const SizedBox(height: 16),
              const Text(
                'Status',
                style: TextStyle(fontWeight: FontWeight.w500, fontSize: 16),
              ),
              const SizedBox(height: 8),
              Wrap(
                spacing: 8,
                children: [
                  _buildFilterChip(context, 'All', true),
                  _buildFilterChip(context, 'Reimbursed', false),
                  _buildFilterChip(context, 'Pending', false),
                ],
              ),
              const SizedBox(height: 16),
              const Text(
                'Category',
                style: TextStyle(fontWeight: FontWeight.w500, fontSize: 16),
              ),
              const SizedBox(height: 8),
              Wrap(
                spacing: 8,
                children: [
                  _buildFilterChip(context, 'All', true),
                  _buildFilterChip(context, 'Transport', false),
                  _buildFilterChip(context, 'Accommodation', false),
                  _buildFilterChip(context, 'Food', false),
                ],
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Theme.of(context).primaryColor,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 12),
                  ),
                  onPressed: () {
                    Navigator.pop(context);
                    // Apply filters here...
                  },
                  child: const Text('Apply Filters'),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildFilterChip(BuildContext context, String label, bool selected) {
    return Padding(
      padding: const EdgeInsets.only(right: 8.0),
      child: FilterChip(
        label: Text(label),
        selected: selected,
        onSelected: (selected) {
          // Update selected filters if needed.
        },
        backgroundColor: Colors.white,
        selectedColor: Theme.of(context).primaryColor.withOpacity(0.2),
        labelStyle: TextStyle(
          color: selected ? Theme.of(context).primaryColor : Colors.black87,
          fontWeight: selected ? FontWeight.bold : FontWeight.normal,
        ),
      ),
    );
  }
}

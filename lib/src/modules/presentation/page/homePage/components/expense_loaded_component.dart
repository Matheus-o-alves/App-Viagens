import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../exports.dart';
import 'expense_summary_component.dart';

class ExpenseLoadedContent extends StatelessWidget {
  final List<TravelExpenseEntity> expenses;
  final VoidCallback onRefresh;
  final void Function(TravelExpenseEntity expense) onExpenseTap;

  const ExpenseLoadedContent({
    super.key,
    required this.expenses,
    required this.onRefresh,
    required this.onExpenseTap,
  });

  @override
  Widget build(BuildContext context) {
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
      onRefresh: () async => onRefresh(),
      child: Column(
        children: [
          ExpenseSummary(expenses: expenses),
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
                    onTap: () => onExpenseTap(expense),
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

  Future<bool?> _showDeleteConfirmationDialog(BuildContext context, TravelExpenseEntity expense) {
    return showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          title: const Text('Confirm Delete'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text(
                  'Are you sure you want to delete this expense?\n\n'
                  '${expense.description}\n'
                  'Amount: \$${expense.amount.toStringAsFixed(2)}',
                ),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Cancel'),
              onPressed: () => Navigator.of(dialogContext).pop(false),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                foregroundColor: Colors.white,
              ),
              child: const Text('Delete'),
              onPressed: () => Navigator.of(dialogContext).pop(true),
            ),
          ],
        );
      },
    );
  }
}

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../../../exports.dart';

class ExpenseSummary extends StatelessWidget {
  final List<TravelExpenseEntity> expenses;

  const ExpenseSummary({super.key, required this.expenses});

  @override
  Widget build(BuildContext context) {
    final totalExpenses = expenses.fold<double>(
      0.0,
      (sum, expense) => sum + expense.amount,
    );
    final reimbursableTotal = expenses
        .where((expense) => expense.reimbursable && !expense.isReimbursed)
        .fold<double>(0.0, (sum, expense) => sum + expense.amount);

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
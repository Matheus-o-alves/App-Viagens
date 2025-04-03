import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../../../exports.dart';

class ExpenseDetailModal extends StatelessWidget {
  final List<TravelExpenseEntity> expenses;

  const ExpenseDetailModal({super.key, required this.expenses});

  @override
  Widget build(BuildContext context) {
    final currencyFormatter = NumberFormat.currency(locale: 'pt_BR', symbol: 'R\$');

    final totalExpenses = expenses.fold<double>(
      0.0,
      (sum, expense) => sum + expense.amount,
    );

    final reimbursableExpenses = expenses.where((e) => e.reimbursable && !e.isReimbursed).toList();
    final reimbursableTotal = reimbursableExpenses.fold<double>(
      0.0,
      (sum, expense) => sum + expense.amount,
    );

    final reimbursedExpenses = expenses.where((e) => e.reimbursable && e.isReimbursed).toList();
    final reimbursedTotal = reimbursedExpenses.fold<double>(
      0.0,
      (sum, expense) => sum + expense.amount,
    );

    final nonReimbursableExpenses = expenses.where((e) => !e.reimbursable).toList();
    final nonReimbursableTotal = nonReimbursableExpenses.fold<double>(
      0.0,
      (sum, expense) => sum + expense.amount,
    );

    final Map<String, double> expensesByCategory = {};
    for (var expense in expenses) {
      final category = expense.category;
      if (expensesByCategory.containsKey(category)) {
        expensesByCategory[category] = expensesByCategory[category]! + expense.amount;
      } else {
        expensesByCategory[category] = expense.amount;
      }
    }

    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Container(
        width: double.maxFinite,
        constraints: const BoxConstraints(
          maxWidth: 600,
          maxHeight: 600,
        ),
        padding: const EdgeInsets.all(24),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Relatório de Despesas',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              _buildSummarySection(
                  totalExpenses,
                  reimbursableTotal,
                  reimbursedTotal,
                  nonReimbursableTotal,
                  currencyFormatter),
              const SizedBox(height: 24),
              _buildCategoryBreakdown(expensesByCategory, currencyFormatter),
              const SizedBox(height: 24),
              if (reimbursableExpenses.isNotEmpty)
                _buildExpenseList('Reembolso Pendente', reimbursableExpenses, currencyFormatter),
              const SizedBox(height: 16),
              const SizedBox(height: 16),
              Align(
                alignment: Alignment.centerRight,
                child: ElevatedButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: const Text('Fechar'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSummarySection(
    double totalExpenses,
    double reimbursableTotal,
    double reimbursedTotal,
    double nonReimbursableTotal,
    NumberFormat formatter,
  ) {
    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Resumo',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            _buildSummaryRow('Total de Despesas', totalExpenses, formatter),
            const Divider(),
            _buildSummaryRow('Reembolso Pendente', reimbursableTotal, formatter, color: Colors.blue),
            _buildSummaryRow('Reembolsado', reimbursedTotal, formatter, color: Colors.green),
            _buildSummaryRow('Despesas Pessoais', nonReimbursableTotal, formatter),
          ],
        ),
      ),
    );
  }

  Widget _buildSummaryRow(String label, double amount, NumberFormat formatter, {Color? color}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: const TextStyle(
              fontWeight: FontWeight.w500,
            ),
          ),
          Text(
            formatter.format(amount),
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCategoryBreakdown(Map<String, double> expensesByCategory, NumberFormat formatter) {
    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Resumo por Categoria',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            ...expensesByCategory.entries.map((entry) =>
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 4),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      entry.key,
                      style: const TextStyle(
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    Text(
                      formatter.format(entry.value),
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildExpenseList(String title, List<TravelExpenseEntity> expenseList, NumberFormat formatter) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 8),
        ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: expenseList.length > 3 ? 3 : expenseList.length,
          itemBuilder: (context, index) {
            final expense = expenseList[index];
            return ListTile(
              contentPadding: EdgeInsets.zero,
              title: Text(expense.description),
              subtitle: Text(expense.category),
              trailing: Text(
                formatter.format(expense.amount),
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
            );
          },
        ),
        if (expenseList.length > 3)
          Align(
            alignment: Alignment.centerRight,
            child: TextButton(
              onPressed: () {},
              child: const Text('Ver todas'),
            ),
          ),
      ],
    );
  }
}

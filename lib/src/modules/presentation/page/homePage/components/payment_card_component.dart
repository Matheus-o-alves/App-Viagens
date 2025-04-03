import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import '../../../../../exports.dart';


class ExpenseCard extends StatelessWidget {
  final TravelExpenseEntity expense;
  final currencyFormatter = NumberFormat.currency(locale: 'pt_BR', symbol: 'R\$');

  ExpenseCard({super.key, required this.expense});

  @override
  Widget build(BuildContext context) {
    final bloc = context.read<TravelExpensesBloc>();

    final isReembolsado = expense.isReimbursed;
    final isReembolsavel = expense.reimbursable;

    final Color statusColor = bloc.getStatusColor(expense);
    final String statusText = bloc.getStatusText(expense);
    final IconData paymentMethodIcon = bloc.getPaymentMethodIcon(expense.paymentMethod);
    final IconData categoryIcon = bloc.getCategoryIcon(expense.category);

    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          Container(
            decoration: BoxDecoration(
              color: const Color(0xFF1A73E8),
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(12),
                topRight: Radius.circular(12),
              ),
            ),
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Icon(categoryIcon, color: Colors.white),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    bloc.sanitizeText(expense.description),
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: statusColor.withAlpha((0.1 * 255).round()),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Text(
                    statusText,
                    style: TextStyle(
                      color: statusColor,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ),

          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                Row(
                  children: [
                    const Icon(Icons.calendar_today, color: Color(0xFF757575), size: 20),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        'Data da Despesa: ${expense.expenseDateFormatted}',
                        style: const TextStyle(fontWeight: FontWeight.w500, fontSize: 16),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 12),

                Row(
                  children: [
                    Icon(categoryIcon, color: const Color(0xFF757575), size: 20),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        'Categoria: ${bloc.sanitizeText(expense.category)}',
                        style: const TextStyle(fontWeight: FontWeight.w500, fontSize: 14),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 12),

                Row(
                  children: [
                    const Icon(Icons.account_balance_wallet, color: Color(0xFF757575), size: 20),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        'Valor Total: ${currencyFormatter.format(expense.amount)}',
                        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                      ),
                    ),
                  ],
                ),

                if (isReembolsavel && !isReembolsado) ...[
                  const SizedBox(height: 12),
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.blue.withAlpha((0.1 * 255).round())
,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      children: const [
                        Icon(Icons.info_outline, color: Colors.blue, size: 16),
                        SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            'Esta despesa é elegível para reembolso',
                            style: TextStyle(color: Colors.blue, fontSize: 12),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],

                const Divider(),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  child: Row(
                    children: [
                      Icon(paymentMethodIcon, color: const Color(0xFF757575), size: 20),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          'Forma de Pagamento: ${bloc.sanitizeText(expense.paymentMethod)}',
                          style: const TextStyle(color: Color(0xFF757575)),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          if (!isReembolsado && isReembolsavel)
            Container(
              decoration: const BoxDecoration(
                color: Color(0xFFF5F5F5),
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(12),
                  bottomRight: Radius.circular(12),
                ),
              ),
              padding: const EdgeInsets.all(12),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: () {},
                    child: const Text('Ver Detalhes'),
                  ),
                  const SizedBox(width: 8),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF1A73E8),
                      foregroundColor: Colors.white,
                    ),
                    onPressed: () {},
                    child: const Text('Solicitar Reembolso'),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}

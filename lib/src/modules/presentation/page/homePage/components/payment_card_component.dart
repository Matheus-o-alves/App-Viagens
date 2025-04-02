import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../../../domain/domain.dart';

class ExpenseCard extends StatelessWidget {
  final TravelExpenseEntity expense;
  final currencyFormatter = NumberFormat.currency(locale: 'pt_BR', symbol: 'R\$');

  ExpenseCard({Key? key, required this.expense}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final isReembolsado = expense.isReimbursed;
    final isReembolsavel = expense.reimbursable;
    
    final Color statusColor = isReembolsado
        ? const Color(0xFF4CAF50)
        : expense.status == 'pending_approval'
            ? const Color(0xFFFFA000)
            : expense.status == 'past_due'
                ? const Color(0xFFF44336)
                : const Color(0xFF1A73E8);

    final String statusText = isReembolsado
        ? 'Reembolsado'
        : expense.status == 'pending_approval'
            ? 'Aguardando Aprovação'
            : expense.status == 'past_due'
                ? 'Vencido'
                : 'Agendado';

    final IconData paymentMethodIcon = _getPaymentMethodIcon(expense.paymentMethod);
    final IconData categoryIcon = _getCategoryIcon(expense.category);

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
                    expense.description,
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
                    color: statusColor.withOpacity(0.2),
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

          // Conteúdo
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                // Data
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

                // Categoria
                Row(
                  children: [
                    Icon(categoryIcon, color: const Color(0xFF757575), size: 20),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        'Categoria: ${expense.category}',
                        style: const TextStyle(fontWeight: FontWeight.w500, fontSize: 14),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 12),

                // Valor
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

                // Info de Reembolso
                if (isReembolsavel && !isReembolsado) ...[
                  const SizedBox(height: 12),
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.blue.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.info_outline, color: Colors.blue, size: 16),
                        const SizedBox(width: 8),
                        const Expanded(
                          child: Text(
                            'Esta despesa é elegível para reembolso',
                            style: TextStyle(color: Colors.blue, fontSize: 12),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],

                // Método de Pagamento
                const Divider(),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  child: Row(
                    children: [
                      Icon(paymentMethodIcon, color: const Color(0xFF757575), size: 20),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          'Forma de Pagamento: ${expense.paymentMethod}',
                          style: const TextStyle(color: Color(0xFF757575)),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // Botões
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
                    onPressed: () {
                      // Ver detalhes
                    },
                    child: const Text('Ver Detalhes'),
                  ),
                  const SizedBox(width: 8),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF1A73E8),
                      foregroundColor: Colors.white,
                    ),
                    onPressed: () {
                      // Solicitar reembolso
                    },
                    child: const Text('Solicitar Reembolso'),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }

  IconData _getPaymentMethodIcon(String paymentMethod) {
    switch (paymentMethod.toLowerCase()) {
      case 'cartão corporativo':
        return Icons.credit_card;
      case 'dinheiro':
        return Icons.attach_money;
      case 'aplicativo':
        return Icons.phone_android;
      default:
        return Icons.payment;
    }
  }

  IconData _getCategoryIcon(String category) {
    switch (category.toLowerCase()) {
      case 'transporte':
        return Icons.directions_car;
      case 'hospedagem':
        return Icons.hotel;
      case 'alimentação':
        return Icons.restaurant;
      default:
        return Icons.category;
    }
  }
}

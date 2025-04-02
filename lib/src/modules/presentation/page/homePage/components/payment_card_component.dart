
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../../../domain/domain.dart';

class ExpenseCard extends StatelessWidget {
  final TravelExpenseEntity expense;
  final currencyFormatter = NumberFormat.currency(locale: 'en_US', symbol: '\$');

  ExpenseCard({Key? key, required this.expense}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final isReimbursed = expense.isReimbursed;
    final isReimbursable = expense.reimbursable;
    
    final Color statusColor = isReimbursed
        ? const Color(0xFF4CAF50) 
        : expense.status == 'pending_approval'
            ? const Color(0xFFFFA000)  
            : expense.status == 'past_due'
                ? const Color(0xFFF44336)  
                : const Color(0xFF1A73E8); 

    final String statusText = isReimbursed
        ? 'Reimbursed'
        : expense.status == 'pending_approval'
            ? 'Pending Approval'
            : expense.status == 'past_due'
                ? 'Past Due'
                : 'Scheduled';
            
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
                Icon(
                  categoryIcon,
                  color: Colors.white,
                ),
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
          
          // Content
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                // Date row
                Row(
                  children: [
                    const Icon(
                      Icons.calendar_today,
                      color: Color(0xFF757575),
                      size: 20,
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        'Expense Date: ${expense.expenseDateFormatted}',
                        style: const TextStyle(
                          fontWeight: FontWeight.w500,
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ],
                ),
                
                const SizedBox(height: 12),
                
                // Category row
                Row(
                  children: [
                    Icon(
                      categoryIcon,
                      color: const Color(0xFF757575),
                      size: 20,
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        'Category: ${expense.category}',
                        style: const TextStyle(
                          fontWeight: FontWeight.w500,
                          fontSize: 14,
                        ),
                      ),
                    ),
                  ],
                ),
                
                const SizedBox(height: 12),
                
                // Expense amount
                Row(
                  children: [
                    const Icon(
                      Icons.account_balance_wallet,
                      color: Color(0xFF757575),
                      size: 20,
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        'Total Amount: ${currencyFormatter.format(expense.amount)}',
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                        ),
                      ),
                    ),
                  ],
                ),
                
                // Reimbursement info
                if (expense.reimbursable && !expense.isReimbursed) ...[
                  const SizedBox(height: 12),
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.blue.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      children: [
                        const Icon(
                          Icons.info_outline,
                          color: Colors.blue,
                          size: 16,
                        ),
                        const SizedBox(width: 8),
                        const Expanded(
                          child: Text(
                            'This expense is eligible for reimbursement',
                            style: TextStyle(
                              color: Colors.blue,
                              fontSize: 12,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
                
                // Payment method
                const Divider(),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  child: Row(
                    children: [
                      Icon(
                        paymentMethodIcon,
                        color: const Color(0xFF757575),
                        size: 20,
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          'Payment Method: ${expense.paymentMethod}',
                          style: const TextStyle(
                            color: Color(0xFF757575),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          
          // Action buttons
          if (!expense.isReimbursed && expense.reimbursable)
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
                      // Implement view details functionality
                    },
                    child: const Text('View Details'),
                  ),
                  const SizedBox(width: 8),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF1A73E8),
                      foregroundColor: Colors.white,
                    ),
                    onPressed: () {
                      // Implement request reimbursement functionality
                    },
                    child: const Text('Request Reimbursement'),
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

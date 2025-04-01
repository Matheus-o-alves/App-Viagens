import 'package:intl/intl.dart';

class PaymentsFormatter {
  PaymentsFormatter._();

  static String formatDate(DateTime date) => 
      DateFormat('dd/MM/yyyy').format(date);
  
  static String formatCurrency(double value) =>
      NumberFormat.currency(locale: 'pt_BR', symbol: 'R\$').format(value);
}

import 'package:flutter/material.dart';

import '../../app_widget.dart';
import '../../modules/payments/presentation/page/paymenPage/payments_transactions_page.dart';


class AppRoutes {
  AppRoutes._();
  
  static const String payments = '/payments';
  
  static final Map<String, WidgetBuilder> routes = {
    payments: (_) => const PaymentsTransactionsPage(),
  };
}
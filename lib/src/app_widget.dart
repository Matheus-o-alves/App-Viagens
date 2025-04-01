import 'package:flutter/material.dart';

import 'core/routes/app_routes.dart';



class AppWidget extends StatelessWidget {
  const AppWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      initialRoute: AppRoutes.payments,
      routes: AppRoutes.routes,
    );
  }
}

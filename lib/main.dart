
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'src/modules/presentation/bloc/homePageBloc/home_page_bloc.dart';
import 'src/modules/presentation/di/di.dart' as di;
import 'src/modules/presentation/page/homePage/home_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await di.init();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Travel App',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
        scaffoldBackgroundColor: const Color(0xFFF5F5F5),
        appBarTheme: const AppBarTheme(
          color: Color(0xFF1A73E8),
        ),
      ),
      home: BlocProvider(
        create: (_) => di.sl<TravelExpensesBloc>(),
        child: const TravelExpensesPage(),
      ),
    );
  }
}
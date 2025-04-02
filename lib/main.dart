// main.dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:onfly_viagens_app/src/modules/presentation/bloc/homePageBloc/home_page_bloc.dart'
    show TravelExpensesBloc;
import 'package:onfly_viagens_app/src/modules/presentation/page/homePage/home_page.dart'
    show TravelExpensesPage;
import 'src/core/services/database_sync_service.dart';
import 'src/modules/presentation/di/di.dart' as di;
import 'src/modules/presentation/page/loginPage/login_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await di.init();

  // Initialize the database sync service
  final syncService = DatabaseSyncService(
    localDataSource: di.sl(),
    remoteDataSource: di.sl(),
    connectivity: di.sl(),
  );
  syncService.initialize();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Travel Expenses',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
        primaryColor: const Color(0xFF1A73E8),
        visualDensity: VisualDensity.adaptivePlatformDensity,
        scaffoldBackgroundColor: const Color(0xFFF5F5F5),
        appBarTheme: const AppBarTheme(
          color: Color(0xFF1A73E8),
        ),
      ),
      home: BlocProvider(
        create: (_) => di.sl<TravelExpensesBloc>(),
        child: const LoginPage(),
      ),
    );
  }
}

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:get_it/get_it.dart';
import 'package:http/http.dart' as http;

import '../../data/data.dart';
import '../../data/datasource/travel_expenses_local_data_source.dart';
import '../../data/repository/payments_repository_impl.dart';
import '../../domain/domain.dart';
import '../../domain/usecase/delete_travels_usescases.dart';
import '../../domain/usecase/get_travel_expense_by_id_use_case.dart';
import '../../domain/usecase/save_travel_expenses_usecase.dart';
import '../../infra/database/database_helper.dart' show DatabaseHelper;
import '../bloc/formExpenseBLoc/expense_form_bloc.dart';
import '../bloc/homePageBloc/home_page_bloc.dart';

final sl = GetIt.instance;

Future<void> init() async {
  // Database
  sl.registerLazySingleton(() => DatabaseHelper.instance);

  // Blocs
  sl.registerFactory(
    () => TravelExpensesBloc(
      getTravelExpensesUseCase: sl(),
      saveTravelExpenseUseCase: sl(),
      deleteTravelExpenseUseCase: sl(),
      getTravelExpenseByIdUseCase: sl(),
    ),
  );
  
  // Registrar o ExpenseFormBloc
  sl.registerFactory(
    () => ExpenseFormBloc(
      saveTravelExpenseUseCase: sl(),
      getTravelExpenseByIdUseCase: sl(),
    ),
  );

  // Use cases
  sl.registerLazySingleton(() => GetTravelExpensesUseCase(sl()));
  sl.registerLazySingleton(() => SaveTravelExpenseUseCase(sl()));
  sl.registerLazySingleton(() => DeleteTravelExpenseUseCase(sl()));
  sl.registerLazySingleton(() => GetTravelExpenseByIdUseCase(sl()));

  // Repository
  sl.registerLazySingleton<TravelExpensesRepository>(
    () => TravelExpensesRepositoryImpl(sl(), sl(), sl()),
  );

  // Data sources
  sl.registerLazySingleton<TravelExpensesRemoteDataSource>(
    () => TravelExpensesRemoteDataSource(client: sl()),
  );
  
  sl.registerLazySingleton<TravelExpensesLocalDataSource>(
    () => TravelExpensesLocalDataSource(databaseHelper: sl()),
  );

  // External
  sl.registerLazySingleton(() => http.Client());
  sl.registerLazySingleton(() => Connectivity());
}

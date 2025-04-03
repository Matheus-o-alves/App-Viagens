import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:get_it/get_it.dart';
import 'package:http/http.dart' as http;

import '../../../exports.dart';
import '../../data/data.dart';
import '../../data/datasource/travel_expenses_local_data_source.dart'
    show TravelExpensesLocalDataSourceImpl;
import '../../data/repository/payments_repository_impl.dart';
import '../../infra/datasource/travel_expenses_local_data_source.dart';
import '../../infra/datasource/travel_expenses_remote_data_source.dart';
import '../bloc/loginBloc/login_bloc.dart';

final sl = GetIt.instance;

Future<void> init() async {
  _registerExternalDependencies();
  _registerAuthenticationDependencies();
  _registerTravelExpensesDependencies();
  _registerUseCases();
  _registerBlocs();
  _registerServices();
}

void _registerExternalDependencies() {
  sl.registerLazySingleton<http.Client>(() => http.Client());
  sl.registerLazySingleton<Connectivity>(() => Connectivity());
  sl.registerLazySingleton<DatabaseHelper>(() => DatabaseHelper.instance);
}

void _registerAuthenticationDependencies() {
  sl.registerLazySingleton<AuthRepository>(
    () => AuthRepositoryImpl(AuthRemoteDataSource()),
  );
  sl.registerLazySingleton<LoginUseCase>(() => LoginUseCase(sl<AuthRepository>()));
  sl.registerFactory<LoginBloc>(() => LoginBloc(loginUseCase: sl<LoginUseCase>()));
}

void _registerTravelExpensesDependencies() {

  sl.registerLazySingleton<TravelExpensesRemoteDataSource>(
    () => TravelExpensesRemoteDataSourceImpl(
      client: sl<http.Client>(),
      localDataSource: sl<TravelExpensesLocalDataSource>(), 
    ),
  );
  
  sl.registerLazySingleton<TravelExpensesLocalDataSource>(
    () => TravelExpensesLocalDataSourceImpl(databaseHelper: sl<DatabaseHelper>()),
  );
  
  sl.registerLazySingleton<TravelExpensesDataSource>(
    () => sl<TravelExpensesLocalDataSource>(),
  );
  
  sl.registerLazySingleton<TravelExpensesRepository>(
    () => TravelExpensesRepositoryImpl(dataSource: sl<TravelExpensesLocalDataSource>()),
  );
}

void _registerUseCases() {
  sl.registerLazySingleton<GetTravelExpensesUseCase>(
    () => GetTravelExpensesUseCase(sl<TravelExpensesRepository>()),
  );
  sl.registerLazySingleton<SaveTravelExpenseUseCase>(
    () => SaveTravelExpenseUseCase(sl<TravelExpensesRepository>()),
  );
  sl.registerLazySingleton<DeleteTravelExpenseUseCase>(
    () => DeleteTravelExpenseUseCase(sl<TravelExpensesRepository>()),
  );
  sl.registerLazySingleton<GetTravelExpenseByIdUseCase>(
    () => GetTravelExpenseByIdUseCase(sl<TravelExpensesRepository>()),
  );
}

void _registerBlocs() {
  sl.registerFactory<TravelExpensesBloc>(
    () => TravelExpensesBloc(
      getTravelExpensesUseCase: sl<GetTravelExpensesUseCase>(),
      saveTravelExpenseUseCase: sl<SaveTravelExpenseUseCase>(),
      deleteTravelExpenseUseCase: sl<DeleteTravelExpenseUseCase>(),
      getTravelExpenseByIdUseCase: sl<GetTravelExpenseByIdUseCase>(),
    ),
  );
  
  sl.registerFactory<ExpenseFormBloc>(
    () => ExpenseFormBloc(
      saveTravelExpenseUseCase: sl<SaveTravelExpenseUseCase>(),
      getTravelExpenseByIdUseCase: sl<GetTravelExpenseByIdUseCase>(),
    ),
  );
}

void _registerServices() {
  sl.registerLazySingleton<DatabaseSyncService>(
    () => DatabaseSyncService(
      localDataSource: sl<TravelExpensesLocalDataSource>(),
      remoteDataSource: sl<TravelExpensesRemoteDataSource>(),
      connectivity: sl<Connectivity>(),
      onSyncComplete: () {
        try {
          if (sl.isRegistered<TravelExpensesBloc>()) {
            sl<TravelExpensesBloc>().add(const FetchTravelExpenses());
          }
        } catch (e) {
          Exception(e);
        }
      },
    ),
  );


}
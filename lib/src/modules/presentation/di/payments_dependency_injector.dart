// payments_dependency_injector.dart - Corrigido
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:get_it/get_it.dart';
import 'package:http/http.dart' as http;

import '../../data/data.dart';
import '../../data/datasource/travel_expenses_local_data_source.dart' show TravelExpensesLocalDataSourceImpl;

import '../../data/repository/payments_repository_impl.dart';
import '../../domain/domain.dart';
import '../../domain/usecase/delete_travels_usescases.dart';
import '../../domain/usecase/get_travel_expense_by_id_use_case.dart';
import '../../domain/usecase/save_travel_expenses_usecase.dart';
import '../../infra/database/database_helper.dart';
import '../../infra/datasource/travel_expenses_data_source.dart';
import '../../infra/datasource/travel_expenses_local_data_source.dart';
import '../../infra/datasource/travel_expenses_remote_data_source.dart';
import '../bloc/formExpenseBLoc/expense_form_bloc.dart';
import '../bloc/homePageBloc/home_page_bloc.dart';
import '../bloc/homePageBloc/home_page_event.dart'; // Adicione esta importação
import '../../../core/services/database_sync_service.dart';

final sl = GetIt.instance;

Future<void> init() async {
  // Primeiro registrar as camadas externas
  // External
  sl.registerLazySingleton(() => http.Client());
  sl.registerLazySingleton(() => Connectivity());
  sl.registerLazySingleton(() => DatabaseHelper.instance);

  // Depois registrar os Data Sources
  sl.registerLazySingleton<TravelExpensesLocalDataSource>(
    () => TravelExpensesLocalDataSourceImpl(databaseHelper: sl()),
  );
  
  sl.registerLazySingleton<TravelExpensesRemoteDataSource>(
    () => TravelExpensesRemoteDataSourceImpl(client: sl()),
  );
  
  // Agora podemos referenciar o TravelExpensesLocalDataSource ao registrar o TravelExpensesDataSource
  sl.registerLazySingleton<TravelExpensesDataSource>(
    () => sl<TravelExpensesLocalDataSource>(),
  );

  // Repository
  sl.registerLazySingleton<TravelExpensesRepository>(
    () => TravelExpensesRepositoryImpl(dataSource: sl<TravelExpensesLocalDataSource>()),
  );

  // Use cases
  sl.registerLazySingleton(() => GetTravelExpensesUseCase(sl()));
  sl.registerLazySingleton(() => SaveTravelExpenseUseCase(sl()));
  sl.registerLazySingleton(() => DeleteTravelExpenseUseCase(sl()));
  sl.registerLazySingleton(() => GetTravelExpenseByIdUseCase(sl()));

  // Blocs
  sl.registerFactory(
    () => TravelExpensesBloc(
      getTravelExpensesUseCase: sl(),
      saveTravelExpenseUseCase: sl(),
      deleteTravelExpenseUseCase: sl(),
      getTravelExpenseByIdUseCase: sl(),
    ),
  );
  
  sl.registerFactory(
    () => ExpenseFormBloc(
      saveTravelExpenseUseCase: sl(),
      getTravelExpenseByIdUseCase: sl(),
    ),
  );

  // Services - Registrar por último pois depende de tudo acima
  sl.registerLazySingleton(() => DatabaseSyncService(
    localDataSource: sl<TravelExpensesLocalDataSource>(),
    remoteDataSource: sl<TravelExpensesRemoteDataSource>(),
    connectivity: sl(),
    onSyncComplete: () {
      // Tente notificar o bloc se ele estiver disponível
      try {
        if (sl.isRegistered<TravelExpensesBloc>()) {
          sl<TravelExpensesBloc>().add(const FetchTravelExpenses());
        }
      } catch (e) {
        print('Não foi possível notificar o bloc: $e');
      }
    },
  ));
  
  // Inicializar o serviço de sincronização
  sl<DatabaseSyncService>().initialize();
}
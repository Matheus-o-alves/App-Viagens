// payments_dependency_injector.dart - Versão Refatorada
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:get_it/get_it.dart';
import 'package:http/http.dart' as http;

import '../../../exports.dart';
import '../../data/data.dart';
import '../../data/datasource/travel_expenses_local_data_source.dart'
    show TravelExpensesLocalDataSourceImpl;
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
import '../bloc/expensesPageBloc/expenses_bloc.dart';
import '../bloc/expensesPageBloc/expenses_event.dart';
import '../../../core/services/database_sync_service.dart';
import '../bloc/loginBloc/login_bloc.dart';

final sl = GetIt.instance;

/// Inicializa todas as dependências da aplicação.
Future<void> init() async {
  _registerExternalDependencies();
  _registerAuthenticationDependencies();
  _registerTravelExpensesDependencies();
  _registerUseCases();
  _registerBlocs();
  _registerServices();
}

void _registerExternalDependencies() {
  // Dependências externas e helpers
  sl.registerLazySingleton<http.Client>(() => http.Client());
  sl.registerLazySingleton<Connectivity>(() => Connectivity());
  sl.registerLazySingleton<DatabaseHelper>(() => DatabaseHelper.instance);
}

void _registerAuthenticationDependencies() {
  // Autenticação
  sl.registerLazySingleton<AuthRepository>(
    () => AuthRepositoryImpl(AuthRemoteDataSource()),
  );
  sl.registerLazySingleton<LoginUseCase>(() => LoginUseCase(sl<AuthRepository>()));
  sl.registerFactory<LoginBloc>(() => LoginBloc(loginUseCase: sl<LoginUseCase>()));
}

void _registerTravelExpensesDependencies() {
  // Fonte de dados remota
  sl.registerLazySingleton<TravelExpensesRemoteDataSource>(
    () => TravelExpensesRemoteDataSourceImpl(
      client: sl<http.Client>(),
      localDataSource: sl<TravelExpensesLocalDataSource>(), // Adicionado
    ),
  );
  
  // Restante do código permanece igual
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
  // Casos de uso para despesas de viagem
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
  // Blocs de despesas e formulário
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
  // Serviço de sincronização do banco de dados
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
          print('Não foi possível notificar o bloc: $e');
        }
      },
    ),
  );

  // ❌ Removido: sl<DatabaseSyncService>().initialize();
  // ✅ Agora inicializamos no main.dart, após todas as dependências serem registradas.
}
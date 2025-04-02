// injection_container.dart
import 'package:get_it/get_it.dart';
import 'package:http/http.dart' as http;
import 'package:onfly_viagens_app/src/modules/data/repository/payments_repository_impl.dart' show TravelExpensesRepositoryImpl;
import '../../data/data.dart';
import '../../domain/domain.dart';
import '../../domain/usecase/usecase.dart';
import '../../infra/datasource/travel_expenses_data_source.dart';
import '../bloc/homePageBloc/home_page_bloc.dart';

final sl = GetIt.instance;

Future<void> init() async {
  // Bloc
  sl.registerFactory(
    () => TravelExpensesBloc(
      getTravelExpensesUseCase: sl(),
    ),
  );

  // Use cases
  sl.registerLazySingleton(() => GetTravelExpensesUseCase(sl()));

  // Repository
  sl.registerLazySingleton<TravelExpensesRepository>(
    () => TravelExpensesRepositoryImpl(sl()),
  );

  // Data sources
  sl.registerLazySingleton<TravelExpensesDataSource>(
    () => TravelExpensesRemoteDataSource(client: sl()),
  );

  // External
  sl.registerLazySingleton(() => http.Client());
}

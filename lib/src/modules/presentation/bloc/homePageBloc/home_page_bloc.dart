// Bloc
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/core.dart';
import '../../../domain/domain.dart';
import 'home_page_event.dart';
import 'home_page_state.dart';

class TravelExpensesBloc extends Bloc<TravelExpensesEvent, TravelExpensesState> {
  final GetTravelExpensesUseCase getTravelExpensesUseCase;

  TravelExpensesBloc({required this.getTravelExpensesUseCase}) : super(TravelExpensesInitial()) {
    on<FetchTravelExpenses>(_onFetchTravelExpenses);
    on<RefreshTravelExpenses>(_onRefreshTravelExpenses);
  }

  Future<void> _onFetchTravelExpenses(
    FetchTravelExpenses event,
    Emitter<TravelExpensesState> emit,
  ) async {
    emit(TravelExpensesLoading());
    final result = await getTravelExpensesUseCase(NoParams());
    
    result.fold(
      (failure) => emit(TravelExpensesError(_mapFailureToMessage(failure))),
      (expenses) => emit(TravelExpensesLoaded(expenses)),
    );
  }

  Future<void> _onRefreshTravelExpenses(
    RefreshTravelExpenses event,
    Emitter<TravelExpensesState> emit,
  ) async {
    final currentState = state;
    if (currentState is TravelExpensesLoaded) {
      emit(TravelExpensesLoading());
      final result = await getTravelExpensesUseCase(NoParams());
      
      result.fold(
        (failure) => emit(TravelExpensesError(_mapFailureToMessage(failure))),
        (expenses) => emit(TravelExpensesLoaded(expenses)),
      );
    }
  }

  String _mapFailureToMessage(Failure failure) {
    switch (failure.runtimeType) {
      case ServerFailure:
        return 'Server error occurred';
      case ConnectionFailure:
        return 'No internet connection';
      default:
        return 'An unexpected error occurred';
    }
  }
}

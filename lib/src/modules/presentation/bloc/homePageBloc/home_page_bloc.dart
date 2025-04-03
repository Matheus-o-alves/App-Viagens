import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';

import '../../../../core/core.dart';
import '../../../../core/services/database_sync_service.dart';
import '../../../domain/domain.dart';
import '../../../domain/usecase/delete_travels_usescases.dart';
import '../../../domain/usecase/get_travel_expense_by_id_use_case.dart';
import '../../../domain/usecase/save_travel_expenses_usecase.dart';
import 'home_page_event.dart';
import 'home_page_state.dart';

class TravelExpensesBloc extends Bloc<TravelExpensesEvent, TravelExpensesState> {
  final GetTravelExpensesUseCase getTravelExpensesUseCase;
  final SaveTravelExpenseUseCase saveTravelExpenseUseCase;
  final DeleteTravelExpenseUseCase deleteTravelExpenseUseCase;
  final GetTravelExpenseByIdUseCase getTravelExpenseByIdUseCase;

  TravelExpensesBloc({
    required this.getTravelExpensesUseCase,
    required this.saveTravelExpenseUseCase,
    required this.deleteTravelExpenseUseCase,
    required this.getTravelExpenseByIdUseCase,
  }) : super(TravelExpensesInitial()) {
    on<FetchTravelExpenses>(_onFetchTravelExpenses);
    on<RefreshTravelExpenses>(_onRefreshTravelExpenses);
    on<AddTravelExpense>(_onAddTravelExpense);
    on<UpdateTravelExpense>(_onUpdateTravelExpense);
    on<DeleteTravelExpense>(_onDeleteTravelExpense);
    on<GetTravelExpenseDetails>(_onGetTravelExpenseDetails);
    on<SyncTravelExpenses>(_onSyncTravelExpenses);

    // 🔄 Inicializa o serviço de sincronização com o callback no construtor
    final syncService = GetIt.instance<DatabaseSyncService>();
    syncService.initializeWithCallback(() {
      add(const FetchTravelExpenses());
    });
  }

  Future<void> _onFetchTravelExpenses(
    FetchTravelExpenses event,
    Emitter<TravelExpensesState> emit,
  ) async {
    emit(TravelExpensesLoading());
    final result = await getTravelExpensesUseCase(NoParams());

    result.fold(
      (failure) => emit(TravelExpensesError(_mapFailureToMessage(failure))),
      (info) {
        final sortedExpenses = List<TravelExpenseEntity>.from(info.despesasdeviagem)
          ..sort((a, b) => b.expenseDate.compareTo(a.expenseDate));
        emit(TravelExpensesLoaded(sortedExpenses, info.cartoes));
      },
    );
  }

  Future<void> _onSyncTravelExpenses(
    SyncTravelExpenses event,
    Emitter<TravelExpensesState> emit,
  ) async {
    add(const FetchTravelExpenses());
  }

  Future<void> _onRefreshTravelExpenses(
    RefreshTravelExpenses event,
    Emitter<TravelExpensesState> emit,
  ) async {
    emit(TravelExpensesLoading());
    final result = await getTravelExpensesUseCase(NoParams());

    result.fold(
      (failure) => emit(TravelExpensesError(_mapFailureToMessage(failure))),
      (info) {
        final sortedExpenses = List<TravelExpenseEntity>.from(info.despesasdeviagem)
          ..sort((a, b) => b.expenseDate.compareTo(a.expenseDate));
        emit(TravelExpensesLoaded(sortedExpenses, info.cartoes));
      },
    );
  }

  Future<void> _onAddTravelExpense(
    AddTravelExpense event,
    Emitter<TravelExpensesState> emit,
  ) async {
    emit(TravelExpensesLoading());
    final result = await saveTravelExpenseUseCase(event.expense);

    result.fold(
      (failure) => emit(TravelExpensesError(_mapFailureToMessage(failure))),
      (_) {
        add(const FetchTravelExpenses());
        emit(const TravelExpenseActionSuccess(
          message: 'Expense added successfully',
          actionType: TravelExpensesActionType.add,
        ));
      },
    );
  }

  Future<void> _onUpdateTravelExpense(
    UpdateTravelExpense event,
    Emitter<TravelExpensesState> emit,
  ) async {
    emit(TravelExpensesLoading());
    final result = await saveTravelExpenseUseCase(event.expense);

    result.fold(
      (failure) => emit(TravelExpensesError(_mapFailureToMessage(failure))),
      (_) {
        add(const FetchTravelExpenses());
        emit(const TravelExpenseActionSuccess(
          message: 'Expense updated successfully',
          actionType: TravelExpensesActionType.update,
        ));
      },
    );
  }

  Future<void> _onDeleteTravelExpense(
    DeleteTravelExpense event,
    Emitter<TravelExpensesState> emit,
  ) async {
    emit(TravelExpensesLoading());
    final result = await deleteTravelExpenseUseCase(event.expenseId);

    result.fold(
      (failure) => emit(TravelExpensesError(_mapFailureToMessage(failure))),
      (_) {
        add(const FetchTravelExpenses());
        emit(const TravelExpenseActionSuccess(
          message: 'Expense deleted successfully',
          actionType: TravelExpensesActionType.delete,
        ));
      },
    );
  }

  Future<void> _onGetTravelExpenseDetails(
    GetTravelExpenseDetails event,
    Emitter<TravelExpensesState> emit,
  ) async {
    emit(TravelExpensesLoading());
    final result = await getTravelExpenseByIdUseCase(event.expenseId);

    result.fold(
      (failure) => emit(TravelExpensesError(_mapFailureToMessage(failure))),
      (expense) {
        if (expense != null) {
          emit(TravelExpenseDetailsLoaded(expense));
        } else {
          emit(const TravelExpensesError('Expense not found'));
        }
      },
    );
  }

  String _mapFailureToMessage(Failure failure) {
    switch (failure.runtimeType) {
      case ServerFailure:
        return 'Server error occurred';
      case ConnectionFailure:
        return 'No internet connection';
      case DatabaseFailure:
        return 'Database error: ${failure.message}';
      default:
        return 'An unexpected error occurred';
    }
  }
}

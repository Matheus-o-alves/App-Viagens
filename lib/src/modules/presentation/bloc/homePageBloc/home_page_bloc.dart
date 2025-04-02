// Bloc
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/core.dart';
import '../../../domain/domain.dart';
import '../../../domain/usecase/delete_travels_usescases.dart';
import '../../../domain/usecase/get_travel_expense_by_id_use_case.dart';
import '../../../domain/usecase/save_travel_expenses_usecase.dart' show SaveTravelExpenseUseCase;
import 'home_page_event.dart';
import 'home_page_state.dart';

// presentation/bloc/travelExpensesBloc/travel_expenses_bloc.dart
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/core.dart';
import '../../../domain/domain.dart';


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
    emit(TravelExpensesLoading());
    final result = await getTravelExpensesUseCase(NoParams());
    
    result.fold(
      (failure) => emit(TravelExpensesError(_mapFailureToMessage(failure))),
      (expenses) => emit(TravelExpensesLoaded(expenses)),
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
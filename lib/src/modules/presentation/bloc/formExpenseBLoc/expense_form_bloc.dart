import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:onfly_viagens_app/src/modules/domain/usecase/get_travel_expense_by_id_use_case.dart';
import 'package:onfly_viagens_app/src/modules/domain/usecase/save_travel_expenses_usecase.dart' show SaveTravelExpenseUseCase;
import '../../../../core/core.dart';

import 'expense_form_event.dart';
import 'expense_form_state.dart';

class ExpenseFormBloc extends Bloc<ExpenseFormEvent, ExpenseFormState> {
  final SaveTravelExpenseUseCase saveTravelExpenseUseCase;
  final GetTravelExpenseByIdUseCase getTravelExpenseByIdUseCase;

  ExpenseFormBloc({
    required this.saveTravelExpenseUseCase,
    required this.getTravelExpenseByIdUseCase,
  }) : super(ExpenseFormInitial()) {
    on<InitializeNewExpense>(_onInitializeNewExpense);
    on<LoadExpense>(_onLoadExpense);
    on<SaveExpense>(_onSaveExpense);
  }

  Future<void> _onInitializeNewExpense(
    InitializeNewExpense event,
    Emitter<ExpenseFormState> emit,
  ) async {
    emit(const ExpenseFormReady(expense: null));
  }

  Future<void> _onLoadExpense(
    LoadExpense event,
    Emitter<ExpenseFormState> emit,
  ) async {
    emit(ExpenseFormLoading());
    
    final result = await getTravelExpenseByIdUseCase(event.expenseId);
    
    result.fold(
      (failure) => emit(ExpenseFormError(_mapFailureToMessage(failure))),
      (expense) => emit(ExpenseFormReady(expense: expense)),
    );
  }

  Future<void> _onSaveExpense(
    SaveExpense event,
    Emitter<ExpenseFormState> emit,
  ) async {
    emit(ExpenseFormSaving());
    
    final isNewExpense = event.expense.id == 0;
    final result = await saveTravelExpenseUseCase(event.expense);
    
    result.fold(
      (failure) => emit(ExpenseFormError(_mapFailureToMessage(failure))),
      (id) => emit(ExpenseFormSuccess(
        isNewExpense: isNewExpense,
        message: isNewExpense 
            ? 'Expense added successfully'
            : 'Expense updated successfully',
      )),
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
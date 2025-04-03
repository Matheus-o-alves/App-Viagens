import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:intl/intl.dart';

import '../../../../core/core.dart';
import '../../../../core/services/database_sync_service.dart';
import '../../../domain/domain.dart';
import '../../../domain/usecase/delete_travels_usescases.dart';
import '../../../domain/usecase/get_travel_expense_by_id_use_case.dart';
import '../../../domain/usecase/save_travel_expenses_usecase.dart';
import 'expenses_event.dart';
import 'expenses_state.dart';

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

    final syncService = GetIt.instance<DatabaseSyncService>();
    syncService.initializeWithCallback(() {
      debugPrint('📦 Callback do DatabaseSyncService chamado!');
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

  String sanitizeText(String input) {
    try {
      return const Utf8Decoder().convert(input.codeUnits);
    } catch (_) {
      return input;
    }
  }

  String getStatusText(TravelExpenseEntity expense) {
    if (expense.isReimbursed) return 'Reembolsado';
    return switch (expense.status) {
      'pending_approval' => 'Aguardando Aprovação',
      'past_due' => 'Vencido',
      _ => 'Agendado',
    };
  }

  Color getStatusColor(TravelExpenseEntity expense) {
    if (expense.isReimbursed) return const Color(0xFF4CAF50);
    return switch (expense.status) {
      'pending_approval' => const Color(0xFFFFA000),
      'past_due' => const Color(0xFFF44336),
      _ => const Color(0xFF1A73E8),
    };
  }

  IconData getPaymentMethodIcon(String paymentMethod) {
    return switch (paymentMethod.toLowerCase()) {
      'cartão corporativo' => Icons.credit_card,
      'dinheiro' => Icons.attach_money,
      'aplicativo' => Icons.phone_android,
      _ => Icons.payment,
    };
  }

  IconData getCategoryIcon(String category) {
    return switch (category.toLowerCase()) {
      'transporte' => Icons.directions_car,
      'hospedagem' => Icons.hotel,
      'alimentação' => Icons.restaurant,
      _ => Icons.category,
    };
  }
}
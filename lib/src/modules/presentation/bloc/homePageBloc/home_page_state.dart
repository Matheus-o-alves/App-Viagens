// presentation/bloc/travelExpensesBloc/travel_expenses_state.dart
import 'package:equatable/equatable.dart';
import '../../../domain/domain.dart';

abstract class TravelExpensesState extends Equatable {
  const TravelExpensesState();

  @override
  List<Object?> get props => [];
}

class TravelExpensesInitial extends TravelExpensesState {}

class TravelExpensesLoading extends TravelExpensesState {}

class TravelExpensesLoaded extends TravelExpensesState {
  final List<TravelExpenseEntity> expenses;

  const TravelExpensesLoaded(this.expenses);

  @override
  List<Object?> get props => [expenses];
}

class TravelExpenseDetailsLoaded extends TravelExpensesState {
  final TravelExpenseEntity expense;

  const TravelExpenseDetailsLoaded(this.expense);

  @override
  List<Object?> get props => [expense];
}

class TravelExpenseActionSuccess extends TravelExpensesState {
  final String message;
  final TravelExpensesActionType actionType;

  const TravelExpenseActionSuccess({
    required this.message,
    required this.actionType,
  });

  @override
  List<Object?> get props => [message, actionType];
}

class TravelExpensesError extends TravelExpensesState {
  final String message;

  const TravelExpensesError(this.message);

  @override
  List<Object?> get props => [message];
}

enum TravelExpensesActionType { add, update, delete }
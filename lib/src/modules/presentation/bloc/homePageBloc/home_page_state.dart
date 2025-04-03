import 'package:equatable/equatable.dart';
import '../../../domain/domain.dart';
import '../../../domain/entity/travel_card_entity.dart';

abstract class TravelExpensesState extends Equatable {
  const TravelExpensesState();

  @override
  List<Object?> get props => [];
}

class TravelExpensesInitial extends TravelExpensesState {}

class TravelExpensesLoading extends TravelExpensesState {}

class TravelExpensesLoaded extends TravelExpensesState {
  final List<TravelExpenseEntity> expenses;
  final List<TravelCardEntity> cards;

  const TravelExpensesLoaded(this.expenses, this.cards);

  @override
  List<Object?> get props => [expenses, cards];
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

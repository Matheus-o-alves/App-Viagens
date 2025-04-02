// States
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

class TravelExpensesError extends TravelExpensesState {
  final String message;

  const TravelExpensesError(this.message);

  @override
  List<Object?> get props => [message];
}

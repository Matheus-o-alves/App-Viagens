// Events
import 'package:equatable/equatable.dart';

import '../../../domain/domain.dart';

abstract class TravelExpensesEvent extends Equatable {
  const TravelExpensesEvent();

  @override
  List<Object?> get props => [];
}

class FetchTravelExpenses extends TravelExpensesEvent {
  const FetchTravelExpenses();
}

class RefreshTravelExpenses extends TravelExpensesEvent {
  const RefreshTravelExpenses();
}

class AddTravelExpense extends TravelExpensesEvent {
  final TravelExpenseEntity expense;

  const AddTravelExpense(this.expense);

  @override
  List<Object?> get props => [expense];
}

class UpdateTravelExpense extends TravelExpensesEvent {
  final TravelExpenseEntity expense;

  const UpdateTravelExpense(this.expense);

  @override
  List<Object?> get props => [expense];
}

class DeleteTravelExpense extends TravelExpensesEvent {
  final int expenseId;

  const DeleteTravelExpense(this.expenseId);

  @override
  List<Object?> get props => [expenseId];
}

class GetTravelExpenseDetails extends TravelExpensesEvent {
  final int expenseId;

  const GetTravelExpenseDetails(this.expenseId);

  @override
  List<Object?> get props => [expenseId];
}

class SyncTravelExpenses extends TravelExpensesEvent {
  const SyncTravelExpenses();
}

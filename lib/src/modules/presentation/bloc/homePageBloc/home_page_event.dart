// Events
import 'package:equatable/equatable.dart';

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
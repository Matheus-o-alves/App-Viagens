// domain/entities/travel_expenses_info_entity.dart
import 'package:equatable/equatable.dart';

import 'payments_schedule_entity.dart';

abstract class TravelExpensesInfoEntity extends Equatable {
  final List<TravelExpenseEntity> travelExpenses;

  const TravelExpensesInfoEntity({
    required this.travelExpenses,
  });

  @override
  List<Object?> get props => [travelExpenses];
}
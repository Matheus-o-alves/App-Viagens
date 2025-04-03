import 'package:flutter_test/flutter_test.dart';
import 'package:equatable/equatable.dart';
import 'package:onfly_viagens_app/src/exports.dart';
import 'package:onfly_viagens_app/src/modules/domain/entity/travel_card_entity.dart';

class FakeTravelExpenseEntity extends Equatable implements TravelExpenseEntity {
  @override
  final int id;
  @override
  final DateTime expenseDate;
  @override
  final String description;
  @override
  final String category;
  @override
  final double amount;
  @override
  final String paymentMethod;
  @override
  final bool reimbursable;
  @override
  final bool isReimbursed;
  @override
  final String status;

  const FakeTravelExpenseEntity({
    required this.id,
    required this.expenseDate,
    required this.description,
    required this.category,
    required this.amount,
    required this.paymentMethod,
    required this.reimbursable,
    required this.isReimbursed,
    required this.status,
  });

  @override
  List<Object?> get props =>
      [id, expenseDate, description, category, amount, paymentMethod, reimbursable, isReimbursed, status];
      
        @override
        String get categoria => throw UnimplementedError();
      
        @override
        String get expenseDateFormatted => throw UnimplementedError();
      
        @override
        double get quantidade => throw UnimplementedError();
      
        @override
        bool get reembolsavel => throw UnimplementedError();
}

class FakeTravelCardEntity extends Equatable implements TravelCardEntity {
  @override
  final int id;
  @override
  final String nome;
  @override
  final String numero;
  @override
  final String titular;
  @override
  final String validade;
  @override
  final String bandeira;
  @override
  final double limiteDisponivel;

  const FakeTravelCardEntity({
    required this.id,
    required this.nome,
    required this.numero,
    required this.titular,
    required this.validade,
    required this.bandeira,
    required this.limiteDisponivel,
  });

  @override
  List<Object?> get props => [id, nome, numero, titular, validade, bandeira, limiteDisponivel];
}

void main() {
  group('TravelExpensesEvent tests', () {
    test('FetchTravelExpenses should have empty props', () {
      const event = FetchTravelExpenses();
      expect(event.props, []);
    });

    test('RefreshTravelExpenses should have empty props', () {
      const event = RefreshTravelExpenses();
      expect(event.props, []);
    });

    test('AddTravelExpense should have expense in props', () {
      var fakeExpense = FakeTravelExpenseEntity(
        id: 1,
        expenseDate: DateTime(2023, 5, 10),
        description: 'Test expense',
        category: 'Food',
        amount: 100.0,
        paymentMethod: 'Card',
        reimbursable: true,
        isReimbursed: false,
        status: 'programado',
      );
      final event = AddTravelExpense(fakeExpense);
      expect(event.props, [fakeExpense]);
    });

    test('UpdateTravelExpense should have expense in props', () {
      final fakeExpense = FakeTravelExpenseEntity(
        id: 2,
        expenseDate: DateTime(2023, 5, 11),
        description: 'Another expense',
        category: 'Transport',
        amount: 50.0,
        paymentMethod: 'Cash',
        reimbursable: false,
        isReimbursed: false,
        status: 'programado',
      );
      final event = UpdateTravelExpense(fakeExpense);
      expect(event.props, [fakeExpense]);
    });

    test('DeleteTravelExpense should have expenseId in props', () {
      const event = DeleteTravelExpense(5);
      expect(event.props, [5]);
    });

    test('GetTravelExpenseDetails should have expenseId in props', () {
      const event = GetTravelExpenseDetails(10);
      expect(event.props, [10]);
    });

    test('SyncTravelExpenses should have empty props', () {
      const event = SyncTravelExpenses();
      expect(event.props, []);
    });
  });

  group('TravelExpensesState tests', () {
    test('TravelExpensesInitial should have empty props', () {
      final state = TravelExpensesInitial();
      expect(state.props, []);
    });

    test('TravelExpensesLoading should have empty props', () {
      final state = TravelExpensesLoading();
      expect(state.props, []);
    });

    test('TravelExpensesLoaded should contain expenses and cards in props', () {
      final fakeExpense = FakeTravelExpenseEntity(
        id: 1,
        expenseDate: DateTime(2023, 5, 10),
        description: 'Test expense',
        category: 'Food',
        amount: 100.0,
        paymentMethod: 'Card',
        reimbursable: true,
        isReimbursed: false,
        status: 'programado',
      );
      const fakeCard = FakeTravelCardEntity(
        id: 1,
        nome: 'Card 1',
        numero: '1234',
        titular: 'Test User',
        validade: '12/25',
        bandeira: 'Visa',
        limiteDisponivel: 500.0,
      );
      final state = TravelExpensesLoaded([fakeExpense], [fakeCard]);
      expect(state.props, [
        [fakeExpense],
        [fakeCard],
      ]);
    });

    test('TravelExpenseDetailsLoaded should contain expense in props', () {
      var fakeExpense = FakeTravelExpenseEntity(
        id: 2,
        expenseDate: DateTime(2023, 5, 11),
        description: 'Another expense',
        category: 'Transport',
        amount: 50.0,
        paymentMethod: 'Cash',
        reimbursable: false,
        isReimbursed: false,
        status: 'programado',
      );
      final state = TravelExpenseDetailsLoaded(fakeExpense);
      expect(state.props, [fakeExpense]);
    });

    test('TravelExpenseActionSuccess should contain message and actionType in props', () {
      const state = TravelExpenseActionSuccess(
        message: 'Success',
        actionType: TravelExpensesActionType.add,
      );
      expect(state.props, ['Success', TravelExpensesActionType.add]);
    });

    test('TravelExpensesError should contain message in props', () {
      const state = TravelExpensesError('Error occurred');
      expect(state.props, ['Error occurred']);
    });
  });
}

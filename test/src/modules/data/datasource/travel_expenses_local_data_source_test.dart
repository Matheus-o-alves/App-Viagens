import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:mockito/annotations.dart';

import 'package:onfly_viagens_app/src/exports.dart';
import 'package:onfly_viagens_app/src/modules/data/datasource/travel_expenses_local_data_source.dart';


@GenerateMocks([DatabaseHelper])
import 'travel_expenses_local_data_source_test.mocks.dart';

void main() {
  late TravelExpensesLocalDataSourceImpl localDataSource;
  late MockDatabaseHelper mockDatabaseHelper;

  setUp(() {
    mockDatabaseHelper = MockDatabaseHelper();
    localDataSource = TravelExpensesLocalDataSourceImpl(
      databaseHelper: mockDatabaseHelper,
    );
  });

  group('getTravelExpensesInfo', () {
    final testDate = DateTime(2023, 5, 10);
    
    final tExpenses = [
      TravelExpenseModel(
        id: 1,
        expenseDate: testDate,
        description: 'Teste despesa',
        categoria: 'Alimentação',
        quantidade: 100.0,
        reembolsavel: true,
        isReimbursed: false,
        status: 'pendente',
        paymentMethod: 'Cartão',
      ),
    ];

    final tCards = [
      TravelCardModel(
        id: 1,
        nome: 'Cartão Teste',
        numero: '1234 5678 9012 3456',
        titular: 'Matheus Alves',
        validade: '12/25',
        bandeira: 'Visa',
        limiteDisponivel: 5000.0,
      ),
    ];

    test('deve retornar TravelExpensesInfoEntity quando o banco de dados retornar dados', () async {

      when(mockDatabaseHelper.getAllTravelExpenses())
          .thenAnswer((_) async => tExpenses);
      when(mockDatabaseHelper.getAllTravelCards())
          .thenAnswer((_) async => tCards);

      final result = await localDataSource.getTravelExpensesInfo();

      expect(result, isA<TravelExpensesInfoEntity>());
      expect(result.despesasdeviagem, tExpenses);
      expect(result.cartoes, tCards);
      verify(mockDatabaseHelper.getAllTravelExpenses()).called(1);
      verify(mockDatabaseHelper.getAllTravelCards()).called(1);
    });


  });

  group('saveTravelExpense', () {
    final testDate = DateTime(2023, 5, 10);
    
    final tExpense = TravelExpenseModel(
      id: 0, // Nova despesa
      expenseDate: testDate,
      description: 'Nova despesa',
      categoria: 'Alimentação',
      quantidade: 75.0,
      reembolsavel: true,
      isReimbursed: false,
      status: 'pendente',
      paymentMethod: 'Dinheiro',
    );

    final tExistingExpense = TravelExpenseModel(
      id: 1, 
      expenseDate: testDate,
      description: 'Despesa existente',
      categoria: 'Transporte',
      quantidade: 50.0,
      reembolsavel: false,
      isReimbursed: false,
      status: 'concluído',
      paymentMethod: 'Cartão',
    );

    test('deve chamar insertTravelExpense quando id for 0 (nova despesa)', () async {

      when(mockDatabaseHelper.insertTravelExpense(tExpense))
          .thenAnswer((_) async => 1);

    
      final result = await localDataSource.saveTravelExpense(tExpense);

    
      expect(result, 1);
      verify(mockDatabaseHelper.insertTravelExpense(tExpense)).called(1);
      verifyNever(mockDatabaseHelper.updateTravelExpense(any));
    });

    test('deve chamar updateTravelExpense quando id não for 0 (atualizar despesa)', () async {

      when(mockDatabaseHelper.updateTravelExpense(tExistingExpense))
          .thenAnswer((_) async => 1);

      final result = await localDataSource.saveTravelExpense(tExistingExpense);


      expect(result, 1);
      verify(mockDatabaseHelper.updateTravelExpense(tExistingExpense)).called(1);
      verifyNever(mockDatabaseHelper.insertTravelExpense(any));
    });


  });

  group('deleteTravelExpense', () {
    const tExpenseId = 1;

    test('deve retornar o número de linhas afetadas quando a exclusão for bem-sucedida', () async {

      when(mockDatabaseHelper.deleteTravelExpense(tExpenseId))
          .thenAnswer((_) async => 1);


      final result = await localDataSource.deleteTravelExpense(tExpenseId);

      expect(result, 1);
      verify(mockDatabaseHelper.deleteTravelExpense(tExpenseId)).called(1);
    });


  });

  group('getTravelExpenseById', () {
    const tExpenseId = 1;
    final testDate = DateTime(2023, 5, 10);
    
    final tExpense = TravelExpenseModel(
      id: tExpenseId,
      expenseDate: testDate,
      description: 'Despesa teste',
      categoria: 'Alimentação',
      quantidade: 100.0,
      reembolsavel: true,
      isReimbursed: false,
      status: 'pendente',
      paymentMethod: 'Cartão',
    );

    test('deve retornar TravelExpenseModel quando encontrar a despesa pelo id', () async {
   
      when(mockDatabaseHelper.getTravelExpenseById(tExpenseId))
          .thenAnswer((_) async => tExpense);


      final result = await localDataSource.getTravelExpenseById(tExpenseId);


      expect(result, tExpense);
      verify(mockDatabaseHelper.getTravelExpenseById(tExpenseId)).called(1);
    });

    test('deve retornar null quando não encontrar a despesa pelo id', () async {
 
      when(mockDatabaseHelper.getTravelExpenseById(tExpenseId))
          .thenAnswer((_) async => null);


      final result = await localDataSource.getTravelExpenseById(tExpenseId);


      expect(result, null);
      verify(mockDatabaseHelper.getTravelExpenseById(tExpenseId)).called(1);
    });


  });

  group('syncWithRemote', () {
    final testDate = DateTime(2023, 5, 10);
    
    final tExpenses = [
      TravelExpenseModel(
        id: 1,
        expenseDate: testDate,
        description: 'Teste despesa 1',
        categoria: 'Alimentação',
        quantidade: 100.0,
        reembolsavel: true,
        isReimbursed: false,
        status: 'pendente',
        paymentMethod: 'Cartão',
      ),
      TravelExpenseModel(
        id: 2,
        expenseDate: testDate,
        description: 'Teste despesa 2',
        categoria: 'Transporte',
        quantidade: 50.0,
        reembolsavel: false,
        isReimbursed: false,
        status: 'concluído',
        paymentMethod: 'Dinheiro',
      ),
    ];

    final tCards = [
      TravelCardModel(
        id: 1,
        nome: 'Cartão Teste 1',
        numero: '1234 5678 9012 3456',
        titular: 'Matheus Alves',
        validade: '12/25',
        bandeira: 'Visa',
        limiteDisponivel: 5000.0,
      ),
      TravelCardModel(
        id: 2,
        nome: 'Cartão Teste 2',
        numero: '9876 5432 1098 7654',
        titular: 'Matheus Alves',
        validade: '10/27',
        bandeira: 'Mastercard',
        limiteDisponivel: 8000.0,
      ),
    ];

    final Map<String, dynamic> remoteData = {
      'travelExpenses': tExpenses.map((e) => e.toJson()).toList(),
      'cards': tCards.map((e) => e.toJson()).toList(),
    };

    test('deve chamar batchInsertExpenses e batchInsertCards com os dados corretos', () async {
      when(mockDatabaseHelper.batchInsertExpenses(any))
          .thenAnswer((_) async => [1, 2]);
      when(mockDatabaseHelper.batchInsertCards(any))
          .thenAnswer((_) async => [1, 2]);

  
      await localDataSource.syncWithRemote(remoteData);

      verify(mockDatabaseHelper.batchInsertExpenses(any)).called(1);
      verify(mockDatabaseHelper.batchInsertCards(any)).called(1);
    });


  });
}
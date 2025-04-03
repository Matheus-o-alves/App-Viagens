import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:mockito/mockito.dart';
import 'package:mockito/annotations.dart';
import 'package:onfly_viagens_app/src/exports.dart';

@GenerateMocks([
  SaveTravelExpenseUseCase,
  GetTravelExpenseByIdUseCase,
  TravelExpenseEntity,
  TravelExpenseModel,
])
import 'expense_form_bloc_test.mocks.dart';

void main() {
  late ExpenseFormBloc expenseFormBloc;
  late MockSaveTravelExpenseUseCase mockSaveUseCase;
  late MockGetTravelExpenseByIdUseCase mockGetUseCase;
  late MockTravelExpenseEntity mockExpenseEntity;
  late MockTravelExpenseModel mockExpenseModel;
  
  final testDate = DateTime(2023, 5, 10);
  
  setUp(() {
    mockSaveUseCase = MockSaveTravelExpenseUseCase();
    mockGetUseCase = MockGetTravelExpenseByIdUseCase();
    mockExpenseEntity = MockTravelExpenseEntity();
    mockExpenseModel = MockTravelExpenseModel();
    
    when(mockExpenseEntity.id).thenReturn(1);
    when(mockExpenseEntity.expenseDate).thenReturn(testDate);
    when(mockExpenseEntity.description).thenReturn('Test expense');
    when(mockExpenseEntity.category).thenReturn('Food');
    when(mockExpenseEntity.amount).thenReturn(125.50);
    when(mockExpenseEntity.paymentMethod).thenReturn('Card');
    when(mockExpenseEntity.reimbursable).thenReturn(true);
    when(mockExpenseEntity.isReimbursed).thenReturn(false);
    when(mockExpenseEntity.status).thenReturn('programado');
    
    when(mockExpenseModel.id).thenReturn(1);
    
    expenseFormBloc = ExpenseFormBloc(
      saveTravelExpenseUseCase: mockSaveUseCase,
      getTravelExpenseByIdUseCase: mockGetUseCase,
    );
  });

  tearDown(() {
    expenseFormBloc.close();
  });

  group('ExpenseFormBloc', () {
    test('initial state should be ExpenseFormInitial', () {
      expect(expenseFormBloc.state, isA<ExpenseFormInitial>());
    });

    group('InitializeNewExpense', () {
      blocTest<ExpenseFormBloc, ExpenseFormState>(
        'should emit ExpenseFormLoaded with default values',
        build: () => expenseFormBloc,
        act: (bloc) => bloc.add(const InitializeNewExpense()),
        expect: () => [
          isA<ExpenseFormLoaded>()
              .having((state) => state.expense, 'expense', null)
              .having((state) => state.date, 'date', isA<DateTime>())
              .having((state) => state.description, 'description', '')
              .having((state) => state.category, 'category', TextNormalizer.standardCategories.first)
              .having((state) => state.amount, 'amount', 0.0)
              .having((state) => state.paymentMethod, 'paymentMethod', TextNormalizer.standardPaymentMethods.first)
              .having((state) => state.isReimbursable, 'isReimbursable', true)
              .having((state) => state.categories, 'categories', TextNormalizer.standardCategories)
              .having((state) => state.paymentMethods, 'paymentMethods', TextNormalizer.standardPaymentMethods)
              .having((state) => state.descriptionError, 'descriptionError', null)
              .having((state) => state.amountError, 'amountError', null),
        ],
      );
    });
    
    group('LoadExpense', () {
      blocTest<ExpenseFormBloc, ExpenseFormState>(
        'should emit Loading and then Loaded with expense data when successful',
        build: () {
          when(mockGetUseCase(any)).thenAnswer((_) async => Right(mockExpenseEntity));
          return expenseFormBloc;
        },
        act: (bloc) => bloc.add(const LoadExpense(1)),
        expect: () => [
          isA<ExpenseFormLoading>(),
          isA<ExpenseFormLoaded>()
              .having((state) => state.expense, 'expense', mockExpenseEntity)
              .having((state) => state.description, 'description', 'Test expense')
              .having((state) => state.category, 'category', isA<String>())
              .having((state) => state.amount, 'amount', 125.50),
        ],
        verify: (_) {
          verify(mockGetUseCase(1)).called(1);
        },
      );

      blocTest<ExpenseFormBloc, ExpenseFormState>(
        'should emit Loading and then Error when expense not found',
        build: () {
          when(mockGetUseCase(any)).thenAnswer((_) async => const Right(null));
          return expenseFormBloc;
        },
        act: (bloc) => bloc.add(const LoadExpense(1)),
        expect: () => [
          isA<ExpenseFormLoading>(),
          isA<ExpenseFormError>().having((state) => state.message, 'message', 'Despesa não encontrada'),
        ],
      );

      blocTest<ExpenseFormBloc, ExpenseFormState>(
        'should emit Loading and then Error when use case fails',
        build: () {
          when(mockGetUseCase(any)).thenAnswer((_) async => Left(ServerFailure(message: 'Server error')));
          return expenseFormBloc;
        },
        act: (bloc) => bloc.add(const LoadExpense(1)),
        expect: () => [
          isA<ExpenseFormLoading>(),
          isA<ExpenseFormError>().having((state) => state.message, 'message', 'Erro no servidor'),
        ],
      );
    });

    group('SaveExpense', () {
      blocTest<ExpenseFormBloc, ExpenseFormState>(
        'should emit Saving and then Success when save is successful for new expense',
        build: () {
          when(mockExpenseModel.id).thenReturn(0); 
          when(mockSaveUseCase(any)).thenAnswer((_) async => const Right(1));
          return expenseFormBloc;
        },
        act: (bloc) => bloc.add(SaveExpense(mockExpenseModel)),
        expect: () => [
          isA<ExpenseFormSaving>(),
          isA<ExpenseFormSuccess>()
              .having((state) => state.isNewExpense, 'isNewExpense', true)
              .having((state) => state.message, 'message', 'Despesa adicionada com sucesso'),
        ],
        verify: (_) {
          verify(mockSaveUseCase(mockExpenseModel)).called(1);
        },
      );

      blocTest<ExpenseFormBloc, ExpenseFormState>(
        'should emit Saving and then Success when save is successful for existing expense',
        build: () {
          when(mockExpenseModel.id).thenReturn(1); 
          when(mockSaveUseCase(any)).thenAnswer((_) async => const Right(1));
          return expenseFormBloc;
        },
        act: (bloc) => bloc.add(SaveExpense(mockExpenseModel)),
        expect: () => [
          isA<ExpenseFormSaving>(),
          isA<ExpenseFormSuccess>()
              .having((state) => state.isNewExpense, 'isNewExpense', false)
              .having((state) => state.message, 'message', 'Despesa atualizada com sucesso'),
        ],
      );

      blocTest<ExpenseFormBloc, ExpenseFormState>(
        'should emit Saving and then Error when save fails',
        build: () {
          when(mockSaveUseCase(any)).thenAnswer((_) async => Left(DatabaseFailure(message: 'Database error')));
          return expenseFormBloc;
        },
        act: (bloc) => bloc.add(SaveExpense(mockExpenseModel)),
        expect: () => [
          isA<ExpenseFormSaving>(),
          isA<ExpenseFormError>().having((state) => state.message, 'message', 'Erro no banco de dados: Database error'),
        ],
      );
    });

    group('Field change events', () {
      blocTest<ExpenseFormBloc, ExpenseFormState>(
        'DateChanged should update date in state',
        build: () => expenseFormBloc,
        seed: () => ExpenseFormLoaded(
          expense: null,
          date: DateTime(2023, 1, 1),
          description: '',
          category: 'Food',
          amount: 0,
          paymentMethod: 'Card',
          isReimbursable: true,
          categories: TextNormalizer.standardCategories,
          paymentMethods: TextNormalizer.standardPaymentMethods,
          descriptionError: null,
          amountError: null,
        ),
        act: (bloc) => bloc.add(DateChanged(testDate)),
        expect: () => [
          isA<ExpenseFormLoaded>().having((state) => state.date, 'date', testDate),
        ],
      );

      blocTest<ExpenseFormBloc, ExpenseFormState>(
        'DescriptionChanged should update description and validate',
        build: () => expenseFormBloc,
        seed: () => ExpenseFormLoaded(
          expense: null,
          date: testDate,
          description: '',
          category: 'Food',
          amount: 0,
          paymentMethod: 'Card',
          isReimbursable: true,
          categories: TextNormalizer.standardCategories,
          paymentMethods: TextNormalizer.standardPaymentMethods,
          descriptionError: null,
          amountError: null,
        ),
        act: (bloc) => bloc.add(const DescriptionChanged('New description')),
        expect: () => [
          isA<ExpenseFormLoaded>()
              .having((state) => state.description, 'description', 'New description')
              .having((state) => state.descriptionError, 'descriptionError', null),
        ],
      );

      blocTest<ExpenseFormBloc, ExpenseFormState>(
        'DescriptionChanged should show error when empty',
        build: () => expenseFormBloc,
        seed: () => ExpenseFormLoaded(
          expense: null,
          date: testDate,
          description: 'Some description',
          category: 'Food',
          amount: 0,
          paymentMethod: 'Card',
          isReimbursable: true,
          categories: TextNormalizer.standardCategories,
          paymentMethods: TextNormalizer.standardPaymentMethods,
          descriptionError: null,
          amountError: null,
        ),
        act: (bloc) => bloc.add(const DescriptionChanged('')),
        expect: () => [
          isA<ExpenseFormLoaded>()
              .having((state) => state.description, 'description', '')
              .having((state) => state.descriptionError, 'descriptionError', 'Por favor, informe uma descrição'),
        ],
      );

      blocTest<ExpenseFormBloc, ExpenseFormState>(
        'CategoryChanged should update category',
        build: () => expenseFormBloc,
        seed: () => ExpenseFormLoaded(
          expense: null,
          date: testDate,
          description: 'Test expense',
          category: 'Food',
          amount: 0,
          paymentMethod: 'Card',
          isReimbursable: true,
          categories: TextNormalizer.standardCategories,
          paymentMethods: TextNormalizer.standardPaymentMethods,
          descriptionError: null,
          amountError: null,
        ),
        act: (bloc) => bloc.add(const CategoryChanged('Transport')),
        expect: () => [
          isA<ExpenseFormLoaded>().having((state) => state.category, 'category', 'Transport'),
        ],
      );

      blocTest<ExpenseFormBloc, ExpenseFormState>(
        'AmountChanged should update amount and validate',
        build: () => expenseFormBloc,
        seed: () => ExpenseFormLoaded(
          expense: null,
          date: testDate,
          description: 'Test expense',
          category: 'Food',
          amount: 0,
          paymentMethod: 'Card',
          isReimbursable: true,
          categories: TextNormalizer.standardCategories,
          paymentMethods: TextNormalizer.standardPaymentMethods,
          descriptionError: null,
          amountError: null,
        ),
        act: (bloc) => bloc.add(const AmountChanged('125.50')),
        expect: () => [
          isA<ExpenseFormLoaded>()
              .having((state) => state.amount, 'amount', 125.50)
              .having((state) => state.amountError, 'amountError', null),
        ],
      );

      blocTest<ExpenseFormBloc, ExpenseFormState>(
        'AmountChanged should show error for invalid amount',
        build: () => expenseFormBloc,
        seed: () => ExpenseFormLoaded(
          expense: null,
          date: testDate,
          description: 'Test expense',
          category: 'Food',
          amount: 125.50,
          paymentMethod: 'Card',
          isReimbursable: true,
          categories: TextNormalizer.standardCategories,
          paymentMethods: TextNormalizer.standardPaymentMethods,
          descriptionError: null,
          amountError: null,
        ),
        act: (bloc) => bloc.add(const AmountChanged('abc')),
        expect: () => [
          isA<ExpenseFormLoaded>()
              .having((state) => state.amountError, 'amountError', 'Por favor, informe um número válido'),
        ],
      );

      blocTest<ExpenseFormBloc, ExpenseFormState>(
        'PaymentMethodChanged should update payment method',
        build: () => expenseFormBloc,
        seed: () => ExpenseFormLoaded(
          expense: null,
          date: testDate,
          description: 'Test expense',
          category: 'Food',
          amount: 125.50,
          paymentMethod: 'Card',
          isReimbursable: true,
          categories: TextNormalizer.standardCategories,
          paymentMethods: TextNormalizer.standardPaymentMethods,
          descriptionError: null,
          amountError: null,
        ),
        act: (bloc) => bloc.add(const PaymentMethodChanged('Cash')),
        expect: () => [
          isA<ExpenseFormLoaded>().having((state) => state.paymentMethod, 'paymentMethod', 'Cash'),
        ],
      );

      blocTest<ExpenseFormBloc, ExpenseFormState>(
        'ReimbursableChanged should update isReimbursable',
        build: () => expenseFormBloc,
        seed: () => ExpenseFormLoaded(
          expense: null,
          date: testDate,
          description: 'Test expense',
          category: 'Food',
          amount: 125.50,
          paymentMethod: 'Card',
          isReimbursable: true,
          categories: TextNormalizer.standardCategories,
          paymentMethods: TextNormalizer.standardPaymentMethods,
          descriptionError: null,
          amountError: null,
        ),
        act: (bloc) => bloc.add(const ReimbursableChanged(false)),
        expect: () => [
          isA<ExpenseFormLoaded>().having((state) => state.isReimbursable, 'isReimbursable', false),
        ],
      );
    });

    group('ValidateForm', () {
      blocTest<ExpenseFormBloc, ExpenseFormState>(
        'should validate and show no errors when form is valid',
        build: () => expenseFormBloc,
        seed: () => ExpenseFormLoaded(
          expense: null,
          date: testDate,
          description: 'Test expense',
          category: 'Food',
          amount: 125.50,
          paymentMethod: 'Card',
          isReimbursable: true,
          categories: TextNormalizer.standardCategories,
          paymentMethods: TextNormalizer.standardPaymentMethods,
          descriptionError: null,
          amountError: null,
        ),
        act: (bloc) => bloc.add(const ValidateForm()),
        expect: () => [
          isA<ExpenseFormLoaded>()
              .having((state) => state.descriptionError, 'descriptionError', null)
              .having((state) => state.amountError, 'amountError', null),
        ],
      );

      blocTest<ExpenseFormBloc, ExpenseFormState>(
        'should validate and show errors when description is empty',
        build: () => expenseFormBloc,
        seed: () => ExpenseFormLoaded(
          expense: null,
          date: testDate,
          description: '',
          category: 'Food',
          amount: 125.50,
          paymentMethod: 'Card',
          isReimbursable: true,
          categories: TextNormalizer.standardCategories,
          paymentMethods: TextNormalizer.standardPaymentMethods,
          descriptionError: null,
          amountError: null,
        ),
        act: (bloc) => bloc.add(const ValidateForm()),
        expect: () => [
          isA<ExpenseFormLoaded>()
              .having((state) => state.descriptionError, 'descriptionError', 'Por favor, informe uma descrição')
              .having((state) => state.amountError, 'amountError', null),
        ],
      );

      blocTest<ExpenseFormBloc, ExpenseFormState>(
        'should validate and show errors when amount is zero',
        build: () => expenseFormBloc,
        seed: () => ExpenseFormLoaded(
          expense: null,
          date: testDate,
          description: 'Test expense',
          category: 'Food',
          amount: 0,
          paymentMethod: 'Card',
          isReimbursable: true,
          categories: TextNormalizer.standardCategories,
          paymentMethods: TextNormalizer.standardPaymentMethods,
          descriptionError: null,
          amountError: null,
        ),
        act: (bloc) => bloc.add(const ValidateForm()),
        expect: () => [
          isA<ExpenseFormLoaded>()
              .having((state) => state.descriptionError, 'descriptionError', null)
              .having((state) => state.amountError, 'amountError', 'Por favor, informe um valor maior que zero'),
        ],
      );

      blocTest<ExpenseFormBloc, ExpenseFormState>(
        'should validate and show all errors when form is completely invalid',
        build: () => expenseFormBloc,
        seed: () => ExpenseFormLoaded(
          expense: null,
          date: testDate,
          description: '',
          category: 'Food',
          amount: 0,
          paymentMethod: 'Card',
          isReimbursable: true,
          categories: TextNormalizer.standardCategories,
          paymentMethods: TextNormalizer.standardPaymentMethods,
          descriptionError: null,
          amountError: null,
        ),
        act: (bloc) => bloc.add(const ValidateForm()),
        expect: () => [
          isA<ExpenseFormLoaded>()
              .having((state) => state.descriptionError, 'descriptionError', 'Por favor, informe uma descrição')
              .having((state) => state.amountError, 'amountError', 'Por favor, informe um valor maior que zero'),
        ],
      );
    });

    group('getDisplayText', () {
      test('should return formatted text for special categories', () {
        expect(expenseFormBloc.getDisplayText('Alimentacao'), equals('Alimentação'));
        expect(expenseFormBloc.getDisplayText('Reuniao'), equals('Reunião'));
        expect(expenseFormBloc.getDisplayText('Cartao Corporativo'), equals('Cartão Corporativo'));
        expect(expenseFormBloc.getDisplayText('Transferencia'), equals('Transferência'));
      });

      test('should return the same text for normal categories', () {
        expect(expenseFormBloc.getDisplayText('Food'), equals('Food'));
        expect(expenseFormBloc.getDisplayText('Transport'), equals('Transport'));
      });
    });
  });
}

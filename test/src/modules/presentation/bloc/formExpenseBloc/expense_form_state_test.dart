// expense_form_state_test.dart

import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:onfly_viagens_app/src/exports.dart';

// Gera os mocks para TravelExpenseEntity
@GenerateMocks([TravelExpenseEntity])
import 'expense_form_state_test.mocks.dart';

void main() {
  late MockTravelExpenseEntity mockExpense;
  late DateTime testDate;
  
  setUp(() {
    mockExpense = MockTravelExpenseEntity();
    testDate = DateTime(2023, 5, 10);
  });

  group('ExpenseFormState', () {
    test('ExpenseFormInitial props should be empty', () {
      final state = ExpenseFormInitial();
      expect(state.props, []);
    });

    test('ExpenseFormLoading props should be empty', () {
      final state = ExpenseFormLoading();
      expect(state.props, []);
    });

    group('ExpenseFormReady', () {
      test('props should contain expense', () {
        final state = ExpenseFormReady(expense: mockExpense);
        expect(state.props, [mockExpense]);
      });

      test('props should contain null when expense is null', () {
        final state = ExpenseFormReady(expense: null);
        expect(state.props, [null]);
      });

      test('equality should work with same expense', () {
        final state1 = ExpenseFormReady(expense: mockExpense);
        final state2 = ExpenseFormReady(expense: mockExpense);
        expect(state1, equals(state2));
      });

      test('equality should fail with different expense', () {
        final state1 = ExpenseFormReady(expense: mockExpense);
        final mockExpense2 = MockTravelExpenseEntity();
        final state2 = ExpenseFormReady(expense: mockExpense2);
        expect(state1, isNot(equals(state2)));
      });
    });

    group('ExpenseFormLoaded', () {
      test('props should contain all fields', () {
        final categories = ['Food', 'Transport'];
        final paymentMethods = ['Card', 'Cash'];
        
        final state = ExpenseFormLoaded(
          expense: mockExpense,
          date: testDate,
          description: 'Test expense',
          category: 'Food',
          amount: 125.50,
          paymentMethod: 'Card',
          isReimbursable: true,
          categories: categories,
          paymentMethods: paymentMethods,
          descriptionError: null,
          amountError: null,
        );
        
        expect(state.props, [
          mockExpense,
          testDate,
          'Test expense',
          'Food',
          125.50,
          'Card',
          true,
          categories,
          paymentMethods,
          null,
          null,
        ]);
      });

      test('isValid should return true when no errors', () {
        final state = ExpenseFormLoaded(
          expense: mockExpense,
          date: testDate,
          description: 'Test expense',
          category: 'Food',
          amount: 125.50,
          paymentMethod: 'Card',
          isReimbursable: true,
          categories: ['Food', 'Transport'],
          paymentMethods: ['Card', 'Cash'],
          descriptionError: null,
          amountError: null,
        );
        
        expect(state.isValid, isTrue);
      });

      test('isValid should return false when description error exists', () {
        final state = ExpenseFormLoaded(
          expense: mockExpense,
          date: testDate,
          description: '',
          category: 'Food',
          amount: 125.50,
          paymentMethod: 'Card',
          isReimbursable: true,
          categories: ['Food', 'Transport'],
          paymentMethods: ['Card', 'Cash'],
          descriptionError: 'Description is required',
          amountError: null,
        );
        
        expect(state.isValid, isFalse);
      });

      test('isValid should return false when amount error exists', () {
        final state = ExpenseFormLoaded(
          expense: mockExpense,
          date: testDate,
          description: 'Test expense',
          category: 'Food',
          amount: 0,
          paymentMethod: 'Card',
          isReimbursable: true,
          categories: ['Food', 'Transport'],
          paymentMethods: ['Card', 'Cash'],
          descriptionError: null,
          amountError: 'Amount must be greater than zero',
        );
        
        expect(state.isValid, isFalse);
      });

      test('isValid should return false when both errors exist', () {
        final state = ExpenseFormLoaded(
          expense: mockExpense,
          date: testDate,
          description: '',
          category: 'Food',
          amount: 0,
          paymentMethod: 'Card',
          isReimbursable: true,
          categories: ['Food', 'Transport'],
          paymentMethods: ['Card', 'Cash'],
          descriptionError: 'Description is required',
          amountError: 'Amount must be greater than zero',
        );
        
        expect(state.isValid, isFalse);
      });

      test('equality should work with same data', () {
        final categories1 = ['Food', 'Transport'];
        final paymentMethods1 = ['Card', 'Cash'];
        final categories2 = ['Food', 'Transport'];
        final paymentMethods2 = ['Card', 'Cash'];
        
        final state1 = ExpenseFormLoaded(
          expense: mockExpense,
          date: testDate,
          description: 'Test expense',
          category: 'Food',
          amount: 125.50,
          paymentMethod: 'Card',
          isReimbursable: true,
          categories: categories1,
          paymentMethods: paymentMethods1,
          descriptionError: null,
          amountError: null,
        );
        
        final state2 = ExpenseFormLoaded(
          expense: mockExpense,
          date: testDate,
          description: 'Test expense',
          category: 'Food',
          amount: 125.50,
          paymentMethod: 'Card',
          isReimbursable: true,
          categories: categories2,
          paymentMethods: paymentMethods2,
          descriptionError: null,
          amountError: null,
        );
        
        expect(state1, equals(state2));
      });

      test('equality should fail with different data', () {
        final state1 = ExpenseFormLoaded(
          expense: mockExpense,
          date: testDate,
          description: 'Test expense',
          category: 'Food',
          amount: 125.50,
          paymentMethod: 'Card',
          isReimbursable: true,
          categories: ['Food', 'Transport'],
          paymentMethods: ['Card', 'Cash'],
          descriptionError: null,
          amountError: null,
        );
        
        final state2 = ExpenseFormLoaded(
          expense: mockExpense,
          date: testDate,
          description: 'Different description',
          category: 'Food',
          amount: 125.50,
          paymentMethod: 'Card',
          isReimbursable: true,
          categories: ['Food', 'Transport'],
          paymentMethods: ['Card', 'Cash'],
          descriptionError: null,
          amountError: null,
        );
        
        expect(state1, isNot(equals(state2)));
      });
    });

    group('ExpenseFormSaving', () {
      test('props should be empty', () {
        final state = ExpenseFormSaving();
        expect(state.props, []);
      });
    });

    group('ExpenseFormSuccess', () {
      test('props should contain isNewExpense and message', () {
        final state = ExpenseFormSuccess(
          isNewExpense: true,
          message: 'Expense saved successfully',
        );
        
        expect(state.props, [true, 'Expense saved successfully']);
      });

      test('equality should work with same data', () {
        final state1 = ExpenseFormSuccess(
          isNewExpense: true,
          message: 'Expense saved successfully',
        );
        
        final state2 = ExpenseFormSuccess(
          isNewExpense: true,
          message: 'Expense saved successfully',
        );
        
        expect(state1, equals(state2));
      });

      test('equality should fail with different data', () {
        final state1 = ExpenseFormSuccess(
          isNewExpense: true,
          message: 'Expense saved successfully',
        );
        
        final state2 = ExpenseFormSuccess(
          isNewExpense: false,
          message: 'Expense updated successfully',
        );
        
        expect(state1, isNot(equals(state2)));
      });
    });

    group('ExpenseFormError', () {
      test('props should contain message', () {
        final state = ExpenseFormError('Error message');
        expect(state.props, ['Error message']);
      });

      test('equality should work with same message', () {
        final state1 = ExpenseFormError('Error message');
        final state2 = ExpenseFormError('Error message');
        expect(state1, equals(state2));
      });

      test('equality should fail with different message', () {
        final state1 = ExpenseFormError('Error message 1');
        final state2 = ExpenseFormError('Error message 2');
        expect(state1, isNot(equals(state2)));
      });
    });
  });
}

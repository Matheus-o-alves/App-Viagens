import 'package:flutter_test/flutter_test.dart';
import 'package:onfly_viagens_app/src/exports.dart';

import 'package:mockito/mockito.dart';
import 'package:mockito/annotations.dart';

@GenerateMocks([TravelExpenseModel])
import 'expense_form_event_test.mocks.dart';

void main() {
  late MockTravelExpenseModel mockExpense;
  late DateTime testDate;
  
  setUp(() {
    mockExpense = MockTravelExpenseModel();
    testDate = DateTime(2023, 5, 10);
  });

  group('ExpenseFormEvent', () {
    group('InitializeNewExpense', () {
      test('props should be empty', () {
        const event = InitializeNewExpense();
        expect(event.props, []);
      });

      test('equality should work', () {
        const event1 = InitializeNewExpense();
        const event2 = InitializeNewExpense();
        expect(event1, equals(event2));
      });
    });

    group('LoadExpense', () {
      test('props should contain expenseId', () {
        const event = LoadExpense(123);
        expect(event.props, [123]);
      });

      test('equality should work with same id', () {
        const event1 = LoadExpense(123);
        const event2 = LoadExpense(123);
        expect(event1, equals(event2));
      });

      test('equality should fail with different id', () {
        const event1 = LoadExpense(123);
        const event2 = LoadExpense(456);
        expect(event1, isNot(equals(event2)));
      });
    });

    group('SaveExpense', () {
      test('props should contain expense', () {
        final event = SaveExpense(mockExpense);
        expect(event.props, [mockExpense]);
      });

      test('equality should work with same expense', () {
        final event1 = SaveExpense(mockExpense);
        final event2 = SaveExpense(mockExpense);
        expect(event1, equals(event2));
      });

      test('equality should fail with different expense', () {
        final event1 = SaveExpense(mockExpense);
        final mockExpense2 = MockTravelExpenseModel();
        final event2 = SaveExpense(mockExpense2);
        expect(event1, isNot(equals(event2)));
      });
    });

    group('DateChanged', () {
      test('props should contain date', () {
        final event = DateChanged(testDate);
        expect(event.props, [testDate]);
      });

      test('equality should work with same date', () {
        final date1 = DateTime(2023, 5, 10);
        final date2 = DateTime(2023, 5, 10);
        final event1 = DateChanged(date1);
        final event2 = DateChanged(date2);
        expect(event1, equals(event2));
      });

      test('equality should fail with different date', () {
        final date1 = DateTime(2023, 5, 10);
        final date2 = DateTime(2023, 5, 11);
        final event1 = DateChanged(date1);
        final event2 = DateChanged(date2);
        expect(event1, isNot(equals(event2)));
      });
    });

    group('DescriptionChanged', () {
      test('props should contain description', () {
        const event = DescriptionChanged('Test description');
        expect(event.props, ['Test description']);
      });

      test('equality should work with same description', () {
        const event1 = DescriptionChanged('Test description');
        const event2 = DescriptionChanged('Test description');
        expect(event1, equals(event2));
      });

      test('equality should fail with different description', () {
        const event1 = DescriptionChanged('Test description 1');
        const event2 = DescriptionChanged('Test description 2');
        expect(event1, isNot(equals(event2)));
      });
    });

    group('CategoryChanged', () {
      test('props should contain category', () {
        const event = CategoryChanged('Food');
        expect(event.props, ['Food']);
      });

      test('equality should work with same category', () {
        const event1 = CategoryChanged('Food');
        const event2 = CategoryChanged('Food');
        expect(event1, equals(event2));
      });

      test('equality should fail with different category', () {
        const event1 = CategoryChanged('Food');
        const event2 = CategoryChanged('Transport');
        expect(event1, isNot(equals(event2)));
      });
    });

    group('AmountChanged', () {
      test('props should contain amount', () {
        const event = AmountChanged('125.50');
        expect(event.props, ['125.50']);
      });

      test('equality should work with same amount', () {
        const event1 = AmountChanged('125.50');
        const event2 = AmountChanged('125.50');
        expect(event1, equals(event2));
      });

      test('equality should fail with different amount', () {
        const event1 = AmountChanged('125.50');
        const event2 = AmountChanged('250.00');
        expect(event1, isNot(equals(event2)));
      });
    });

    group('PaymentMethodChanged', () {
      test('props should contain paymentMethod', () {
        const event = PaymentMethodChanged('Card');
        expect(event.props, ['Card']);
      });

      test('equality should work with same payment method', () {
        const event1 = PaymentMethodChanged('Card');
        const event2 = PaymentMethodChanged('Card');
        expect(event1, equals(event2));
      });

      test('equality should fail with different payment method', () {
        const event1 = PaymentMethodChanged('Card');
        const event2 = PaymentMethodChanged('Cash');
        expect(event1, isNot(equals(event2)));
      });
    });

    group('ReimbursableChanged', () {
      test('props should contain isReimbursable', () {
        const event = ReimbursableChanged(true);
        expect(event.props, [true]);
      });

      test('equality should work with same value', () {
        const event1 = ReimbursableChanged(true);
        const event2 = ReimbursableChanged(true);
        expect(event1, equals(event2));
      });

      test('equality should fail with different value', () {
        const event1 = ReimbursableChanged(true);
        const event2 = ReimbursableChanged(false);
        expect(event1, isNot(equals(event2)));
      });
    });

    group('ValidateForm', () {
      test('props should be empty', () {
        const event = ValidateForm();
        expect(event.props, []);
      });

      test('equality should work', () {
        const event1 = ValidateForm();
        const event2 = ValidateForm();
        expect(event1, equals(event2));
      });
    });
  });
}
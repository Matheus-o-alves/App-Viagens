// Mocks generated by Mockito 5.4.5 from annotations
// in onfly_viagens_app/test/src/modules/presentation/bloc/formExpenseBloc/expense_form_state_test.dart.
// Do not manually edit this file.

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:mockito/mockito.dart' as _i1;
import 'package:mockito/src/dummies.dart' as _i3;
import 'package:onfly_viagens_app/src/modules/domain/entity/payments_schedule_entity.dart'
    as _i2;

// ignore_for_file: type=lint
// ignore_for_file: avoid_redundant_argument_values
// ignore_for_file: avoid_setters_without_getters
// ignore_for_file: comment_references
// ignore_for_file: deprecated_member_use
// ignore_for_file: deprecated_member_use_from_same_package
// ignore_for_file: implementation_imports
// ignore_for_file: invalid_use_of_visible_for_testing_member
// ignore_for_file: must_be_immutable
// ignore_for_file: prefer_const_constructors
// ignore_for_file: unnecessary_parenthesis
// ignore_for_file: camel_case_types
// ignore_for_file: subtype_of_sealed_class

class _FakeDateTime_0 extends _i1.SmartFake implements DateTime {
  _FakeDateTime_0(Object parent, Invocation parentInvocation)
    : super(parent, parentInvocation);
}

/// A class which mocks [TravelExpenseEntity].
///
/// See the documentation for Mockito's code generation for more information.
class MockTravelExpenseEntity extends _i1.Mock
    implements _i2.TravelExpenseEntity {
  MockTravelExpenseEntity() {
    _i1.throwOnMissingStub(this);
  }

  @override
  int get id =>
      (super.noSuchMethod(Invocation.getter(#id), returnValue: 0) as int);

  @override
  DateTime get expenseDate =>
      (super.noSuchMethod(
            Invocation.getter(#expenseDate),
            returnValue: _FakeDateTime_0(this, Invocation.getter(#expenseDate)),
          )
          as DateTime);

  @override
  String get description =>
      (super.noSuchMethod(
            Invocation.getter(#description),
            returnValue: _i3.dummyValue<String>(
              this,
              Invocation.getter(#description),
            ),
          )
          as String);

  @override
  String get categoria =>
      (super.noSuchMethod(
            Invocation.getter(#categoria),
            returnValue: _i3.dummyValue<String>(
              this,
              Invocation.getter(#categoria),
            ),
          )
          as String);

  @override
  double get quantidade =>
      (super.noSuchMethod(Invocation.getter(#quantidade), returnValue: 0.0)
          as double);

  @override
  bool get reembolsavel =>
      (super.noSuchMethod(Invocation.getter(#reembolsavel), returnValue: false)
          as bool);

  @override
  bool get isReimbursed =>
      (super.noSuchMethod(Invocation.getter(#isReimbursed), returnValue: false)
          as bool);

  @override
  String get status =>
      (super.noSuchMethod(
            Invocation.getter(#status),
            returnValue: _i3.dummyValue<String>(
              this,
              Invocation.getter(#status),
            ),
          )
          as String);

  @override
  String get paymentMethod =>
      (super.noSuchMethod(
            Invocation.getter(#paymentMethod),
            returnValue: _i3.dummyValue<String>(
              this,
              Invocation.getter(#paymentMethod),
            ),
          )
          as String);

  @override
  String get expenseDateFormatted =>
      (super.noSuchMethod(
            Invocation.getter(#expenseDateFormatted),
            returnValue: _i3.dummyValue<String>(
              this,
              Invocation.getter(#expenseDateFormatted),
            ),
          )
          as String);

  @override
  double get amount =>
      (super.noSuchMethod(Invocation.getter(#amount), returnValue: 0.0)
          as double);

  @override
  String get category =>
      (super.noSuchMethod(
            Invocation.getter(#category),
            returnValue: _i3.dummyValue<String>(
              this,
              Invocation.getter(#category),
            ),
          )
          as String);

  @override
  bool get reimbursable =>
      (super.noSuchMethod(Invocation.getter(#reimbursable), returnValue: false)
          as bool);

  @override
  List<Object?> get props =>
      (super.noSuchMethod(Invocation.getter(#props), returnValue: <Object?>[])
          as List<Object?>);
}

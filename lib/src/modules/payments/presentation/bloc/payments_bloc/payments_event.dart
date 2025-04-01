import 'package:equatable/equatable.dart';

enum PaymentsTab { payments, transactions }

enum PaymentsStatus { initial, loading, loaded, error }


abstract class PaymentsEvent extends Equatable {
  const PaymentsEvent();

  @override
  List<Object> get props => [];
}

class PaymentsTabChanged extends PaymentsEvent {
  final PaymentsTab tab;

  const PaymentsTabChanged(this.tab);

  @override
  List<Object> get props => [tab];
}

class LoadPaymentsEvent extends PaymentsEvent {
}

class UpdateTransactionFilterKeys extends PaymentsEvent {
  final List<String> selectedKeys;

  const UpdateTransactionFilterKeys(this.selectedKeys);

  @override
  List<Object> get props => [selectedKeys];
}
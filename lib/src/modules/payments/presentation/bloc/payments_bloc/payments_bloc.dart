import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:base_project/src/core/core.dart';
import 'package:base_project/src/modules/payments/domain/domain.dart';
import 'package:base_project/src/modules/payments/domain/entity/detail_row_entity.dart';

import 'payments_event.dart';
import 'payments_state.dart';

import 'detail_row_builder.dart';

class PaymentsBloc extends Bloc<PaymentsEvent, PaymentsState> {
  final GetPaymentsUseCase getPaymentsUseCase;

  PaymentsBloc(this.getPaymentsUseCase)
      : super(const PaymentsState(
          selectedTab: PaymentsTab.payments,
        )) {
    on<PaymentsTabChanged>(_onTabChanged);
    on<LoadPaymentsEvent>(_onLoadPayments);
    on<UpdateTransactionFilterKeys>(_onUpdateFilterKeys);
  }

  void _onTabChanged(PaymentsTabChanged event, Emitter<PaymentsState> emit) {
    try {
      emit(state.copyWith(selectedTab: event.tab));
    } catch (e) {
      _handleError(e, emit);
    }
  }

  Future<void> _onLoadPayments(LoadPaymentsEvent event, Emitter<PaymentsState> emit) async {
    try {
      emit(state.copyWith(
        status: PaymentsStatus.loading,
        errorMessage: null,
      ));

      final result = await getPaymentsUseCase();
      
      result.fold(
        (failure) => _handleFailure(failure, emit),
        (paymentsInfo) => _handleSuccess(paymentsInfo, emit),
      );
    } catch (e) {
      _handleError(e, emit);
    }
  }

  void _onUpdateFilterKeys(UpdateTransactionFilterKeys event, Emitter<PaymentsState> emit) {
    try {
      emit(state.copyWith(activeTransactionFilterKeys: event.selectedKeys));
    } catch (e) {
      _handleError(e, emit);
    }
  }

  void _handleSuccess(PaymentsInfoEntity paymentsInfo, Emitter<PaymentsState> emit) {
    try {
      final activeFilterKeys = paymentsInfo.transactionFilter
          .where((f) => f.isDefault)
          .map((f) => f.key)
          .toList();
          
      emit(state.copyWith(
        status: PaymentsStatus.loaded,
        paymentsInfo: paymentsInfo,
        transactionFilter: paymentsInfo.transactionFilter,
        activeTransactionFilterKeys: activeFilterKeys,
        errorMessage: null, 
      ));
    } catch (e) {
      _handleError(e, emit);
    }
  }

  void _handleFailure(Failure failure, Emitter<PaymentsState> emit) {
    emit(state.copyWith(
      status: PaymentsStatus.error,
      errorMessage: failure.message,
    ));
    

  }

  void _handleError(dynamic error, Emitter<PaymentsState> emit) {
    final failure = error is Failure 
        ? error 
        : GenericFailure(error: error);
    
    emit(state.copyWith(
      status: PaymentsStatus.error,
      errorMessage: failure.message,
    ));
    

  }

  List<PaymentsTransactionsEntity> getFilteredTransactions() {
    try {
      final all = state.paymentsInfo?.transactions ?? [];
      final filters = state.activeTransactionFilterKeys;
      return all.where((tx) => filters.contains(tx.paymentType)).toList();
    } catch (e) {
      return [];
      
   
    }
  }

  List<DetailRowData> getTransactionDetailRows(PaymentsTransactionsEntity transaction) {
    try {
      final detailRowBuilder = DetailRowBuilder(state.activeTransactionFilterKeys);
      return detailRowBuilder.buildRows(transaction);
    } catch (e) {
      return [];
      
     
    }
  }
}
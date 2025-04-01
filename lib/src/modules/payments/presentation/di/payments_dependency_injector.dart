import '../../data/data.dart';
import '../../domain/domain.dart';
import '../bloc/payments_bloc/payments_bloc.dart';

import '../../infra/datasource/payments_datasource_impl.dart';


class PaymentsDependencyInjector {

  PaymentsDependencyInjector._();
  
  static PaymentsBloc providePaymentsBloc() {
    final datasource = PaymentsDatasourceImpl();
    final repository = PaymentsRepositoryImpl(datasource);
    final useCase = GetPaymentsUseCase(repository);
    return PaymentsBloc(useCase);
  }
}
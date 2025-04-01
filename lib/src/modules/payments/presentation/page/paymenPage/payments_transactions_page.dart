import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show SystemUiOverlayStyle;
import 'package:flutter_bloc/flutter_bloc.dart' show BlocProvider;
import 'package:flutter_svg/svg.dart';

import '../../bloc/payments_bloc/payments_event.dart';
import 'components/appBar_component.dart';
import 'paymente_page.dart';
import '../../di/payments_dependency_injector.dart';


class PaymentsTransactionsPage extends StatelessWidget {
  const PaymentsTransactionsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: _getSystemUiOverlayStyle(),
      child: Scaffold(
        appBar: _buildAppBar(),
        body: _buildBody(),
      ),
    );
  }


  PreferredSizeWidget _buildAppBar() {
    return DefaultAppBar(
      title: 'Payments',
      actions: [
        Padding(
          padding: const EdgeInsets.only(right: 16),
          child: _buildHelpIcon(),
        ),
      ],
    );
  }

  Widget _buildHelpIcon() {
    return SizedBox(
      width: 24,
      height: 24,
      child: SvgPicture.asset(
        'assets/question_icon.svg',
        fit: BoxFit.contain,
      ),
    );
  }

 
  Widget _buildBody() {
    return BlocProvider(
      create: (_) => PaymentsDependencyInjector.providePaymentsBloc()
        ..add(LoadPaymentsEvent()),
      child: const PaymentsPage(),
    );
  }


  SystemUiOverlayStyle _getSystemUiOverlayStyle() {
    return const SystemUiOverlayStyle(
      statusBarColor: Color(0xFF232F69),
      statusBarIconBrightness: Brightness.light,
    );
  }
}

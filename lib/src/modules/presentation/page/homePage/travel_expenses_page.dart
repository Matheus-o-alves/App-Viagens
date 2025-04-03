import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../exports.dart';
import 'components/expense_loaded_component.dart';


class TravelExpensesPage extends StatelessWidget {
  const TravelExpensesPage({super.key});

  void _navigateToExpenseForm(
    BuildContext context, {
    TravelExpenseEntity? expense,
  }) {
    Navigator.pushNamed(context, AppRoutes.expenseForm, arguments: expense);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Quero Viajar com a Onfly', style: TextStyle(color: Colors.white),),
        backgroundColor: Colors.blueAccent,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              context.read<TravelExpensesBloc>().add(
                const RefreshTravelExpenses(),
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.credit_card),
            onPressed: () => _showFilterOptions(context),
          ),
        ],
      ),
      body: BlocConsumer<TravelExpensesBloc, TravelExpensesState>(
        listener: (context, state) {
          if (state is TravelExpenseActionSuccess) {
            ScaffoldMessenger.of(
              context,
            ).showSnackBar(SnackBar(content: Text(state.message)));
          }
        },
        builder: (context, state) {
          if (state is TravelExpensesLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is TravelExpensesLoaded) {
            return ExpenseLoadedContent(
              expenses: state.expenses,
              onExpenseTap:
                  (expense) =>
                      _navigateToExpenseForm(context, expense: expense),
              onRefresh:
                  () => context.read<TravelExpensesBloc>().add(
                    const RefreshTravelExpenses(),
                  ),
            );
          } else if (state is TravelExpensesError) {
            return Center(child: Text(state.message));
          }
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () {
                    context.read<TravelExpensesBloc>().add(
                      const SyncTravelExpenses(),
                    );
                  },
                  child: const Text('Deseja sincronizar duas despesas?'),
                ),
              ],
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.blueAccent,
        child: const Icon(Icons.add),
        onPressed: () => _navigateToExpenseForm(context),
      ),
    );
  }

  void _showFilterOptions(BuildContext context) {
    final state = context.read<TravelExpensesBloc>().state;
    if (state is! TravelExpensesLoaded) return;
    final cards = state.cards;

    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Center(
                child: Text(
                  'Cartões de Viagem',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
              ),
              const SizedBox(height: 16),
              if (cards.isEmpty)
                const Center(
                  child: Padding(
                    padding: EdgeInsets.all(12.0),
                    child: Text('Nenhum cartão disponível.'),
                  ),
                )
              else
                ...cards.map(
                  (card) => Card(
                    margin: const EdgeInsets.only(bottom: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    elevation: 2,
                    child: ListTile(
                      leading: const Icon(
                        Icons.credit_card,
                        color: Colors.blue,
                      ),
                      title: Text(card.nome),
                      subtitle: Text(
                        'Número: ${card.numero}\nTitular: ${card.titular}',
                        style: const TextStyle(fontSize: 13),
                      ),
                      trailing: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text('Limite'),
                          Text(
                            'R\$ ${card.limiteDisponivel.toStringAsFixed(2)}',
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 13,
                              color: Colors.green,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
            ],
          ),
        );
      },
    );
  }
}

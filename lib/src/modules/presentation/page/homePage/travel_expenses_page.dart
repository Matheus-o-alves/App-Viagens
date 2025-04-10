import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../exports.dart';

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
        automaticallyImplyLeading: false, 
        title: const Text(
          'Quero Viajar com a Onfly',
          style: TextStyle(color: AppColors.white),
        ),
        backgroundColor: AppColors.tagBlue,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh, color: AppColors.white),
            onPressed: () {
              context.read<TravelExpensesBloc>().add(
                const RefreshTravelExpenses(),
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.credit_card, color: AppColors.white),
            onPressed: () => _showFilterOptions(context),
          ),
        ],
      ),
      body: BlocConsumer<TravelExpensesBloc, TravelExpensesState>(
        listener: (context, state) {
          if (state is TravelExpenseActionSuccess) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.message)),
            );
          }
        },
        builder: (context, state) {
          if (state is TravelExpensesLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is TravelExpensesLoaded) {
            return ExpenseLoadedContent(
              expenses: state.expenses,
              onExpenseTap: (expense) => _navigateToExpenseForm(context, expense: expense),
              onRefresh: () => context.read<TravelExpensesBloc>().add(const RefreshTravelExpenses()),
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
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.white,
                  ),
                  onPressed: () {
                    context.read<TravelExpensesBloc>().add(
                      const SyncTravelExpenses(),
                    );
                  },
                  child: const Text(
                    'Deseja vizualizar duas despesas?',
                    style: TextStyle(color: AppColors.tagBlue),
                  ),
                ),
              ],
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: AppColors.tagBlue,
        child: const Icon(Icons.add, color: AppColors.white),
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
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: AppColors.tagBlue,
                  ),
                ),
              ),
              const SizedBox(height: 16),
              if (cards.isEmpty)
                const Center(
                  child: Padding(
                    padding: EdgeInsets.all(12.0),
                    child: Text(
                      'Nenhum cartão disponível.',
                      style: TextStyle(color: AppColors.softGrey),
                    ),
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
                        color: AppColors.tagBlue,
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
                              color: AppColors.greenAccent,
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

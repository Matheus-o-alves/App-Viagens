import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

import '../../../../core/utils/helper_formatter.dart';
import '../../../data/data.dart';
import '../../../domain/entity/entity.dart';
import '../../bloc/formExpenseBLoc/expense_form_bloc.dart';
import '../../bloc/formExpenseBLoc/expense_form_event.dart';
import '../../bloc/formExpenseBLoc/expense_form_state.dart';
import '../../bloc/homePageBloc/home_page_bloc.dart';
import '../../bloc/homePageBloc/home_page_event.dart';

class ExpenseFormPage extends StatefulWidget {
  final TravelExpenseEntity? expense;

  const ExpenseFormPage({Key? key, this.expense}) : super(key: key);

  @override
  State<ExpenseFormPage> createState() => _ExpenseFormPageState();
}

class _ExpenseFormPageState extends State<ExpenseFormPage> {
  final _formKey = GlobalKey<FormState>();
  late DateTime _selectedDate;
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _amountController = TextEditingController();

  final List<String> _categories = TextNormalizer.standardCategories;
  final List<String> _paymentMethods = TextNormalizer.standardPaymentMethods;

  late String _selectedCategory;
  late String _selectedPaymentMethod;
  bool _isReimbursable = true;
  
  // Flag para rastrear se já inicializamos o formulário
  bool _formInitialized = false;
  // Armazenar o último estado para inicialização segura
  TravelExpenseEntity? _lastExpenseState;

  @override
  void initState() {
    super.initState();
    // Inicialização com valores padrão
    _selectedCategory = _categories.first;
    _selectedPaymentMethod = _paymentMethods.first;
    _selectedDate = DateTime.now();

    if (widget.expense != null) {
      // Apenas carregue a despesa do repositório
      context.read<ExpenseFormBloc>().add(LoadExpense(widget.expense!.id));
    } else {
      context.read<ExpenseFormBloc>().add(const InitializeNewExpense());
    }

    // Adicione um callback pós-frame para inicializar o formulário se necessário
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _applyPendingExpenseUpdate();
    });
  }

  // Método para aplicar atualizações pendentes após o frame ser renderizado
  void _applyPendingExpenseUpdate() {
    if (!_formInitialized && _lastExpenseState != null) {
      setState(() {
        _initializeFormWithExpense(_lastExpenseState!);
        _formInitialized = true;
      });
    }
  }

  // Inicializa o formulário com dados da despesa sem usar setState diretamente
  void _initializeFormWithExpense(TravelExpenseEntity expense) {
    _selectedDate = expense.expenseDate;
    _descriptionController.text = expense.description;
    _amountController.text = expense.amount.toString();

    final normalizedCategory = TextNormalizer.normalize(expense.category);
    if (_categories.contains(normalizedCategory)) {
      _selectedCategory = normalizedCategory;
    }

    final normalizedPaymentMethod = TextNormalizer.normalize(expense.paymentMethod);
    if (_paymentMethods.contains(normalizedPaymentMethod)) {
      _selectedPaymentMethod = normalizedPaymentMethod;
    }

    _isReimbursable = expense.reimbursable;
  }

  @override
  void dispose() {
    _descriptionController.dispose();
    _amountController.dispose();
    super.dispose();
  }

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      final double amount = double.parse(_amountController.text.replaceAll(',', '.'));

      // Criar o modelo usando o novo formato de dados
      final TravelExpenseModel expense = TravelExpenseModel(
        id: widget.expense?.id ?? 0,
        expenseDate: _selectedDate,
        description: _descriptionController.text,
        categoria: _selectedCategory,
        quantidade: amount,
        reembolsavel: _isReimbursable,
        isReimbursed: widget.expense?.isReimbursed ?? false,
        status: widget.expense?.status ?? 'programado',
        paymentMethod: _selectedPaymentMethod,
      );

      context.read<ExpenseFormBloc>().add(SaveExpense(expense));
    }
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2020),
      lastDate: DateTime.now().add(const Duration(days: 365)),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.light(primary: Theme.of(context).primaryColor),
          ),
          child: child!,
        );
      },
    );

    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.expense == null ? 'Adicionar Despesa' : 'Editar Despesa',
          style: const TextStyle(color: Colors.white),
        ),
        backgroundColor: const Color(0xFF1A73E8),
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: BlocConsumer<ExpenseFormBloc, ExpenseFormState>(
        listener: (context, state) {
          if (state is ExpenseFormSuccess) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: Colors.green,
              ),
            );

            context.read<TravelExpensesBloc>().add(const RefreshTravelExpenses());

            if (mounted) {
              Navigator.pop(context);
            }
          } else if (state is ExpenseFormError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: Colors.red,
              ),
            );
          } else if (state is ExpenseFormReady && state.expense != null && !_formInitialized) {
            // Armazene o estado para aplicá-lo após o frame ser renderizado
            _lastExpenseState = state.expense;
            
            // Use addPostFrameCallback para aplicar a atualização após o build atual
            WidgetsBinding.instance.addPostFrameCallback((_) {
              _applyPendingExpenseUpdate();
            });
          }
        },
        builder: (context, state) {
          if (state is ExpenseFormLoading) {
            return const Center(child: CircularProgressIndicator());
          }
          if (state is ExpenseFormSaving) {
            return const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(),
                  SizedBox(height: 16),
                  Text('Salvando despesa...'),
                ],
              ),
            );
          }

          return Form(
            key: _formKey,
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  InkWell(
                    onTap: () => _selectDate(context),
                    child: InputDecorator(
                      decoration: const InputDecoration(
                        labelText: 'Data',
                        border: OutlineInputBorder(),
                        suffixIcon: Icon(Icons.calendar_today),
                      ),
                      child: Text(DateFormat('dd/MM/yyyy').format(_selectedDate)),
                    ),
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _descriptionController,
                    decoration: const InputDecoration(
                      labelText: 'Descrição',
                      border: OutlineInputBorder(),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Por favor, informe uma descrição';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),
                  DropdownButtonFormField<String>(
                    value: _selectedCategory,
                    decoration: const InputDecoration(
                      labelText: 'Categoria',
                      border: OutlineInputBorder(),
                    ),
                    items: _categories.map((category) {
                      return DropdownMenuItem(
                        value: category,
                        child: Text(_getDisplayText(category)),
                      );
                    }).toList(),
                    onChanged: (value) {
                      if (value != null) {
                        setState(() {
                          _selectedCategory = value;
                        });
                      }
                    },
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _amountController,
                    decoration: const InputDecoration(
                      labelText: 'Valor',
                      border: OutlineInputBorder(),
                      prefixText: 'R\$ ',
                    ),
                    keyboardType: const TextInputType.numberWithOptions(decimal: true),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Por favor, informe um valor';
                      }
                      try {
                        double.parse(value.replaceAll(',', '.'));
                      } catch (_) {
                        return 'Por favor, informe um número válido';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),
                  DropdownButtonFormField<String>(
                    value: _selectedPaymentMethod,
                    decoration: const InputDecoration(
                      labelText: 'Método de Pagamento',
                      border: OutlineInputBorder(),
                    ),
                    items: _paymentMethods.map((method) {
                      return DropdownMenuItem(
                        value: method,
                        child: Text(_getDisplayText(method)),
                      );
                    }).toList(),
                    onChanged: (value) {
                      if (value != null) {
                        setState(() {
                          _selectedPaymentMethod = value;
                        });
                      }
                    },
                  ),
                  const SizedBox(height: 16),
                  SwitchListTile(
                    title: const Text('Reembolsável'),
                    subtitle: const Text('Esta despesa é reembolsável?'),
                    value: _isReimbursable,
                    activeColor: Theme.of(context).primaryColor,
                    onChanged: (bool value) {
                      setState(() {
                        _isReimbursable = value;
                      });
                    },
                    contentPadding: EdgeInsets.zero,
                  ),
                  const SizedBox(height: 24),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: _submitForm,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Theme.of(context).primaryColor,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                      ),
                      child: Text(widget.expense == null ? 'Adicionar Despesa' : 'Salvar Alterações'),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  String _getDisplayText(String normalizedText) {
    switch (normalizedText) {
      case 'Alimentacao':
        return 'Alimentação';
      case 'Reuniao':
        return 'Reunião';
      case 'Cartao Corporativo':
        return 'Cartão Corporativo';
      case 'Transferencia':
        return 'Transferência';
      default:
        return normalizedText;
    }
  }
}
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

import '../../../../../exports.dart';

class ExpenseForm extends StatefulWidget {
  final ExpenseFormLoaded state;

  const ExpenseForm({super.key, required this.state});

  @override
  State<ExpenseForm> createState() => _ExpenseFormState();
}

class _ExpenseFormState extends State<ExpenseForm> {
  final _descriptionController = TextEditingController();
  final _amountController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    _initializeControllers();
    
    _descriptionController.addListener(_onDescriptionChanged);
    _amountController.addListener(_onAmountChanged);
  }

  void _initializeControllers() {
    _descriptionController.text = widget.state.description;
    _amountController.text = widget.state.amount > 0 
        ? widget.state.amount.toString() 
        : '';
  }

  @override
  void didUpdateWidget(ExpenseForm oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.state.description != widget.state.description) {
      _descriptionController.text = widget.state.description;
    }
    if (oldWidget.state.amount != widget.state.amount) {
      _amountController.text = widget.state.amount > 0 
          ? widget.state.amount.toString() 
          : '';
    }
  }

  void _onDescriptionChanged() {
    context.read<ExpenseFormBloc>().add(
      DescriptionChanged(_descriptionController.text),
    );
  }

  void _onAmountChanged() {
    context.read<ExpenseFormBloc>().add(
      AmountChanged(_amountController.text),
    );
  }

  @override
  void dispose() {
    _descriptionController.dispose();
    _amountController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final _ = context.read<ExpenseFormBloc>();
    final state = widget.state;
    
    return Form(
      key: _formKey,
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildDatePicker(context, state),
            const SizedBox(height: 16),
            _buildDescriptionField(state),
            const SizedBox(height: 16),
            _buildCategoryDropdown(context, state),
            const SizedBox(height: 16),
            _buildAmountField(state),
            const SizedBox(height: 16),
            _buildPaymentMethodDropdown(context, state),
            const SizedBox(height: 16),
            _buildReimbursableSwitch(context, state),
            const SizedBox(height: 24),
            _buildSubmitButton(context),
          ],
        ),
      ),
    );
  }

  Widget _buildDatePicker(BuildContext context, ExpenseFormLoaded state) {
    return InkWell(
      onTap: () => _selectDate(context),
      child: InputDecorator(
        decoration: const InputDecoration(
          labelText: 'Data',
          border: OutlineInputBorder(),
          suffixIcon: Icon(Icons.calendar_today),
        ),
        child: Text(DateFormat('dd/MM/yyyy').format(state.date)),
      ),
    );
  }

  Future<void> _selectDate(BuildContext context) async {
    final bloc = context.read<ExpenseFormBloc>();
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: widget.state.date,
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

    if (picked != null) {
      bloc.add(DateChanged(picked));
    }
  }

  Widget _buildDescriptionField(ExpenseFormLoaded state) {
    return TextFormField(
      controller: _descriptionController,
      decoration: InputDecoration(
        labelText: 'Descrição',
        border: const OutlineInputBorder(),
        errorText: state.descriptionError,
      ),
    );
  }

  Widget _buildCategoryDropdown(BuildContext context, ExpenseFormLoaded state) {
    final bloc = context.read<ExpenseFormBloc>();
    
    return DropdownButtonFormField<String>(
      value: state.category,
      decoration: const InputDecoration(
        labelText: 'Categoria',
        border: OutlineInputBorder(),
      ),
      items: state.categories.map((category) {
        return DropdownMenuItem(
          value: category,
          child: Text(bloc.getDisplayText(category)),
        );
      }).toList(),
      onChanged: (value) {
        if (value != null) {
          bloc.add(CategoryChanged(value));
        }
      },
    );
  }

  Widget _buildAmountField(ExpenseFormLoaded state) {
    return TextFormField(
      controller: _amountController,
      decoration: InputDecoration(
        labelText: 'Valor',
        border: const OutlineInputBorder(),
        prefixText: 'R\$ ',
        errorText: state.amountError,
      ),
      keyboardType: const TextInputType.numberWithOptions(decimal: true),
    );
  }

  Widget _buildPaymentMethodDropdown(BuildContext context, ExpenseFormLoaded state) {
    final bloc = context.read<ExpenseFormBloc>();
    
    return DropdownButtonFormField<String>(
      value: state.paymentMethod,
      decoration: const InputDecoration(
        labelText: 'Método de Pagamento',
        border: OutlineInputBorder(),
      ),
      items: state.paymentMethods.map((method) {
        return DropdownMenuItem(
          value: method,
          child: Text(bloc.getDisplayText(method)),
        );
      }).toList(),
      onChanged: (value) {
        if (value != null) {
          bloc.add(PaymentMethodChanged(value));
        }
      },
    );
  }

  Widget _buildReimbursableSwitch(BuildContext context, ExpenseFormLoaded state) {
    final bloc = context.read<ExpenseFormBloc>();
    
    return SwitchListTile(
      title: const Text('Reembolsável'),
      subtitle: const Text('Esta despesa é reembolsável?'),
      value: state.isReimbursable,
      activeColor: Theme.of(context).primaryColor,
      onChanged: (bool value) {
        bloc.add(ReimbursableChanged(value));
      },
      contentPadding: EdgeInsets.zero,
    );
  }

  Widget _buildSubmitButton(BuildContext context) {
    final bloc = context.read<ExpenseFormBloc>();
    
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: () {
          bloc.add(const ValidateForm());
          
          bloc.add(SaveExpense(
            TravelExpenseModel(
              id: widget.state.expense?.id ?? 0,
              expenseDate: widget.state.date,
              description: _descriptionController.text,
              categoria: widget.state.category,
              quantidade: double.tryParse(_amountController.text.replaceAll(',', '.')) ?? 0,
              reembolsavel: widget.state.isReimbursable,
              isReimbursed: widget.state.expense?.isReimbursed ?? false,
              status: widget.state.expense?.status ?? 'programado',
              paymentMethod: widget.state.paymentMethod,
            ),
          ));
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: Theme.of(context).primaryColor,
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        ),
        child: Text(widget.state.expense == null ? 'Adicionar Despesa' : 'Salvar Alterações'),
      ),
    );
  }
}
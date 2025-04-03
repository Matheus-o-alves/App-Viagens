import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../exports.dart';





class ExpenseFormBloc extends Bloc<ExpenseFormEvent, ExpenseFormState> {
  final SaveTravelExpenseUseCase saveTravelExpenseUseCase;
  final GetTravelExpenseByIdUseCase getTravelExpenseByIdUseCase;
  
  DateTime _selectedDate = DateTime.now();
  String _description = '';
  String _category = '';
  double _amount = 0.0;
  String _paymentMethod = '';
  bool _isReimbursable = true;
  bool _isReimbursed = false;
  String _status = 'programado';
  int _id = 0;
  
  String? _descriptionError;
  String? _amountError;
  
  final List<String> categories = TextNormalizer.standardCategories;
  final List<String> paymentMethods = TextNormalizer.standardPaymentMethods;

  ExpenseFormBloc({
    required this.saveTravelExpenseUseCase,
    required this.getTravelExpenseByIdUseCase,
  }) : super(ExpenseFormInitial()) {
    on<InitializeNewExpense>(_onInitializeNewExpense);
    on<LoadExpense>(_onLoadExpense);
    on<SaveExpense>(_onSaveExpense);
    on<DateChanged>(_onDateChanged);
    on<DescriptionChanged>(_onDescriptionChanged);
    on<CategoryChanged>(_onCategoryChanged);
    on<AmountChanged>(_onAmountChanged);
    on<PaymentMethodChanged>(_onPaymentMethodChanged);
    on<ReimbursableChanged>(_onReimbursableChanged);
    on<ValidateForm>(_onValidateForm);
  }

  Future<void> _onInitializeNewExpense(
    InitializeNewExpense event,
    Emitter<ExpenseFormState> emit,
  ) async {
    _resetForm();
    
    _category = categories.first;
    _paymentMethod = paymentMethods.first;
    
    emit(ExpenseFormLoaded(
      expense: null,
      date: _selectedDate,
      description: _description,
      category: _category,
      amount: _amount,
      paymentMethod: _paymentMethod,
      isReimbursable: _isReimbursable,
      categories: categories,
      paymentMethods: paymentMethods,
      descriptionError: null,
      amountError: null,
    ));
  }
  
  void _resetForm() {
    _id = 0;
    _selectedDate = DateTime.now();
    _description = '';
    _category = categories.first;
    _amount = 0.0;
    _paymentMethod = paymentMethods.first;
    _isReimbursable = true;
    _isReimbursed = false;
    _status = 'programado';
    _descriptionError = null;
    _amountError = null;
  }

  Future<void> _onLoadExpense(
    LoadExpense event,
    Emitter<ExpenseFormState> emit,
  ) async {
    emit(ExpenseFormLoading());
    
    final result = await getTravelExpenseByIdUseCase(event.expenseId);
    
    result.fold(
      (failure) => emit(ExpenseFormError(_mapFailureToMessage(failure))),
      (expense) {
        if (expense != null) {
          _id = expense.id;
          _selectedDate = expense.expenseDate;
          _description = expense.description;
          _category = _normalizeCategoryFromExpense(expense);
          _amount = expense.amount;
          _paymentMethod = _normalizePaymentMethodFromExpense(expense);
          _isReimbursable = expense.reimbursable;
          _isReimbursed = expense.isReimbursed;
          _status = expense.status;
          
          emit(ExpenseFormLoaded(
            expense: expense,
            date: _selectedDate,
            description: _description,
            category: _category,
            amount: _amount,
            paymentMethod: _paymentMethod,
            isReimbursable: _isReimbursable,
            categories: categories,
            paymentMethods: paymentMethods,
            descriptionError: null,
            amountError: null,
          ));
        } else {
          emit(const ExpenseFormError('Despesa não encontrada'));
        }
      },
    );
  }
  
  String _normalizeCategoryFromExpense(TravelExpenseEntity expense) {
    final normalizedCategory = TextNormalizer.normalize(expense.category);
    return categories.contains(normalizedCategory) 
        ? normalizedCategory 
        : categories.first;
  }
  
  String _normalizePaymentMethodFromExpense(TravelExpenseEntity expense) {
    final normalizedMethod = TextNormalizer.normalize(expense.paymentMethod);
    return paymentMethods.contains(normalizedMethod) 
        ? normalizedMethod 
        : paymentMethods.first;
  }

  Future<void> _onSaveExpense(
    SaveExpense event,
    Emitter<ExpenseFormState> emit,
  ) async {
    final bool isValid = _validateFormFields();
    
    if (!isValid) {
      emit(ExpenseFormLoaded(
        expense: event.expense,
        date: _selectedDate,
        description: _description,
        category: _category,
        amount: _amount,
        paymentMethod: _paymentMethod,
        isReimbursable: _isReimbursable,
        categories: categories,
        paymentMethods: paymentMethods,
        descriptionError: _descriptionError,
        amountError: _amountError,
      ));
      return;
    }
    
    emit(ExpenseFormSaving());
    
    final isNewExpense = _id == 0;
    
    final expense = TravelExpenseModel(
      id: _id,
      expenseDate: _selectedDate,
      description: _description,
      categoria: _category,
      quantidade: _amount,
      reembolsavel: _isReimbursable,
      isReimbursed: _isReimbursed,
      status: _status,
      paymentMethod: _paymentMethod,
    );
    
    final result = await saveTravelExpenseUseCase(expense);
    
    result.fold(
      (failure) => emit(ExpenseFormError(_mapFailureToMessage(failure))),
      (id) => emit(ExpenseFormSuccess(
        isNewExpense: isNewExpense,
        message: isNewExpense 
            ? 'Despesa adicionada com sucesso'
            : 'Despesa atualizada com sucesso',
      )),
    );
  }
  
  void _onDateChanged(
    DateChanged event, 
    Emitter<ExpenseFormState> emit
  ) {
    _selectedDate = event.date;
    emit(_getCurrentFormState());
  }
  
  void _onDescriptionChanged(
    DescriptionChanged event, 
    Emitter<ExpenseFormState> emit
  ) {
    _description = event.description;
    _descriptionError = _description.isEmpty ? 'Por favor, informe uma descrição' : null;
    emit(_getCurrentFormState());
  }
  
  void _onCategoryChanged(
    CategoryChanged event, 
    Emitter<ExpenseFormState> emit
  ) {
    _category = event.category;
    emit(_getCurrentFormState());
  }
  
  void _onAmountChanged(
    AmountChanged event, 
    Emitter<ExpenseFormState> emit
  ) {
    try {
      _amount = double.parse(event.amount.replaceAll(',', '.'));
      _amountError = null;
    } catch (_) {
      _amountError = 'Por favor, informe um número válido';
    }
    emit(_getCurrentFormState());
  }
  
  void _onPaymentMethodChanged(
    PaymentMethodChanged event, 
    Emitter<ExpenseFormState> emit
  ) {
    _paymentMethod = event.paymentMethod;
    emit(_getCurrentFormState());
  }
  
  void _onReimbursableChanged(
    ReimbursableChanged event, 
    Emitter<ExpenseFormState> emit
  ) {
    _isReimbursable = event.isReimbursable;
    emit(_getCurrentFormState());
  }
  
  void _onValidateForm(
    ValidateForm event,
    Emitter<ExpenseFormState> emit
  ) {
    final bool _ = _validateFormFields();
    emit(_getCurrentFormState());
  }
  
  bool _validateFormFields() {
    _descriptionError = _description.isEmpty ? 'Por favor, informe uma descrição' : null;
    
    _amountError = _amount <= 0 ? 'Por favor, informe um valor maior que zero' : null;
    
    return _descriptionError == null && _amountError == null;
  }
  
  ExpenseFormLoaded _getCurrentFormState() {
    return ExpenseFormLoaded(
      expense: null, 
      date: _selectedDate,
      description: _description,
      category: _category,
      amount: _amount,
      paymentMethod: _paymentMethod,
      isReimbursable: _isReimbursable,
      categories: categories,
      paymentMethods: paymentMethods,
      descriptionError: _descriptionError,
      amountError: _amountError,
    );
  }

  String _mapFailureToMessage(Failure failure) {
    switch (failure.runtimeType) {
      case const (ServerFailure):
        return 'Erro no servidor';
      case const (ConnectionFailure):
        return 'Sem conexão com a internet';
      case const (DatabaseFailure):
        return 'Erro no banco de dados: ${failure.message}';
      default:
        return 'Ocorreu um erro inesperado';
    }
  }
  
  String getDisplayText(String normalizedText) {
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
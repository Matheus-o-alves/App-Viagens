import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/get_it.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:onfly_viagens_app/src/exports.dart';
import 'package:onfly_viagens_app/src/modules/domain/entity/travel_card_entity.dart';

@GenerateMocks([
  GetTravelExpensesUseCase,
  SaveTravelExpenseUseCase,
  DeleteTravelExpenseUseCase,
  GetTravelExpenseByIdUseCase,
  TravelExpenseEntity,
  TravelCardEntity,
])
import 'expenses_bloc_test.mocks.dart';

class MockDatabaseSyncService extends Mock implements DatabaseSyncService {
  Function? syncCallback;

  @override
  void initializeWithCallback(Function callback) {
    syncCallback = callback;
  }
}

class FakeTravelExpensesInfoEntity extends TravelExpensesInfoEntity {
  const FakeTravelExpensesInfoEntity({
    required List<TravelExpenseEntity> despesasdeviagem,
    required List<TravelCardEntity> cartoes,
  }) : super(despesasdeviagem: despesasdeviagem, cartoes: cartoes);
}

class TestTravelExpensesBloc
    extends Bloc<TravelExpensesEvent, TravelExpensesState> {
  final GetTravelExpensesUseCase getTravelExpensesUseCase;
  final SaveTravelExpenseUseCase saveTravelExpenseUseCase;
  final DeleteTravelExpenseUseCase deleteTravelExpenseUseCase;
  final GetTravelExpenseByIdUseCase getTravelExpenseByIdUseCase;

  TestTravelExpensesBloc({
    required this.getTravelExpensesUseCase,
    required this.saveTravelExpenseUseCase,
    required this.deleteTravelExpenseUseCase,
    required this.getTravelExpenseByIdUseCase,
  }) : super(TravelExpensesInitial()) {
    on<FetchTravelExpenses>(_onFetchTravelExpenses); // Adicionar este manipulador
    on<RefreshTravelExpenses>(_onRefreshTravelExpenses); // Adicionar este manipulador
    on<AddTravelExpense>(_onAddTravelExpense);
    on<UpdateTravelExpense>(_onUpdateTravelExpense);
    on<DeleteTravelExpense>(_onDeleteTravelExpense);
    on<GetTravelExpenseDetails>(_onGetTravelExpenseDetails);
    on<SyncTravelExpenses>(_onSyncTravelExpenses);
  }

  // Adicionar este método
  Future<void> _onFetchTravelExpenses(
    FetchTravelExpenses event,
    Emitter<TravelExpensesState> emit,
  ) async {
    emit(TravelExpensesLoading());
    final result = await getTravelExpensesUseCase(NoParams());

    result.fold(
      (failure) => emit(TravelExpensesError(_mapFailureToMessage(failure))),
      (info) {
        final sortedExpenses = List<TravelExpenseEntity>.from(info.despesasdeviagem)
          ..sort((a, b) => b.expenseDate.compareTo(a.expenseDate));
        emit(TravelExpensesLoaded(
          sortedExpenses, 
          List<TravelCardEntity>.from(info.cartoes)
        ));
      },
    );
  }

  // Adicionar este método
  Future<void> _onRefreshTravelExpenses(
    RefreshTravelExpenses event,
    Emitter<TravelExpensesState> emit,
  ) async {
    emit(TravelExpensesLoading());
    final result = await getTravelExpensesUseCase(NoParams());

    result.fold(
      (failure) => emit(TravelExpensesError(_mapFailureToMessage(failure))),
      (info) {
        final sortedExpenses = List<TravelExpenseEntity>.from(info.despesasdeviagem)
          ..sort((a, b) => b.expenseDate.compareTo(a.expenseDate));
        emit(TravelExpensesLoaded(
          sortedExpenses, 
          List<TravelCardEntity>.from(info.cartoes)
        ));
      },
    );
  }

  Future<void> _onSyncTravelExpenses(
    SyncTravelExpenses event,
    Emitter<TravelExpensesState> emit,
  ) async {
    add(const FetchTravelExpenses());
  }

  Future<void> _onAddTravelExpense(
    AddTravelExpense event,
    Emitter<TravelExpensesState> emit,
  ) async {
    emit(TravelExpensesLoading());
    final result = await saveTravelExpenseUseCase(event.expense);

    result.fold(
      (failure) => emit(TravelExpensesError(_mapFailureToMessage(failure))),
      (_) {
        add(const FetchTravelExpenses());
        emit(
          const TravelExpenseActionSuccess(
            message: 'Expense added successfully',
            actionType: TravelExpensesActionType.add,
          ),
        );
      },
    );
  }

  Future<void> _onUpdateTravelExpense(
    UpdateTravelExpense event,
    Emitter<TravelExpensesState> emit,
  ) async {
    emit(TravelExpensesLoading());
    final result = await saveTravelExpenseUseCase(event.expense);

    result.fold(
      (failure) => emit(TravelExpensesError(_mapFailureToMessage(failure))),
      (_) {
        add(const FetchTravelExpenses());
        emit(
          const TravelExpenseActionSuccess(
            message: 'Expense updated successfully',
            actionType: TravelExpensesActionType.update,
          ),
        );
      },
    );
  }

  Future<void> _onDeleteTravelExpense(
    DeleteTravelExpense event,
    Emitter<TravelExpensesState> emit,
  ) async {
    emit(TravelExpensesLoading());
    final result = await deleteTravelExpenseUseCase(event.expenseId);

    result.fold(
      (failure) => emit(TravelExpensesError(_mapFailureToMessage(failure))),
      (_) {
        add(const FetchTravelExpenses());
        emit(
          const TravelExpenseActionSuccess(
            message: 'Expense deleted successfully',
            actionType: TravelExpensesActionType.delete,
          ),
        );
      },
    );
  }

  Future<void> _onGetTravelExpenseDetails(
    GetTravelExpenseDetails event,
    Emitter<TravelExpensesState> emit,
  ) async {
    emit(TravelExpensesLoading());
    final result = await getTravelExpenseByIdUseCase(event.expenseId);

    result.fold(
      (failure) => emit(TravelExpensesError(_mapFailureToMessage(failure))),
      (expense) {
        if (expense != null) {
          emit(TravelExpenseDetailsLoaded(expense));
        } else {
          emit(const TravelExpensesError('Expense not found'));
        }
      },
    );
  }

  String _mapFailureToMessage(Failure failure) {
    switch (failure.runtimeType) {
      case const (ServerFailure):
        return 'Server error occurred';
      case const (ConnectionFailure):
        return 'No internet connection';
      case const (DatabaseFailure):
        return 'Database error: ${failure.message}';
      default:
        return 'An unexpected error occurred';
    }
  }
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late TestTravelExpensesBloc bloc;
  late MockGetTravelExpensesUseCase mockGetTravelExpensesUseCase;
  late MockSaveTravelExpenseUseCase mockSaveTravelExpenseUseCase;
  late MockDeleteTravelExpenseUseCase mockDeleteTravelExpenseUseCase;
  late MockGetTravelExpenseByIdUseCase mockGetTravelExpenseByIdUseCase;
  late MockTravelExpenseEntity mockTravelExpenseEntity;
  late MockTravelCardEntity mockTravelCardEntity;

  final testDate = DateTime(2023, 5, 10);

  setUp(() {
    GetIt.I.reset();

    mockGetTravelExpensesUseCase = MockGetTravelExpensesUseCase();
    mockSaveTravelExpenseUseCase = MockSaveTravelExpenseUseCase();
    mockDeleteTravelExpenseUseCase = MockDeleteTravelExpenseUseCase();
    mockGetTravelExpenseByIdUseCase = MockGetTravelExpenseByIdUseCase();
    mockTravelExpenseEntity = MockTravelExpenseEntity();
    mockTravelCardEntity = MockTravelCardEntity();

    when(mockTravelExpenseEntity.id).thenReturn(1);
    when(mockTravelExpenseEntity.expenseDate).thenReturn(testDate);
    when(mockTravelExpenseEntity.description).thenReturn('Test expense');
    when(mockTravelExpenseEntity.category).thenReturn('Food');
    when(mockTravelExpenseEntity.amount).thenReturn(125.50);
    when(mockTravelExpenseEntity.paymentMethod).thenReturn('Card');
    when(mockTravelExpenseEntity.reimbursable).thenReturn(true);
    when(mockTravelExpenseEntity.isReimbursed).thenReturn(false);
    when(mockTravelExpenseEntity.status).thenReturn('programado');

    bloc = TestTravelExpensesBloc(
      getTravelExpensesUseCase: mockGetTravelExpensesUseCase,
      saveTravelExpenseUseCase: mockSaveTravelExpenseUseCase,
      deleteTravelExpenseUseCase: mockDeleteTravelExpenseUseCase,
      getTravelExpenseByIdUseCase: mockGetTravelExpenseByIdUseCase,
    );
  });

  tearDown(() {
    bloc.close();
  });


 

  group('RefreshTravelExpenses', () {
    blocTest<TestTravelExpensesBloc, TravelExpensesState>(
      'emits [TravelExpensesLoading, TravelExpensesLoaded] when refresh is successful',
      build: () {
        final info = FakeTravelExpensesInfoEntity(
          despesasdeviagem: <TravelExpenseEntity>[mockTravelExpenseEntity],
          cartoes: <TravelCardEntity>[mockTravelCardEntity],
        );
        when(
          mockGetTravelExpensesUseCase.call(NoParams()),
        ).thenAnswer((_) async => Right(info));
        return bloc;
      },
      act: (bloc) => bloc.add(const RefreshTravelExpenses()),
      expect:
          () => [
            isA<TravelExpensesLoading>(),
            isA<TravelExpensesLoaded>()
                .having((state) => state.expenses, 'expenses', [
                  mockTravelExpenseEntity,
                ])
                .having((state) => state.cards, 'cards', [
                  mockTravelCardEntity,
                ]),
          ],
      verify: (_) {
        verify(mockGetTravelExpensesUseCase.call(NoParams())).called(1);
      },
    );
  });



  group('GetTravelExpenseDetails', () {
    blocTest<TestTravelExpensesBloc, TravelExpensesState>(
      'emits [TravelExpensesLoading, TravelExpenseDetailsLoaded] when expense is found',
      build: () {
        when(
          mockGetTravelExpenseByIdUseCase.call(1),
        ).thenAnswer((_) async => Right(mockTravelExpenseEntity));
        return bloc;
      },
      act: (bloc) => bloc.add(const GetTravelExpenseDetails(1)),
      expect:
          () => [
            isA<TravelExpensesLoading>(),
            isA<TravelExpenseDetailsLoaded>().having(
              (state) => state.expense,
              'expense',
              mockTravelExpenseEntity,
            ),
          ],
      verify: (_) {
        verify(mockGetTravelExpenseByIdUseCase.call(1)).called(1);
      },
    );

    blocTest<TestTravelExpensesBloc, TravelExpensesState>(
      'emits [TravelExpensesLoading, TravelExpensesError] when expense is not found',
      build: () {
        when(
          mockGetTravelExpenseByIdUseCase.call(1),
        ).thenAnswer((_) async => const Right(null));
        return bloc;
      },
      act: (bloc) => bloc.add(const GetTravelExpenseDetails(1)),
      expect:
          () => [
            isA<TravelExpensesLoading>(),
            isA<TravelExpensesError>().having(
              (state) => state.message,
              'message',
              'Expense not found',
            ),
          ],
    );

    blocTest<TestTravelExpensesBloc, TravelExpensesState>(
      'emits [TravelExpensesLoading, TravelExpensesError] when use case fails',
      build: () {
        when(
          mockGetTravelExpenseByIdUseCase.call(1),
        ).thenAnswer((_) async => Left(ServerFailure(message: 'Server error')));
        return bloc;
      },
      act: (bloc) => bloc.add(const GetTravelExpenseDetails(1)),
      expect:
          () => [
            isA<TravelExpensesLoading>(),
            isA<TravelExpensesError>().having(
              (state) => state.message,
              'message',
              'Server error occurred',
            ),
          ],
    );
  });

  group('SyncTravelExpenses', () {
    blocTest<TestTravelExpensesBloc, TravelExpensesState>(
      'deve iniciar o FetchTravelExpenses quando o evento SyncTravelExpenses for disparado',
      build: () {
        final info = FakeTravelExpensesInfoEntity(
          despesasdeviagem: <TravelExpenseEntity>[mockTravelExpenseEntity],
          cartoes: <TravelCardEntity>[mockTravelCardEntity],
        );
        when(
          mockGetTravelExpensesUseCase.call(NoParams()),
        ).thenAnswer((_) async => Right(info));

        return bloc;
      },
      act: (bloc) => bloc.add(const SyncTravelExpenses()),
      expect:
          () => [
            isA<TravelExpensesLoading>(),
            isA<TravelExpensesLoaded>()
                .having((state) => state.expenses, 'expenses', [
                  mockTravelExpenseEntity,
                ])
                .having((state) => state.cards, 'cards', [
                  mockTravelCardEntity,
                ]),
          ],
      verify: (_) {
        verify(mockGetTravelExpensesUseCase.call(NoParams())).called(1);
      },
    );
  });
}

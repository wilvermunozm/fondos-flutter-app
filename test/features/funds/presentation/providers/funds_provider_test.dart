import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:amaris_fondos_flutter/core/errors/app_error.dart';
import 'package:amaris_fondos_flutter/features/funds/domain/models/fund.dart';
import 'package:amaris_fondos_flutter/features/funds/domain/usecases/get_funds_usecase.dart';
import 'package:amaris_fondos_flutter/features/funds/domain/usecases/get_fund_by_id_usecase.dart';
import 'package:amaris_fondos_flutter/features/funds/presentation/providers/funds_provider.dart';

@GenerateNiceMocks([MockSpec<GetFundsUseCase>(), MockSpec<GetFundByIdUseCase>()])
import 'funds_provider_test.mocks.dart';

void main() {
  late MockGetFundsUseCase mockGetFundsUseCase;
  late MockGetFundByIdUseCase mockGetFundByIdUseCase;
  late ProviderContainer container;
  late FundsNotifier notifier;
  
  final funds = [
    Fund(
      id: 'fund1',
      name: 'Test Fund 1',
      description: 'Description 1',
      category: 'Category 1',
      risk: 'low',
      annualReturn: 5.5,
      minInvestment: 1000.0,
      imageUrl: 'http://example.com/image1.jpg',
      manager: 'Manager 1',
      createdAt: DateTime(2023, 1, 1),
      type: 'equity',
      currency: 'USD',
      managementFee: 1.2,
      performance: 6.7,
      returnRates: FundReturn(
        oneYear: 5.5,
        threeYear: 15.5,
        fiveYear: 25.5,
        tenYear: 50.5,
        ytd: 3.2
      )
    ),
    Fund(
      id: 'fund2',
      name: 'Test Fund 2',
      description: 'Description 2',
      category: 'Category 2',
      risk: 'medium',
      annualReturn: 7.2,
      minInvestment: 2000.0,
      imageUrl: 'http://example.com/image2.jpg',
      manager: 'Manager 2',
      createdAt: DateTime(2023, 2, 1),
      type: 'bond',
      currency: 'EUR',
      managementFee: 1.5,
      performance: 7.8,
      returnRates: FundReturn(
        oneYear: 7.2,
        threeYear: 18.5,
        fiveYear: 28.5,
        tenYear: 55.5,
        ytd: 4.2
      )
    ),
  ];
  
  setUp(() {
    mockGetFundsUseCase = MockGetFundsUseCase();
    mockGetFundByIdUseCase = MockGetFundByIdUseCase();
    
    container = ProviderContainer(
      overrides: [
        getFundsUseCaseProvider.overrideWithValue(mockGetFundsUseCase),
        getFundByIdUseCaseProvider.overrideWithValue(mockGetFundByIdUseCase),
      ],
    );
    
    notifier = FundsNotifier(mockGetFundsUseCase);
    
    addTearDown(container.dispose);
  });
  
  group('FundsNotifier', () {
    test('should start with loading state', () {
      // Arrange
      when(mockGetFundsUseCase.execute()).thenAnswer((_) async => funds);
      
      // Act - create a new notifier which will start in loading state
      final newNotifier = FundsNotifier(mockGetFundsUseCase);
      
      // Assert
      expect(newNotifier.state, isA<AsyncLoading>());
    });
    
    test('should fetch funds on initialization', () async {
      // Arrange
      when(mockGetFundsUseCase.execute()).thenAnswer((_) async => funds);
      
      // Act
      await notifier.fetchFunds();
      
      // Assert
      verify(mockGetFundsUseCase.execute());
      expect(notifier.state, isA<AsyncData<List<Fund>>>());
      expect(notifier.state.value, funds);
    });
    
    test('should set error state when fetchFunds fails', () async {
      // Arrange
      final exception = UnexpectedError(message: 'Test error');
      when(mockGetFundsUseCase.execute()).thenThrow(exception);
      
      // Act
      await notifier.fetchFunds();
      
      // Assert
      verify(mockGetFundsUseCase.execute());
      expect(notifier.state, isA<AsyncError>());
      expect(notifier.state.error, exception);
    });
    
    test('refresh should call fetchFunds', () async {
      // Arrange
      when(mockGetFundsUseCase.execute()).thenAnswer((_) async => funds);
      
      // Act
      await notifier.refresh();
      
      // Assert
      verify(mockGetFundsUseCase.execute());
    });
  });
  
  group('fundsProvider', () {
    test('should provide FundsNotifier with funds data', () async {
      // Arrange
      when(mockGetFundsUseCase.execute()).thenAnswer((_) async => funds);
      
      // Act - read the provider which will trigger the notifier creation and fetchFunds
      final result = container.read(fundsProvider);
      
      // Wait for the async operation to complete
      await Future.delayed(Duration.zero);
      
      // Assert
      expect(container.read(fundsProvider), isA<AsyncValue<List<Fund>>>());
      verify(mockGetFundsUseCase.execute());
    });
  });
  
  group('fundByIdProvider', () {
    const fundId = 'fund1';
    final fund = Fund(
      id: fundId,
      name: 'Test Fund 1',
      description: 'Description 1',
      category: 'Category 1',
      risk: 'low',
      annualReturn: 5.5,
      minInvestment: 1000.0,
      imageUrl: 'http://example.com/image1.jpg',
      manager: 'Manager 1',
      createdAt: DateTime(2023, 1, 1),
      type: 'equity',
      currency: 'USD',
      managementFee: 1.2,
      performance: 6.7,
      returnRates: FundReturn(
        oneYear: 5.5,
        threeYear: 15.5,
        fiveYear: 25.5,
        tenYear: 50.5,
        ytd: 3.2
      )
    );
    
    test('should get fund by id', () async {
      // Arrange
      when(mockGetFundByIdUseCase.execute(fundId)).thenAnswer((_) async => fund);
      
      // Act - read the provider which will trigger the future
      final asyncValue = container.read(fundByIdProvider(fundId));
      
      // Assert that it's a loading state initially
      expect(asyncValue, isA<AsyncValue<Fund>>());
      verify(mockGetFundByIdUseCase.execute(fundId));
      
      // Wait for the future to complete
      await Future.delayed(Duration.zero);
      
      // Now read the provider again to get the updated state
      final completedValue = container.read(fundByIdProvider(fundId));
      
      // Verify the completed state has data
      expect(completedValue.hasValue, isTrue);
      expect(completedValue.value, fund);
    });
  });
}

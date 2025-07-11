import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:amaris_fondos_flutter/features/funds/data/repositories/fund_repository.dart';
import 'package:amaris_fondos_flutter/features/funds/domain/models/fund.dart';
import 'package:amaris_fondos_flutter/features/funds/domain/usecases/get_funds_usecase.dart';

@GenerateNiceMocks([MockSpec<FundRepository>()])
import 'get_funds_usecase_test.mocks.dart';

void main() {
  late GetFundsUseCase useCase;
  late MockFundRepository mockRepository;
  
  setUp(() {
    mockRepository = MockFundRepository();
    useCase = GetFundsUseCase(mockRepository);
  });
  
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
  
  test('should get funds from repository', () async {
    when(mockRepository.getFunds())
        .thenAnswer((_) async => funds);
    
    final result = await useCase.execute();
    
    expect(result, equals(funds));
    verify(mockRepository.getFunds());
    verifyNoMoreInteractions(mockRepository);
  });
}

import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:amaris_fondos_flutter/features/funds/data/repositories/fund_repository.dart';
import 'package:amaris_fondos_flutter/features/funds/domain/models/fund.dart';
import 'package:amaris_fondos_flutter/features/funds/domain/usecases/get_fund_by_id_usecase.dart';

@GenerateNiceMocks([MockSpec<FundRepository>()])
import 'get_fund_by_id_usecase_test.mocks.dart';

void main() {
  late GetFundByIdUseCase useCase;
  late MockFundRepository mockRepository;
  
  const fundId = 'fund1';
  
  setUp(() {
    mockRepository = MockFundRepository();
    useCase = GetFundByIdUseCase(mockRepository);
  });
  
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
  
  test('should get fund by id from repository', () async {
    when(mockRepository.getFundById(fundId))
        .thenAnswer((_) async => fund);
    
    final result = await useCase.execute(fundId);
    
    expect(result, equals(fund));
    verify(mockRepository.getFundById(fundId));
    verifyNoMoreInteractions(mockRepository);
  });
}

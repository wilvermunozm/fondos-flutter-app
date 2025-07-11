import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:amaris_fondos_flutter/features/subscriptions/data/repositories/subscription_repository.dart';
import 'package:amaris_fondos_flutter/features/subscriptions/domain/models/subscription.dart';
import 'package:amaris_fondos_flutter/features/subscriptions/domain/usecases/subscribe_to_fund_usecase.dart';

@GenerateNiceMocks([MockSpec<SubscriptionRepository>()])
import 'subscribe_to_fund_usecase_test.mocks.dart';

void main() {
  late SubscribeToFundUseCase useCase;
  late MockSubscriptionRepository mockRepository;
  
  const userId = 'user123';
  const fundId = 'fund123';
  const amount = 1000.0;
  
  setUp(() {
    mockRepository = MockSubscriptionRepository();
    useCase = SubscribeToFundUseCase(repository: mockRepository);
  });
  
  final subscription = Subscription(
    id: 'subscription123',
    userId: userId,
    fundId: fundId,
    amount: amount,
    date: DateTime(2023, 1, 1),
    status: 'active',
    fundName: 'Test Fund'
  );
  
  test('should subscribe to fund through repository', () async {
    when(mockRepository.subscribeToFund(userId, fundId, amount))
        .thenAnswer((_) async => subscription);
    
    final result = await useCase.execute(userId, fundId, amount);
    
    expect(result, equals(subscription));
    verify(mockRepository.subscribeToFund(userId, fundId, amount));
    verifyNoMoreInteractions(mockRepository);
  });
}

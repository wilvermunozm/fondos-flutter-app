import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:amaris_fondos_flutter/features/subscriptions/data/repositories/subscription_repository.dart';
import 'package:amaris_fondos_flutter/features/subscriptions/domain/models/subscription.dart';
import 'package:amaris_fondos_flutter/features/subscriptions/domain/usecases/get_user_subscriptions_usecase.dart';

@GenerateNiceMocks([MockSpec<SubscriptionRepository>()])
import 'get_user_subscriptions_usecase_test.mocks.dart';

void main() {
  late GetUserSubscriptionsUseCase useCase;
  late MockSubscriptionRepository mockRepository;
  
  const userId = 'user123';
  
  setUp(() {
    mockRepository = MockSubscriptionRepository();
    useCase = GetUserSubscriptionsUseCase(repository: mockRepository);
  });
  
  final subscriptions = [
    Subscription(
      id: 'subscription1',
      userId: userId,
      fundId: 'fund1',
      amount: 1000.0,
      date: DateTime(2023, 1, 1),
      status: 'active',
      fundName: 'Test Fund 1'
    ),
    Subscription(
      id: 'subscription2',
      userId: userId,
      fundId: 'fund2',
      amount: 2000.0,
      date: DateTime(2023, 2, 1),
      status: 'active',
      fundName: 'Test Fund 2'
    ),
  ];
  
  test('should get user subscriptions from repository', () async {
    when(mockRepository.getUserSubscriptions(userId))
        .thenAnswer((_) async => subscriptions);
    
    final result = await useCase.execute(userId);
    
    expect(result, equals(subscriptions));
    verify(mockRepository.getUserSubscriptions(userId));
    verifyNoMoreInteractions(mockRepository);
  });
}

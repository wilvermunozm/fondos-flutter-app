import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:amaris_fondos_flutter/features/subscriptions/data/repositories/subscription_repository.dart';
import 'package:amaris_fondos_flutter/features/subscriptions/domain/usecases/cancel_subscription_usecase.dart';

// Generar mocks con @GenerateNiceMocks para reducir la estrictez en las pruebas
@GenerateNiceMocks([MockSpec<SubscriptionRepository>()])
import 'cancel_subscription_usecase_test.mocks.dart';

void main() {
  late CancelSubscriptionUseCase useCase;
  late MockSubscriptionRepository mockRepository;
  
  const subscriptionId = 'subscription123';
  
  setUp(() {
    mockRepository = MockSubscriptionRepository();
    useCase = CancelSubscriptionUseCase(repository: mockRepository);
  });
  
  test('should cancel subscription through repository and return true when successful', () async {
    when(mockRepository.cancelSubscription(subscriptionId))
        .thenAnswer((_) async => true);
    
    final result = await useCase.execute(subscriptionId);
    
    expect(result, isTrue);
    verify(mockRepository.cancelSubscription(subscriptionId));
    verifyNoMoreInteractions(mockRepository);
  });
  
  test('should return false when cancellation fails', () async {
    when(mockRepository.cancelSubscription(subscriptionId))
        .thenAnswer((_) async => false);
    
    final result = await useCase.execute(subscriptionId);
    
    expect(result, isFalse);
    verify(mockRepository.cancelSubscription(subscriptionId));
    verifyNoMoreInteractions(mockRepository);
  });
}

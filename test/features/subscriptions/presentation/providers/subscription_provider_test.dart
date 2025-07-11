import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:amaris_fondos_flutter/core/errors/app_error.dart';
import 'package:amaris_fondos_flutter/features/subscriptions/domain/models/subscription.dart';
import 'package:amaris_fondos_flutter/features/subscriptions/domain/usecases/cancel_subscription_usecase.dart';
import 'package:amaris_fondos_flutter/features/subscriptions/domain/usecases/get_user_subscriptions_usecase.dart';
import 'package:amaris_fondos_flutter/features/subscriptions/domain/usecases/subscribe_to_fund_usecase.dart';

@GenerateNiceMocks([
  MockSpec<GetUserSubscriptionsUseCase>(),
  MockSpec<SubscribeToFundUseCase>(),
  MockSpec<CancelSubscriptionUseCase>(),
])
import 'subscription_provider_test.mocks.dart';

class TestSubscriptionNotifier extends StateNotifier<AsyncValue<List<Subscription>>> {
  final MockGetUserSubscriptionsUseCase _getUserSubscriptionsUseCase;
  final MockSubscribeToFundUseCase _subscribeToFundUseCase;
  final MockCancelSubscriptionUseCase _cancelSubscriptionUseCase;
  final String _userId;
  
  TestSubscriptionNotifier({
    required MockGetUserSubscriptionsUseCase getUserSubscriptionsUseCase,
    required MockSubscribeToFundUseCase subscribeToFundUseCase,
    required MockCancelSubscriptionUseCase cancelSubscriptionUseCase,
    required String userId,
  }) : _getUserSubscriptionsUseCase = getUserSubscriptionsUseCase,
       _subscribeToFundUseCase = subscribeToFundUseCase,
       _cancelSubscriptionUseCase = cancelSubscriptionUseCase,
       _userId = userId,
       super(const AsyncValue.loading());
  
  Future<void> loadSubscriptions() async {
    state = const AsyncValue.loading();
    try {
      final subscriptions = await _getUserSubscriptionsUseCase.execute(_userId);
      state = AsyncValue.data(subscriptions);
    } catch (e, stackTrace) {
      state = AsyncValue.error(
        e is AppError ? e : UnexpectedError(message: 'Failed to load subscriptions', cause: e),
        stackTrace,
      );
    }
  }
  
  Future<void> subscribeToFund({required String fundId, required double amount}) async {
    try {
      await _subscribeToFundUseCase.execute(_userId, fundId, amount);
      await loadSubscriptions();
    } catch (e) {
      throw e is AppError ? e : UnexpectedError(message: 'Failed to subscribe to fund', cause: e);
    }
  }
  
  Future<void> cancelSubscription(String subscriptionId) async {
    try {
      final success = await _cancelSubscriptionUseCase.execute(subscriptionId);
      
      if (success) {
        state.whenData((subscriptions) {
          state = AsyncValue.data(
            subscriptions.where((s) => s.id != subscriptionId).toList(),
          );
        });
      } else {
        await loadSubscriptions();
      }
    } catch (e) {
      await loadSubscriptions();
      throw e is AppError ? e : UnexpectedError(message: 'Failed to cancel subscription', cause: e);
    }
  }
}

void main() {
  late MockGetUserSubscriptionsUseCase mockGetUserSubscriptionsUseCase;
  late MockSubscribeToFundUseCase mockSubscribeToFundUseCase;
  late MockCancelSubscriptionUseCase mockCancelSubscriptionUseCase;
  late TestSubscriptionNotifier notifier;
  
  const userId = 'user123';
  const fundId = 'fund123';
  const subscriptionId = 'subscription1';
  const amount = 1000.0;
  
  final subscriptions = [
    Subscription(
      id: 'subscription1',
      userId: userId,
      fundId: 'fund1',
      fundName: 'Test Fund 1',
      amount: 1000.0,
      date: DateTime.parse('2023-01-01'),
      status: 'active',
    ),
    Subscription(
      id: 'subscription2',
      userId: userId,
      fundId: 'fund2',
      fundName: 'Test Fund 2',
      amount: 2000.0,
      date: DateTime.parse('2023-01-02'),
      status: 'active',
    ),
  ];
  
  final newSubscription = Subscription(
    id: 'subscription3',
    userId: userId,
    fundId: fundId,
    fundName: 'New Test Fund',
    amount: amount,
    date: DateTime.now(),
    status: 'active',
  );
  
  setUp(() {
    mockGetUserSubscriptionsUseCase = MockGetUserSubscriptionsUseCase();
    mockSubscribeToFundUseCase = MockSubscribeToFundUseCase();
    mockCancelSubscriptionUseCase = MockCancelSubscriptionUseCase();
    
    notifier = TestSubscriptionNotifier(
      getUserSubscriptionsUseCase: mockGetUserSubscriptionsUseCase,
      subscribeToFundUseCase: mockSubscribeToFundUseCase,
      cancelSubscriptionUseCase: mockCancelSubscriptionUseCase,
      userId: userId,
    );
  });
  
  group('loadSubscriptions', () {
    test('should set loading state when called', () async {
      when(mockGetUserSubscriptionsUseCase.execute(userId))
          .thenAnswer((_) async => subscriptions);
      
      notifier.loadSubscriptions();
      
      expect(notifier.state, isA<AsyncLoading<List<Subscription>>>());
    });
    
    test('should set data state when successful', () async {
      when(mockGetUserSubscriptionsUseCase.execute(userId))
          .thenAnswer((_) async => subscriptions);
      
      await notifier.loadSubscriptions();
      
      expect(notifier.state, isA<AsyncData<List<Subscription>>>());
      expect(notifier.state.value, subscriptions);
      
      verify(mockGetUserSubscriptionsUseCase.execute(userId));
      verifyNoMoreInteractions(mockGetUserSubscriptionsUseCase);
      verifyZeroInteractions(mockSubscribeToFundUseCase);
      verifyZeroInteractions(mockCancelSubscriptionUseCase);
    });
    
    test('should set error state when fails', () async {
      final exception = Exception('Failed to load subscriptions');
      when(mockGetUserSubscriptionsUseCase.execute(userId))
          .thenThrow(exception);
      
      await notifier.loadSubscriptions();
      
      expect(notifier.state, isA<AsyncError<List<Subscription>>>());
      expect(notifier.state.error, isA<AppError>());
      
      verify(mockGetUserSubscriptionsUseCase.execute(userId));
      verifyNoMoreInteractions(mockGetUserSubscriptionsUseCase);
      verifyZeroInteractions(mockSubscribeToFundUseCase);
      verifyZeroInteractions(mockCancelSubscriptionUseCase);
    });
  });
  
  group('subscribeToFund', () {
    test('should add subscription and reload when successful', () async {
      when(mockSubscribeToFundUseCase.execute(userId, fundId, amount))
          .thenAnswer((_) async => newSubscription);
      when(mockGetUserSubscriptionsUseCase.execute(userId))
          .thenAnswer((_) async => [...subscriptions, newSubscription]);
      
      notifier.state = AsyncData(subscriptions);
      
      await notifier.subscribeToFund(fundId: fundId, amount: amount);
      
      verify(mockSubscribeToFundUseCase.execute(userId, fundId, amount));
      verify(mockGetUserSubscriptionsUseCase.execute(userId));
      
      expect(notifier.state, isA<AsyncData<List<Subscription>>>());
      expect(notifier.state.value?.length, subscriptions.length + 1);
      
      verifyNoMoreInteractions(mockSubscribeToFundUseCase);
      verifyNoMoreInteractions(mockGetUserSubscriptionsUseCase);
    });
    
    test('should handle exception when subscription fails', () async {
      final exception = Exception('Failed to subscribe');
      when(mockSubscribeToFundUseCase.execute(userId, fundId, amount))
          .thenThrow(exception);
      
      notifier.state = AsyncData(subscriptions);
      
      expect(
        () => notifier.subscribeToFund(fundId: fundId, amount: amount),
        throwsA(isA<AppError>()),
      );
      
      verify(mockSubscribeToFundUseCase.execute(userId, fundId, amount));
      verifyNoMoreInteractions(mockSubscribeToFundUseCase);
    });
  });
  
  group('cancelSubscription', () {
    test('should remove subscription from state when successful', () async {
      when(mockCancelSubscriptionUseCase.execute(subscriptionId))
          .thenAnswer((_) async => true);
      
      notifier.state = AsyncData(subscriptions);
      
      await notifier.cancelSubscription(subscriptionId);
      
      verify(mockCancelSubscriptionUseCase.execute(subscriptionId));
      
      expect(notifier.state, isA<AsyncData<List<Subscription>>>());
      expect(notifier.state.value?.length, 1);
      expect(notifier.state.value?[0].id, 'subscription2');
      
      verifyNoMoreInteractions(mockCancelSubscriptionUseCase);
    });
    
    test('should reload subscriptions when cancellation returns false', () async {
      when(mockCancelSubscriptionUseCase.execute(subscriptionId))
          .thenAnswer((_) async => false);
      when(mockGetUserSubscriptionsUseCase.execute(userId))
          .thenAnswer((_) async => subscriptions);
      
      notifier.state = AsyncData(subscriptions);
      
      await notifier.cancelSubscription(subscriptionId);
      
      verify(mockCancelSubscriptionUseCase.execute(subscriptionId));
      verify(mockGetUserSubscriptionsUseCase.execute(userId));
      
      verifyNoMoreInteractions(mockCancelSubscriptionUseCase);
      verifyNoMoreInteractions(mockGetUserSubscriptionsUseCase);
    });
    
    test('should handle exception and reload when cancellation fails', () async {
      final exception = Exception('Failed to cancel subscription');
      when(mockCancelSubscriptionUseCase.execute(subscriptionId))
          .thenThrow(exception);
      when(mockGetUserSubscriptionsUseCase.execute(userId))
          .thenAnswer((_) async => subscriptions);
      
      notifier.state = AsyncData(subscriptions);
      
      expect(
        () => notifier.cancelSubscription(subscriptionId),
        throwsA(isA<AppError>()),
      );
      
      verify(mockCancelSubscriptionUseCase.execute(subscriptionId));
      verify(mockGetUserSubscriptionsUseCase.execute(userId));
      
      verifyNoMoreInteractions(mockCancelSubscriptionUseCase);
      verifyNoMoreInteractions(mockGetUserSubscriptionsUseCase);
    });
  });
}

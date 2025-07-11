import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/constants/api_constants.dart';
import '../../../../core/errors/app_error.dart';
import '../../../../core/providers/http_client_provider.dart';
import '../../../../core/logging/logger.dart' as app_logger;
import '../../domain/models/subscription.dart';
import '../../data/repositories/subscription_repository.dart';
import '../../../auth/presentation/providers/user_provider.dart';
import '../../domain/usecases/get_user_subscriptions_usecase.dart';
import '../../domain/usecases/subscribe_to_fund_usecase.dart';
import '../../domain/usecases/cancel_subscription_usecase.dart';


final subscriptionRepositoryProvider = Provider<SubscriptionRepository>((ref) {
  return SubscriptionRepository(
    baseUrl: ApiConstants.baseUrl,
    client: ref.watch(httpClientProvider),
  );
});


final getUserSubscriptionsUseCaseProvider = Provider<GetUserSubscriptionsUseCase>((ref) {
  final repository = ref.watch(subscriptionRepositoryProvider);
  return GetUserSubscriptionsUseCase(repository: repository);
});

final subscribeToFundUseCaseProvider = Provider<SubscribeToFundUseCase>((ref) {
  final repository = ref.watch(subscriptionRepositoryProvider);
  return SubscribeToFundUseCase(repository: repository);
});

final cancelSubscriptionUseCaseProvider = Provider<CancelSubscriptionUseCase>((ref) {
  final repository = ref.watch(subscriptionRepositoryProvider);
  return CancelSubscriptionUseCase(repository: repository);
});

class SubscriptionNotifier extends StateNotifier<AsyncValue<List<Subscription>>> {
  final GetUserSubscriptionsUseCase _getUserSubscriptionsUseCase;
  final SubscribeToFundUseCase _subscribeToFundUseCase;
  final CancelSubscriptionUseCase _cancelSubscriptionUseCase;
  final String _userId;
  
  SubscriptionNotifier({
    required GetUserSubscriptionsUseCase getUserSubscriptionsUseCase,
    required SubscribeToFundUseCase subscribeToFundUseCase,
    required CancelSubscriptionUseCase cancelSubscriptionUseCase,
    required String userId,
  }) : _getUserSubscriptionsUseCase = getUserSubscriptionsUseCase,
       _subscribeToFundUseCase = subscribeToFundUseCase,
       _cancelSubscriptionUseCase = cancelSubscriptionUseCase,
       _userId = userId,
       super(const AsyncValue.loading()) {
    loadSubscriptions();
  }
  
  Future<void> loadSubscriptions() async {
    try {
      state = const AsyncValue.loading();
      final subscriptions = await _getUserSubscriptionsUseCase.execute(_userId);
      state = AsyncValue.data(subscriptions);
    } catch (e, stackTrace) {
      app_logger.AppLogger.error('Error loading subscriptions: $e');
      state = AsyncValue.error(
        e is AppError ? e : UnexpectedError(message: 'Failed to load subscriptions', cause: e),
        stackTrace,
      );
    }
  }
  
  Future<void> subscribeToFund({required String fundId, required double amount}) async {
    try {
      await _subscribeToFundUseCase.execute(_userId, fundId, amount);
      loadSubscriptions(); // Reload subscriptions after subscribing
    } catch (e) {
      app_logger.AppLogger.error('Error subscribing to fund: $e');
      throw e is AppError ? e : UnexpectedError(message: 'Failed to subscribe to fund', cause: e);
    }
  }
  
  Future<void> cancelSubscription(String subscriptionId) async {
    try {
      state.whenData((subscriptions) {
        state = AsyncValue.data(
          subscriptions.where((sub) => sub.id != subscriptionId).toList()
        );
      });
      
      final success = await _cancelSubscriptionUseCase.execute(subscriptionId);
      
      if (success) {
        app_logger.AppLogger.info('Suscripción cancelada exitosamente');
      } else {
        app_logger.AppLogger.warning('Error al cancelar suscripción, recargando datos');
        loadSubscriptions(); // Recargar solo si hubo un error
      }
    } catch (e) {
      app_logger.AppLogger.error('Error cancelling subscription: $e');
      loadSubscriptions();
      throw e is AppError ? e : UnexpectedError(message: 'Failed to cancel subscription', cause: e);
    }
  }
}

final subscriptionProvider = StateNotifierProvider<SubscriptionNotifier, AsyncValue<List<Subscription>>>((ref) {
  final userId = ref.watch(currentUserIdProvider);
  return SubscriptionNotifier(
    getUserSubscriptionsUseCase: ref.watch(getUserSubscriptionsUseCaseProvider),
    subscribeToFundUseCase: ref.watch(subscribeToFundUseCaseProvider),
    cancelSubscriptionUseCase: ref.watch(cancelSubscriptionUseCaseProvider),
    userId: userId,
  );
});

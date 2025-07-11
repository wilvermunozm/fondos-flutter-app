import '../../data/repositories/subscription_repository.dart';

class CancelSubscriptionUseCase {
  final SubscriptionRepository repository;

  CancelSubscriptionUseCase({required this.repository});

  Future<bool> execute(String subscriptionId) async {
    return await repository.cancelSubscription(subscriptionId);
  }
}

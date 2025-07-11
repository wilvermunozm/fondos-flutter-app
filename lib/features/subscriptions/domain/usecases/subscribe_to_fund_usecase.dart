import '../../data/repositories/subscription_repository.dart';
import '../models/subscription.dart';

class SubscribeToFundUseCase {
  final SubscriptionRepository repository;

  SubscribeToFundUseCase({required this.repository});

  Future<Subscription> execute(String userId, String fundId, double amount) async {
    return await repository.subscribeToFund(userId, fundId, amount);
  }
}

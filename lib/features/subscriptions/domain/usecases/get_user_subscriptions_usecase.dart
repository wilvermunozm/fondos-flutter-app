import '../../data/repositories/subscription_repository.dart';
import '../models/subscription.dart';

class GetUserSubscriptionsUseCase {
  final SubscriptionRepository repository;

  GetUserSubscriptionsUseCase({required this.repository});

  Future<List<Subscription>> execute(String userId) async {
    return await repository.getUserSubscriptions(userId);
  }
}

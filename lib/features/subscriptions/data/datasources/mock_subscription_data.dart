import '../../domain/models/subscription.dart';

class MockSubscriptionData {
  static final Map<String, List<Subscription>> _userSubscriptions = {};
  
  static List<Subscription> getUserSubscriptions(String userId) {
    if (_userSubscriptions.containsKey(userId)) {
      return _userSubscriptions[userId]!;
    }
    
    final initialSubscriptions = [
      Subscription(
        id: 'mock-sub-1',
        userId: userId,
        fundId: 'fund-001',
        fundName: 'Fondo de Inversión Global',
        amount: 5000.0,
        date: DateTime.now().subtract(const Duration(days: 30)),
        status: 'active',
      ),
      Subscription(
        id: 'mock-sub-2',
        userId: userId,
        fundId: 'fund-002',
        fundName: 'Fondo de Renta Variable',
        amount: 3000.0,
        date: DateTime.now().subtract(const Duration(days: 15)),
        status: 'active',
      ),
      Subscription(
        id: 'mock-sub-3',
        userId: userId,
        fundId: 'fund-003',
        fundName: 'Fondo de Bonos Corporativos',
        amount: 7500.0,
        date: DateTime.now().subtract(const Duration(days: 60)),
        status: 'inactive',
      ),
    ];
    
    _userSubscriptions[userId] = initialSubscriptions;
    return initialSubscriptions;
  }

  /// Simula una suscripción a un fondo
  static Subscription subscribeToFund({
    required String userId,
    required String fundId,
    required String fundName,
    required double amount,
  }) {
    final newSubscription = Subscription(
      id: 'mock-sub-${DateTime.now().millisecondsSinceEpoch}',
      userId: userId,
      fundId: fundId,
      fundName: fundName,
      amount: amount,
      date: DateTime.now(),
      status: 'active',
    );
    
    if (!_userSubscriptions.containsKey(userId)) {
      _userSubscriptions[userId] = [];
    }
    _userSubscriptions[userId]!.add(newSubscription);
    
    return newSubscription;
  }

  static bool cancelSubscription(String subscriptionId) {
    bool removed = false;
    
    for (final userId in _userSubscriptions.keys) {
      final subscriptions = _userSubscriptions[userId]!;
      final initialLength = subscriptions.length;
      
      _userSubscriptions[userId] = subscriptions.where((sub) => sub.id != subscriptionId).toList();
      
      if (_userSubscriptions[userId]!.length < initialLength) {
        removed = true;
      }
    }
    
    return removed;
  }
}

import 'package:flutter_test/flutter_test.dart';
import 'package:amaris_fondos_flutter/features/subscriptions/domain/models/subscription.dart';
import 'package:amaris_fondos_flutter/features/funds/domain/models/fund.dart';

void main() {
  group('Subscription', () {
    const id = 'subscription123';
    const userId = 'user123';
    const fundId = 'fund123';
    const fundName = 'Test Fund';
    const amount = 1000.0;
    final date = DateTime(2023, 1, 1);
    const status = 'active';
    
    test('should create a Subscription instance with correct properties', () {
      // Arrange & Act
      final subscription = Subscription(
        id: id,
        userId: userId,
        fundId: fundId,
        fundName: fundName,
        amount: amount,
        date: date,
        status: status,
      );
      
      // Assert
      expect(subscription.id, equals(id));
      expect(subscription.userId, equals(userId));
      expect(subscription.fundId, equals(fundId));
      expect(subscription.fundName, equals(fundName));
      expect(subscription.amount, equals(amount));
      expect(subscription.date, equals(date));
      expect(subscription.status, equals(status));
      expect(subscription.fund, isNull);
    });
    
    test('should create a Subscription instance with a Fund', () {
      // Arrange
      final fund = Fund(
        id: fundId,
        name: fundName,
        description: 'Test Description',
        minInvestment: 500.0,
        annualReturn: 0.12,
        risk: 'Medium',
        category: 'Test Category',
        manager: 'Test Manager',
        createdAt: DateTime(2022, 1, 1),
        imageUrl: 'https://example.com/image.jpg',
        returnRates: const FundReturn(
          oneYear: 0.12,
          threeYear: 0.25,
          fiveYear: 0.40,
          tenYear: 0.80,
          ytd: 0.08,
        ),
      );
      
      // Act
      final subscription = Subscription(
        id: id,
        userId: userId,
        fundId: fundId,
        fundName: fundName,
        amount: amount,
        date: date,
        status: status,
        fund: fund,
      );
      
      // Assert
      expect(subscription.fund, equals(fund));
      expect(subscription.fund?.id, equals(fundId));
      expect(subscription.fund?.name, equals(fundName));
      expect(subscription.fund?.risk, equals('Medium'));
    });
    
    test('should copy with new values', () {
      // Arrange
      final subscription = Subscription(
        id: id,
        userId: userId,
        fundId: fundId,
        fundName: fundName,
        amount: amount,
        date: date,
        status: status,
      );
      
      // Act
      final newDate = DateTime(2023, 2, 1);
      final newStatus = 'inactive';
      final newAmount = 2000.0;
      
      final updatedSubscription = subscription.copyWith(
        date: newDate,
        status: newStatus,
        amount: newAmount,
      );
      
      // Assert
      expect(updatedSubscription.id, equals(id)); // unchanged
      expect(updatedSubscription.userId, equals(userId)); // unchanged
      expect(updatedSubscription.fundId, equals(fundId)); // unchanged
      expect(updatedSubscription.fundName, equals(fundName)); // unchanged
      expect(updatedSubscription.amount, equals(newAmount)); // changed
      expect(updatedSubscription.date, equals(newDate)); // changed
      expect(updatedSubscription.status, equals(newStatus)); // changed
    });
  });
}

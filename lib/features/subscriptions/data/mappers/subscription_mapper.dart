import '../../domain/models/subscription.dart';

class SubscriptionMapper {
  static Subscription fromJson(Map<String, dynamic> json) {
    return Subscription(
      id: json['id'] ?? '',
      userId: json['userId'] ?? '',
      fundId: json['fundId'] ?? '',
      fundName: json['fundName'] ?? '',
      amount: (json['amount'] ?? 0.0).toDouble(),
      date: json['date'] != null 
          ? DateTime.parse(json['date']) 
          : DateTime.now(),
      status: json['status'] ?? (json['active'] != null ? (json['active'] == true || json['active'] == 'true' ? 'active' : 'inactive') : 'active'),
      fund: null,
    );
  }

  static Map<String, dynamic> toJson(Subscription subscription) {
    return {
      'id': subscription.id,
      'userId': subscription.userId,
      'fundId': subscription.fundId,
      'fundName': subscription.fundName,
      'amount': subscription.amount,
      'date': subscription.date.toIso8601String(),
      'status': subscription.status,
    };
  }

  static List<Subscription> fromJsonList(List<dynamic> jsonList) {
    return jsonList.map((json) => fromJson(json)).toList();
  }

  static List<Map<String, dynamic>> toJsonList(List<Subscription> subscriptions) {
    return subscriptions.map((subscription) => toJson(subscription)).toList();
  }
}

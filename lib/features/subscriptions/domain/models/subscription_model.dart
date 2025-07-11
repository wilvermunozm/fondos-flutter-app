class SubscriptionModel {
  final String id;
  final String userId;
  final String fundId;
  final double amount;
  final DateTime subscriptionDate;
  final String status;

  SubscriptionModel({
    required this.id,
    required this.userId,
    required this.fundId,
    required this.amount,
    required this.subscriptionDate,
    required this.status,
  });

  bool get active => status == 'active';

  factory SubscriptionModel.fromJson(Map<String, dynamic> json) {
    return SubscriptionModel(
      id: json['id'] ?? '',
      userId: json['userId'] ?? '',
      fundId: json['fundId'] ?? '',
      amount: (json['amount'] ?? 0).toDouble(),
      subscriptionDate: json['date'] != null 
          ? DateTime.parse(json['date']) 
          : DateTime.now(),
      status: json['status'] ?? 'active',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userId': userId,
      'fundId': fundId,
      'amount': amount,
      'date': subscriptionDate.toIso8601String(),
      'status': status,
    };
  }

  SubscriptionModel copyWith({
    String? id,
    String? userId,
    String? fundId,
    double? amount,
    DateTime? subscriptionDate,
    String? status,
  }) {
    return SubscriptionModel(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      fundId: fundId ?? this.fundId,
      amount: amount ?? this.amount,
      subscriptionDate: subscriptionDate ?? this.subscriptionDate,
      status: status ?? this.status,
    );
  }
}

import '../../../funds/domain/models/fund.dart';

class Subscription {
  final String id;
  final String userId;
  final String fundId;
  final String fundName;
  final double amount;
  final DateTime date;
  final String status;
  final Fund? fund;

  Subscription({
    required this.id,
    required this.userId,
    required this.fundId,
    required this.fundName,
    required this.amount,
    required this.date,
    required this.status,
    this.fund,
  });

  Subscription copyWith({
    String? id,
    String? userId,
    String? fundId,
    String? fundName,
    double? amount,
    DateTime? date,
    String? status,
    Fund? fund,
  }) {
    return Subscription(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      fundId: fundId ?? this.fundId,
      fundName: fundName ?? this.fundName,
      amount: amount ?? this.amount,
      date: date ?? this.date,
      status: status ?? this.status,
      fund: fund ?? this.fund,
    );
  }
}

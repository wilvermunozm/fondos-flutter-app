class TransactionModel {
  final String id;
  final String userId;
  final String fundId;
  final String type;
  final double amount;
  final String status;
  final DateTime date;
  final double? units;
  final double? unitPrice;

  TransactionModel({
    required this.id,
    required this.userId,
    required this.fundId,
    required this.type,
    required this.amount,
    required this.status,
    required this.date,
    this.units,
    this.unitPrice,
  });

  factory TransactionModel.fromJson(Map<String, dynamic> json) {
    return TransactionModel(
      id: json['id'],
      userId: json['userId'],
      fundId: json['fundId'],
      type: json['type'],
      amount: json['amount'].toDouble(),
      status: json['status'],
      date: DateTime.parse(json['date']),
      units: json['units'] != null ? json['units'].toDouble() : null,
      unitPrice: json['unitPrice'] != null ? json['unitPrice'].toDouble() : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userId': userId,
      'fundId': fundId,
      'type': type,
      'amount': amount,
      'status': status,
      'date': date.toIso8601String(),
      'units': units,
      'unitPrice': unitPrice,
    };
  }
}

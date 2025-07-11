class UserModel {
  final String id;
  final String name;
  final double balance;
  final List<String> subscribedFunds;

  UserModel({
    required this.id,
    required this.name,
    required this.balance,
    required this.subscribedFunds,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'],
      name: json['name'],
      balance: (json['balance'] ?? 0).toDouble(),
      subscribedFunds: json['subscribedFunds'] != null 
          ? List<String>.from(json['subscribedFunds']) 
          : [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'balance': balance,
      'subscribedFunds': subscribedFunds,
    };
  }

  UserModel copyWith({
    String? id,
    String? name,
    double? balance,
    List<String>? subscribedFunds,
  }) {
    return UserModel(
      id: id ?? this.id,
      name: name ?? this.name,
      balance: balance ?? this.balance,
      subscribedFunds: subscribedFunds ?? this.subscribedFunds,
    );
  }
}

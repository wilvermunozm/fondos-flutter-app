class UserModel {
  final String id;
  final String name;
  final String email;
  final double balance;
  final List<String> subscribedFunds;

  UserModel({
    required this.id,
    required this.name,
    required this.email,
    required this.balance,
    required this.subscribedFunds,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'],
      name: json['name'],
      email: json['email'],
      balance: json['balance'].toDouble(),
      subscribedFunds: List<String>.from(json['subscribedFunds']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'balance': balance,
      'subscribedFunds': subscribedFunds,
    };
  }
}

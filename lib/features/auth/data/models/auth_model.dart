class AuthModel {
  final String token;
  final String userId;
  final String username;

  AuthModel({
    required this.token,
    required this.userId,
    required this.username,
  });

  factory AuthModel.fromJson(Map<String, dynamic> json) {
    return AuthModel(
      token: json['token'] ?? '',
      userId: json['userId'] ?? '',
      username: json['username'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'token': token,
      'userId': userId,
      'username': username,
    };
  }
}

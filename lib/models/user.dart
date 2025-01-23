class User {
  final String username;
  final double walletBalance;
  final String password;
  final String userId;

  User({
    required this.username,
    required this.walletBalance,
    required this.password,
    required this.userId,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      username: json['username'],
      walletBalance: json['wallet_balance']?.toDouble() ?? 0.0,
      password: json['password'],
      userId: json['user_id'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'username': username,
      'wallet_balance': walletBalance,
      'password': password,
      'user_id': userId,
    };
  }
}

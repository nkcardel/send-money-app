import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:send_money_app/models.dart';

class ApiService {
  static const String baseUrl =
      'https://67911595af8442fd7378f856.mockapi.io/api/transactions';
  static const String userBaseUrl =
      'https://67911595af8442fd7378f856.mockapi.io/api/user';

  Future<User> fetchUser(int userId) async {
    final response = await http.get(
      Uri.parse('$userBaseUrl/$userId'),
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> userJson = json.decode(response.body);
      return User.fromJson(userJson);
    } else {
      throw Exception('Failed to load user data');
    }
  }

  Future<double> fetchUserBalance(int userId) async {
    final user = await fetchUser(userId);
    return user.walletBalance;
  }

  Future<bool> sendMoney(int userId, double amount) async {
    try {
      User user = await fetchUser(userId);

      if (user.walletBalance >= amount) {
        double updatedBalance = user.walletBalance - amount;

        final transaction = Transaction(
          userId: userId,
          amount: amount,
          status: true,
          datetime: DateTime.now().toIso8601String(),
          transactionId: '', // MockAPI will generate the transaction ID
        );

        final response = await http.post(
          Uri.parse(baseUrl),
          headers: {'Content-Type': 'application/json'},
          body: json.encode(transaction.toJson()),
        );

        if (response.statusCode == 201) {
          final updateResponse = await http.put(
            Uri.parse('$userBaseUrl/$userId'),
            headers: {'Content-Type': 'application/json'},
            body: json.encode({
              'wallet_balance': updatedBalance,
            }),
          );

          return updateResponse.statusCode == 200;
        } else {
          return false;
        }
      } else {
        return false;
      }
    } catch (e) {
      print('Error: $e');
      return false;
    }
  }

  Future<List<Transaction>> fetchTransactionHistory(int userId) async {
    final response = await http.get(
      Uri.parse('$baseUrl?user_id=$userId'),
    );

    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      return data.map((item) => Transaction.fromJson(item)).toList();
    } else {
      throw Exception('Failed to load transaction history');
    }
  }
}

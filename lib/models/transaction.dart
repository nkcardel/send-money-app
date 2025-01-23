class Transaction {
  final int userId;
  final double amount;
  final bool status;
  final String datetime;
  final String transactionId;

  Transaction({
    required this.userId,
    required this.amount,
    required this.status,
    required this.datetime,
    required this.transactionId,
  });

  factory Transaction.fromJson(Map<String, dynamic> json) {
    return Transaction(
      userId: json['user_id'],
      amount: json['amount']?.toDouble() ?? 0.0,
      status: json['status'],
      datetime: json['datetime'],
      transactionId: json['transaction_id'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'user_id': userId,
      'amount': amount,
      'status': status,
      'datetime': datetime,
      'transaction_id': transactionId,
    };
  }
}

import 'package:flutter/material.dart';
import 'package:send_money_app/models/transaction.dart';
import 'package:send_money_app/services.dart';
import 'package:send_money_app/styles.dart';
import 'package:send_money_app/components.dart';
import 'package:skeletonizer/skeletonizer.dart';

class TransactionsScreen extends StatelessWidget {
  const TransactionsScreen({super.key});

  Future<List<Transaction>> fetchTransactions() async {
    final apiService = ApiService();
    return await apiService.fetchTransactionHistory(1);
  }

  @override
  Widget build(BuildContext context) {
    final authService = AuthService();

    return Scaffold(
      backgroundColor: AppColors.bgColor,
      appBar: AppBar(
        backgroundColor: AppColors.bgColor,
        surfaceTintColor: AppColors.bgColor,
        automaticallyImplyLeading: false,
        centerTitle: false,
        title: Row(
          children: [
            IconButton(
              onPressed: () {
                Navigator.pop(context);
              },
              icon: const Icon(Icons.arrow_back_ios, color: Colors.black),
            ),
            Text(
              'Transactions',
              style: AppTextStyles.titleMedium.copyWith(color: Colors.black),
            ),
          ],
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 10),
            child: IconButton(
              icon: const Icon(
                Icons.logout,
                color: Colors.black,
              ),
              onPressed: () async {
                await authService.logout();

                if (context.mounted) {
                  Navigator.of(context).pushNamedAndRemoveUntil(
                      '/login', (Route<dynamic> route) => false);
                }
              },
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 30),
            FutureBuilder<List<Transaction>>(
              future: fetchTransactions(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Skeletonizer(
                    enabled: true,
                    ignoreContainers: true,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 25),
                      child: Column(
                        children: List.generate(
                            5,
                            (index) => Padding(
                                  padding: const EdgeInsets.only(bottom: 15.0),
                                  child: CustomTransactionsCard(
                                    amount: (index + 1).toString(),
                                    dateTime: DateTime.now().toString(),
                                    status: CustomTransactionsCardStatus.sent,
                                  ),
                                )),
                      ),
                    ),
                  );
                } else if (snapshot.hasError) {
                  return Center(
                    child: Text(
                      'Failed to load transactions',
                      style:
                          AppTextStyles.bodyMedium.copyWith(color: Colors.grey),
                    ),
                  );
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return Center(
                    child: Text(
                      'No transactions found',
                      style:
                          AppTextStyles.bodyMedium.copyWith(color: Colors.grey),
                    ),
                  );
                } else {
                  final transactions = snapshot.data!;
                  transactions.sort((a, b) => b.datetime.compareTo(a.datetime));

                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 25),
                    child: Column(
                      children: transactions.map((transaction) {
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 15),
                          child: CustomTransactionsCard(
                            amount: transaction.amount.toStringAsFixed(2),
                            dateTime: transaction.datetime.toString(),
                            status: transaction.status
                                ? CustomTransactionsCardStatus.sent
                                : CustomTransactionsCardStatus.received,
                          ),
                        );
                      }).toList(),
                    ),
                  );
                }
              },
            ),
            const SizedBox(height: 50),
          ],
        ),
      ),
    );
  }
}

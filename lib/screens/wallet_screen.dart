import 'package:flutter/material.dart';
import 'package:send_money_app/components.dart';
import 'package:send_money_app/models/transaction.dart';
import 'package:send_money_app/screens.dart';
import 'package:send_money_app/services.dart';
import 'package:send_money_app/styles.dart';
import 'package:intl/intl.dart';
import 'package:skeletonizer/skeletonizer.dart';

class WalletScreen extends StatefulWidget {
  final ValueKey? valueKey;
  const WalletScreen({super.key, this.valueKey});

  @override
  State<WalletScreen> createState() => _WalletScreenState();
}

class _WalletScreenState extends State<WalletScreen> {
  final apiService = ApiService();
  final authService = AuthService();

  String formatNumber(String s) {
    return NumberFormat('#,##0.00', 'en_US').format(double.parse(s));
  }

  Future<List<Transaction>> fetchTransactions() async {
    final apiService = ApiService();
    return await apiService.fetchTransactionHistory(1);
  }

  Future<double> fetchWalletBalance() async {
    final apiService = ApiService();
    return await apiService.fetchUserBalance(1);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bgColor,
      appBar: AppBar(
        backgroundColor: AppColors.bgColor,
        surfaceTintColor: AppColors.bgColor,
        automaticallyImplyLeading: false,
        centerTitle: false,
        title: Padding(
          padding: const EdgeInsets.only(left: 10),
          child: Text(
            'Wallet',
            style: AppTextStyles.titleMedium.copyWith(color: Colors.black),
          ),
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
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 25),
          child: Column(
            children: [
              const SizedBox(height: 30),
              FutureBuilder<double>(
                  future: fetchWalletBalance(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Skeletonizer(
                        enabled: true,
                        ignoreContainers: true,
                        child: CustomWalletCard(
                          amount: '',
                        ),
                      );
                    } else if (snapshot.hasError) {
                      return Center(
                        child: Text(
                          'Failed to load transactions',
                          style: AppTextStyles.bodyMedium
                              .copyWith(color: Colors.grey),
                        ),
                      );
                    } else if (!snapshot.hasData || snapshot.data == null) {
                      return Center(
                        child: Text(
                          'No transactions found',
                          style: AppTextStyles.bodyMedium
                              .copyWith(color: Colors.grey),
                        ),
                      );
                    } else {
                      return CustomWalletCard(
                        amount: formatNumber(snapshot.data!.toStringAsFixed(2)),
                        valueKey: widget.valueKey,
                      );
                    }
                  }),
              const SizedBox(height: 40),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Transactions',
                    style:
                        AppTextStyles.titleMedium.copyWith(color: Colors.black),
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const TransactionsScreen()),
                      );
                    },
                    child: Text(
                      'View All',
                      style: AppTextStyles.smallTextMedium
                          .copyWith(color: AppColors.darkPrimaryColor),
                    ),
                  )
                ],
              ),
              const SizedBox(height: 20),
              FutureBuilder<List<Transaction>>(
                  future: fetchTransactions(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Skeletonizer(
                        enabled: true,
                        ignoreContainers: true,
                        child: Column(
                          children: List.generate(
                              3,
                              (index) => Padding(
                                    padding:
                                        const EdgeInsets.only(bottom: 15.0),
                                    child: CustomTransactionsCard(
                                      amount: (index + 1).toString(),
                                      dateTime: DateTime.now().toString(),
                                      status: CustomTransactionsCardStatus.sent,
                                    ),
                                  )),
                        ),
                      );
                    } else if (snapshot.hasError) {
                      return Center(
                        child: Text(
                          'Failed to load transactions',
                          style: AppTextStyles.bodyMedium
                              .copyWith(color: Colors.grey),
                        ),
                      );
                    } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                      return Center(
                        child: Text(
                          'No transactions found',
                          style: AppTextStyles.bodyMedium
                              .copyWith(color: Colors.grey),
                        ),
                      );
                    } else {
                      final transactions = snapshot.data!;
                      transactions
                          .sort((a, b) => b.datetime.compareTo(a.datetime));

                      final latestTransactions = transactions.take(3).toList();

                      return Column(
                        children: latestTransactions.map((transaction) {
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
                      );
                    }
                  }),
              const SizedBox(height: 50),
            ],
          ),
        ),
      ),
    );
  }
}

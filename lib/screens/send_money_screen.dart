import 'package:flutter/material.dart';
import 'package:send_money_app/components.dart';
import 'package:send_money_app/flutter_keys_extension.dart';
import 'package:send_money_app/services.dart';
import 'package:send_money_app/styles.dart';

class SendMoneyScreen extends StatefulWidget {
  final ApiService? apiService;
  final ValueKey? valueKey;
  const SendMoneyScreen({super.key, this.apiService, this.valueKey});

  @override
  State<SendMoneyScreen> createState() => _SendMoneyScreenState();
}

class _SendMoneyScreenState extends State<SendMoneyScreen> {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  TextEditingController amountController = TextEditingController();
  final SnackBarManager snackBarManager = SnackBarManager();
  final apiService = ApiService();
  final authService = AuthService();

  bool isLoading = false;
  double amount = 0;

  Future<void> handleSendMoney() async {
    if (amount > 0) {
      setState(() {
        isLoading = true;
      });

      try {
        final success = await apiService.sendMoney(1, amount);

        if (!mounted) return;

        if (success) {
          snackBarManager.showSnackBar(
            context,
            SuccessSnackBar(
                'You successfully sent ₱${amount.toStringAsFixed(2)}'),
          );
          Navigator.of(context).pushReplacementNamed('/wallet');
        } else {
          snackBarManager.showSnackBar(
            context,
            const FailedSnackBar('Insufficient wallet balance.'),
          );
        }
      } catch (e) {
        snackBarManager.showSnackBar(
          context,
          FailedSnackBar('Error: $e.'),
        );
      } finally {
        setState(() {
          isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bgColor,
      appBar: AppBar(
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
              'Send Money',
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
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 25),
        child: Form(
          key: formKey,
          child: Column(
            children: [
              const SizedBox(height: 30),
              CustomTextField(
                key: widget.valueKey?.nullableKey('send_amount_text_field'),
                controller: amountController,
                labelText: 'Amount',
                keyboardType: TextInputType.number,
                validator: (value) {
                  amount = double.tryParse(value ?? '0') ?? 0;

                  if (amount <= 0) {
                    return 'Enter a valid amount';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 30),
              CustomButton(
                label: 'Submit',
                buttonStyle: CustomButtonStyle.dark,
                onPressed: () {
                  formKey.currentState!.validate();
                  if (amount > 0) {
                    handleSendMoney();
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:send_money_app/screens.dart';
import 'package:send_money_app/styles.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:send_money_app/components.dart';

class CustomWalletCard extends StatefulWidget {
  final String amount;
  final ValueKey? valueKey;

  const CustomWalletCard({super.key, required this.amount, this.valueKey});

  @override
  State<CustomWalletCard> createState() => _CustomCardState();
}

class _CustomCardState extends State<CustomWalletCard> {
  bool showAmount = true;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
          border: Border.all(
            color: AppColors.darkGray,
            width: 0.8,
          ),
          borderRadius: BorderRadius.circular(8)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Your balance',
            style: AppTextStyles.smallText.copyWith(color: AppColors.darkGray),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(
                width: MediaQuery.of(context).size.width / 1.5,
                child: AutoSizeText(
                  showAmount ? '₱${widget.amount}' : '₱*******',
                  style: AppTextStyles.headlineMedium,
                  maxLines: 1,
                ),
              ),
              IconButton(
                icon: Icon(
                  showAmount ? Icons.visibility_off : Icons.visibility,
                  color: AppColors.darkGray,
                ),
                onPressed: () {
                  setState(() {
                    showAmount = !showAmount;
                  });
                },
              )
            ],
          ),
          const SizedBox(height: 15),
          SizedBox(
            width: MediaQuery.of(context).size.width,
            child: CustomButton(
              key: Key('${widget.valueKey?.value}-send_money_button'),
              label: 'Send Money',
              buttonStyle: CustomButtonStyle.light,
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const SendMoneyScreen()),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:send_money_app/styles.dart';
import 'dart:math';

enum CustomTransactionsCardStatus {
  sent,
  received,
}

class CustomTransactionsCard extends StatelessWidget {
  final String amount;
  final String dateTime;
  final CustomTransactionsCardStatus status;

  const CustomTransactionsCard({
    super.key,
    required this.amount,
    required this.dateTime,
    this.status = CustomTransactionsCardStatus.sent,
  });

  @override
  Widget build(BuildContext context) {
    String displayAmount = '- ₱$amount';
    String label = 'Sent';
    Color color = Colors.black;
    double angle = 0;

    DateTime now = DateTime.parse(dateTime);
    String formattedDate = DateFormat('MMMM d y').format(now);
    String formattedTime = DateFormat('h:mm a').format(now);

    String formatNumber(String s) {
      return NumberFormat('#,##0.00', 'en_US').format(double.parse(s));
    }

    switch (status) {
      case CustomTransactionsCardStatus.sent:
        label = 'Sent';
        displayAmount = '- ₱${formatNumber(amount)}';
        color = Colors.black;
        angle = 0;
        break;
      case CustomTransactionsCardStatus.received:
        label = 'Failed to send';
        color = AppColors.darkPrimaryColor;
        displayAmount = '₱${formatNumber(amount)}';
        angle = 180 * pi / 180;
        break;
    }

    return Container(
      width: MediaQuery.of(context).size.width,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        border: Border.all(
          color: AppColors.darkGray,
          width: 0.8,
        ),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Transform.rotate(
                angle: angle,
                child: Icon(
                  Icons.arrow_outward_rounded,
                  color: color,
                  size: 30,
                ),
              ),
              const SizedBox(width: 15),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    label,
                    style: AppTextStyles.smallTextMedium
                        .copyWith(color: AppColors.darkGray),
                  ),
                  Text(
                    displayAmount,
                    style: AppTextStyles.buttonMedium.copyWith(color: color),
                  ),
                ],
              ),
            ],
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                formattedDate,
                style: AppTextStyles.smallTextMedium
                    .copyWith(color: AppColors.darkGray),
              ),
              Text(
                formattedTime,
                style: AppTextStyles.smallTextMedium
                    .copyWith(color: AppColors.darkGray),
              ),
            ],
          )
        ],
      ),
    );
  }
}

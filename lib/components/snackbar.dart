import 'package:flutter/material.dart';
import 'package:send_money_app/styles.dart';

abstract class SnackBarMessage {
  final String message;
  const SnackBarMessage(this.message);

  SnackBar createSnackBar();
}

class SuccessSnackBar extends SnackBarMessage {
  const SuccessSnackBar(super.message);

  @override
  SnackBar createSnackBar() {
    return SnackBar(
      content: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const Icon(
            Icons.check_rounded,
            color: Colors.white,
            size: 28,
          ),
          const SizedBox(width: 10),
          Text(
            message,
            style: AppTextStyles.body.copyWith(color: Colors.white),
          ),
        ],
      ),
      padding: const EdgeInsets.all(20),
      backgroundColor: AppColors.darkPrimaryColor,
      behavior: SnackBarBehavior.floating,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
    );
  }
}

class FailedSnackBar extends SnackBarMessage {
  const FailedSnackBar(super.message);

  @override
  SnackBar createSnackBar() {
    return SnackBar(
      content: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const Icon(
            Icons.close_rounded,
            color: Colors.white,
            size: 28,
          ),
          const SizedBox(width: 10),
          Flexible(
            child: Text(
              message,
              style: AppTextStyles.body.copyWith(color: Colors.white),
            ),
          ),
        ],
      ),
      padding: const EdgeInsets.all(20),
      backgroundColor: Colors.red,
      behavior: SnackBarBehavior.floating,
      elevation: 1,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
    );
  }
}

class SnackBarManager {
  void showSnackBar(BuildContext context, SnackBarMessage snackBarMessage) {
    ScaffoldMessenger.of(context)
        .showSnackBar(snackBarMessage.createSnackBar());
  }
}

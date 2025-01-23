import 'package:flutter/material.dart';
import 'package:send_money_app/styles.dart';

enum CustomButtonStyle {
  light,
  dark,
}

enum CustomButtonSize {
  small,
  large,
}

class CustomButton extends StatelessWidget {
  final CustomButtonStyle buttonStyle;
  final String label;
  final IconData? leadingIcon;
  final void Function()? onPressed;
  final bool showLeadingIcon;

  const CustomButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.buttonStyle = CustomButtonStyle.dark,
    this.leadingIcon,
    this.showLeadingIcon = false,
  });

  @override
  Widget build(BuildContext context) {
    Color buttonBgColor = AppColors.darkPrimaryColor;
    Color textBtnColor = Colors.white;

    switch (buttonStyle) {
      case CustomButtonStyle.light:
        buttonBgColor = AppColors.lightPrimaryColor;
        textBtnColor = AppColors.darkPrimaryColor;
        break;
      case CustomButtonStyle.dark:
        buttonBgColor = AppColors.darkPrimaryColor;
        textBtnColor = Colors.white;
        break;
    }
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        splashFactory: NoSplash.splashFactory,
        elevation: 0,
        backgroundColor: buttonBgColor,
        padding: const EdgeInsets.symmetric(
          vertical: 10,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            label,
            style: AppTextStyles.buttonMedium.copyWith(
              color: textBtnColor,
            ),
          ),
        ],
      ),
    );
  }
}

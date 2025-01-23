import 'package:flutter/material.dart';
import 'package:send_money_app/styles.dart';

class CustomTextField extends StatefulWidget {
  final TextEditingController controller;
  final String? errorText;
  final TextInputType keyboardType;
  final String labelText;
  final Function(String)? onFieldSubmitted;
  final bool showSuffixIcon;
  final String? Function(String?)? validator;

  const CustomTextField({
    super.key,
    required this.controller,
    required this.labelText,
    this.errorText,
    this.onFieldSubmitted,
    this.keyboardType = TextInputType.text,
    this.showSuffixIcon = false,
    this.validator,
  });

  @override
  State<CustomTextField> createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<CustomTextField> {
  bool showPassword = false;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: widget.controller,
      cursorColor: Colors.black,
      style: AppTextStyles.bodyMedium.copyWith(color: Colors.black),
      obscureText: showPassword,
      keyboardType: widget.keyboardType,
      decoration: InputDecoration(
        labelText: widget.labelText,
        labelStyle:
            AppTextStyles.bodyMedium.copyWith(color: AppColors.darkGray),
        errorText: widget.errorText,
        errorStyle: AppTextStyles.smallText.copyWith(color: Colors.red),
        floatingLabelBehavior: FloatingLabelBehavior.auto,
        floatingLabelStyle:
            AppTextStyles.bodyMedium.copyWith(color: AppColors.darkGray),
        alignLabelWithHint: true,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8.0),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8.0),
          borderSide: const BorderSide(color: AppColors.borderColor),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8.0),
          borderSide: const BorderSide(color: AppColors.darkGray),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8.0),
          borderSide: const BorderSide(color: Colors.red),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8.0),
          borderSide: const BorderSide(color: Colors.red),
        ),
        suffixIcon: widget.showSuffixIcon
            ? IconButton(
                icon: Icon(
                  showPassword ? Icons.visibility : Icons.visibility_off,
                  color: AppColors.darkGray,
                ),
                onPressed: () {
                  setState(() {
                    showPassword = !showPassword;
                  });
                },
              )
            : null,
      ),
      onFieldSubmitted: widget.onFieldSubmitted,
      validator: widget.validator,
      autovalidateMode: AutovalidateMode.onUserInteraction,
    );
  }
}

import 'package:flutter/material.dart';
import 'package:send_money_app/components.dart';
import 'package:send_money_app/services.dart';
import 'package:send_money_app/styles.dart';
import 'package:send_money_app/screens.dart';
import 'package:send_money_app/flutter_keys_extension.dart';

class LoginScreen extends StatefulWidget {
  final ValueKey? valueKey;
  final AuthService? authService;
  const LoginScreen({super.key, this.valueKey, this.authService});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  TextEditingController usernameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  late final AuthService authService;
  final SnackBarManager snackBarManager = SnackBarManager();

  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    authService = widget.authService ?? AuthService();
  }

  void onLogin(String username, String password) async {
    setState(() {
      isLoading = true;
    });

    final success = await authService.login(username, password);

    if (!mounted) return;

    setState(() {
      isLoading = false;
    });

    if (success) {
      ScaffoldMessenger.of(context).hideCurrentSnackBar();
      if (!mounted) return;
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => const WalletScreen(),
        ),
      );
    } else {
      if (username.isEmpty || password.isEmpty) {
        ScaffoldMessenger.of(context).hideCurrentSnackBar();
      } else {
        snackBarManager.showSnackBar(
          context,
          const FailedSnackBar(
              'The username or password you entered is incorrect.'),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bgColor,
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 25),
        child: Form(
          key: formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              CustomTextField(
                key: widget.valueKey?.nullableKey('login_username_text_field'),
                controller: usernameController,
                labelText: 'Username',
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Please enter your username';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),
              CustomTextField(
                key: widget.valueKey?.nullableKey('login_password_text_field'),
                controller: passwordController,
                labelText: 'Password',
                showSuffixIcon: true,
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Please enter your password';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 35),
              Row(
                children: [
                  Expanded(
                    child: CustomButton(
                      onPressed: () {
                        formKey.currentState!.validate();
                        onLogin(
                          usernameController.text.trim(),
                          passwordController.text.trim(),
                        );
                      },
                      label: 'Login',
                      buttonStyle: CustomButtonStyle.dark,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

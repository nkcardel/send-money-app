import 'package:flutter/material.dart';
import 'package:send_money_app/services.dart';
import 'package:send_money_app/styles.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'screens.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Send Money App',
      routes: {
        '/login': (context) => const LoginScreen(),
        '/wallet': (context) => const WalletScreen(),
      },
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.transparent),
        useMaterial3: true,
      ),
      home: const Home(),
    );
  }
}

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  late final AuthService authService;

  @override
  void initState() {
    super.initState();
    authService = AuthService();
    authService.initialize();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: authService.initialize(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Skeletonizer(
            enabled: true,
            ignoreContainers: true,
            child: Center(
              child: CircularProgressIndicator(
                color: AppColors.darkPrimaryColor,
              ),
            ),
          );
        } else if (snapshot.hasError) {
          return const Center(child: Text('Error initializing'));
        } else {
          return authService.isLoggedIn
              ? const WalletScreen()
              : const LoginScreen();
        }
      },
    );
  }
}

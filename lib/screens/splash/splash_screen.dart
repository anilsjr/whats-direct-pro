import 'package:flutter/material.dart';
import '../home/home_screen.dart';
import 'package:provider/provider.dart';
import '../../provider/term_conditions_provider.dart';
import '../../widgets/term_and_conditions.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    // Call async method without await
    _initializeApp();
  }

  Future<void> _initializeApp() async {
    // Wait for splash duration
    await Future.delayed(const Duration(milliseconds: 1000));

    // Load preferences first
    final termsProvider = Provider.of<TermsConditionsProvider>(
      context,
      listen: false,
    );
    await termsProvider.loadFirstVisitFromPrefs();

    if (!mounted) return;

    if (termsProvider.isFirstVisit) {
      // Navigate to terms screen
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const TermsAndConditionsWidget()),
      );
    } else {
      // Navigate directly to home screen
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const HomeScreen()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    // final themeProvider = Provider.of<ThemeProvider>(context);

    return Scaffold(
      appBar: null, // No app bar
      body: Container(
        width: double.infinity,
        height: double.infinity,
        color: Theme.of(context).scaffoldBackgroundColor,
        child: const Center(
          child: Image(
            image: AssetImage('assets/icons/logo.png'),
            fit: BoxFit.contain,
          ),
        ),
      ),
    );
  }
}

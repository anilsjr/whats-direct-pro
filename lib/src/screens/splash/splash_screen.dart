import 'package:flutter/material.dart';
import '../home/home_screen.dart';
import '../../../core/ads_units/app_open_ad.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    // Call async method without await
    _initializeApp();
  }

  Future<void> _initializeApp() async {
    // Load and show app open ad
    final appOpenAdManager = AppOpenAdManager();
    await appOpenAdManager.loadAd();
    await appOpenAdManager.showAdIfAvailable();

    // Wait for splash duration
    await Future.delayed(const Duration(milliseconds: 1000));

    if (!mounted) return;

    // Navigate directly to home screen
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => const HomeScreen()),
    );
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

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_overlay_window/flutter_overlay_window.dart';
import 'package:provider/provider.dart';
import 'provider/theme_provider.dart';
import 'services/overlay_service.dart';
import 'theme/custom_theme.dart';
import 'screens/splash/splash_screen.dart';
import 'overlay/true_caller_overlay.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Set portrait orientation only
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  // Initialize shared preferences
  final themeProvider = ThemeProvider();
  await themeProvider.loadThemeFromPrefs();

  // Request overlay permission
  await OverlayService.requestPermission();

  runApp(
    ChangeNotifierProvider<ThemeProvider>(
      create: (_) => themeProvider,
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    return MaterialApp(
      // title: 'WhatsApp Direct Pro',
      theme: themeProvider.isDarkMode
          ? AppThemes.darkTheme
          : AppThemes.lightTheme,
      home: const SplashScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'provider/theme_provider.dart';
// import 'provider/save_number_provider.dart';
import 'theme/custom_theme.dart';
import 'screens/splash/splash_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // Initialize shared preferences
  final themeProvider = ThemeProvider();
  await themeProvider.loadThemeFromPrefs();
  // final saveNumberProvider = SaveNumberProvider();
  // await saveNumberProvider.loadSavedNumberFromPrefs();

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

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:provider/provider.dart';

import 'models/pdf_open_request.dart';
import 'provider/theme_provider.dart';
import 'provider/term_conditions_provider.dart';
import 'screens/pdf/pdf_viewer_screen.dart';
import 'screens/splash/splash_screen.dart';
import 'services/pdf_intent_service.dart';
import 'theme/custom_theme.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await MobileAds.instance.initialize();

  // Set portrait orientation only
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  // Initialize shared preferences
  final themeProvider = ThemeProvider();
  await themeProvider.loadThemeFromPrefs();

  final termsProvider = TermsConditionsProvider();
  await termsProvider.loadFirstVisitFromPrefs();

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider<ThemeProvider>(create: (_) => themeProvider),
        ChangeNotifierProvider<TermsConditionsProvider>(
          create: (_) => termsProvider,
        ),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final GlobalKey<NavigatorState> _navigatorKey = GlobalKey<NavigatorState>();
  final GlobalKey<ScaffoldMessengerState> _messengerKey =
      GlobalKey<ScaffoldMessengerState>();
  StreamSubscription<PdfOpenRequest>? _intentSubscription;

  @override
  void initState() {
    super.initState();
    _initPdfIntentHandling();
  }

  @override
  void dispose() {
    _intentSubscription?.cancel();
    super.dispose();
  }

  Future<void> _initPdfIntentHandling() async {
    final initialIntent =
        await PdfIntentService.instance.getInitialPdfIntent();
    if (!mounted) {
      return;
    }
    if (initialIntent != null) {
      _openPdfIntent(initialIntent, replace: true);
    }

    _intentSubscription = PdfIntentService.instance.intentStream.listen(
      (request) {
        _openPdfIntent(request, replace: false);
      },
    );
  }

  void _openPdfIntent(PdfOpenRequest request, {required bool replace}) {
    if (request.hasError) {
      _showError(request.error ?? 'Unable to open PDF.');
      return;
    }
    if (!request.hasPath) {
      _showError('Unable to open PDF.');
      return;
    }
    final route = MaterialPageRoute(
      builder: (_) => PdfViewerScreen(
        filePath: request.path!,
        displayName: request.displayName,
      ),
    );
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (replace) {
        _navigatorKey.currentState?.pushAndRemoveUntil(
          route,
          (route) => false,
        );
      } else {
        _navigatorKey.currentState?.push(route);
      }
    });
  }

  void _showError(String message) {
    _messengerKey.currentState?.showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);

    return MaterialApp(
      // title: 'WhatsApp Direct Pro',
      theme: themeProvider.isDarkMode
          ? AppThemes.darkTheme
          : AppThemes.lightTheme,
      navigatorKey: _navigatorKey,
      scaffoldMessengerKey: _messengerKey,
      home: const SplashScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}

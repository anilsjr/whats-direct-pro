import 'dart:async';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'app.dart';
import 'config/ads.dart';
import 'config/lang.dart';

// Keep shared app helpers available to screens that import this entry point.
export 'app.dart';

/// Restores saved settings and launches the app.
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  prefs = await SharedPreferences.getInstance();
  // Apply saved preferences before rendering the first frame.
  theme.value = prefs.getBool('dark') == true
      ? ThemeMode.dark
      : ThemeMode.light;
  noAds.value = prefs.getBool('noAds') ?? false;
  reminders.value = prefs.getBool('reminders') ?? false;
  final code = prefs.getString('lang');
  lang.value = code != null && names.containsKey(code)
      ? Locale(code)
      : const Locale('en');
  runApp(const MyApp());
  // Start optional services after launching the UI.
  if (prefs.getBool('reminders') == true) {
    unawaited(updateReminders(true));
  }
  if (prefs.getBool('onboarded') == true) await initAds();
}

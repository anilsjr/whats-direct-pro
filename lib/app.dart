import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:country_picker/country_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'screens/home.dart';
import 'screens/settings.dart';
import 'screens/widgets/splash.dart';
import 'config/lang.dart';
import 'config/local_notification.dart';

// Shared preferences and reactive state used across screens.
late SharedPreferences prefs;
final theme = ValueNotifier(ThemeMode.light);
final recentTick = ValueNotifier(0);
final reminders = ValueNotifier(false);

/// Resolves the device language with English as the fallback.
Locale deviceLocale() {
  final code = WidgetsBinding.instance.platformDispatcher.locale.languageCode;
  return Locale(names.containsKey(code) ? code : 'en');
}

/// Returns false when a preference write fails.
Future<bool> persist(Future<bool> operation) async {
  try {
    return await operation;
  } catch (_) {
    return false;
  }
}

void notice(BuildContext context, String key) {
  if (context.mounted) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(t(key))));
  }
}

/// Configures themes, localization, onboarding, and navigation.
class MyApp extends StatefulWidget {
  const MyApp({super.key});
  @override
  State<MyApp> createState() => _AppState();
}

class _AppState extends State<MyApp> {
  late bool onboarded = prefs.getBool('onboarded') ?? false;
  bool background = false;
  // Refresh language and enabled services when the app resumes.
  late final AppLifecycleListener lifecycle = AppLifecycleListener(
    onPause: () => background = true,
    onResume: () {
      if (prefs.getBool('systemLanguage') == true) lang.value = deviceLocale();
      if (background) {
        background = false;
        if (onboarded) {
          if (prefs.getBool('reminders') == true) {
            unawaited(updateReminders(true));
          }
        }
      }
    },
  );
  @override
  void initState() {
    super.initState();
    // Initialize the lazy listener to register lifecycle callbacks.
    lifecycle;
  }

  @override
  void dispose() {
    lifecycle.dispose();
    super.dispose();
  }

  ThemeData appearance(Brightness brightness) {
    final colors = ColorScheme.fromSeed(
      seedColor: const Color(0xFF25D366),
      brightness: brightness,
    );
    return ThemeData(
      useMaterial3: true,
      colorScheme: colors,
      scaffoldBackgroundColor: brightness == Brightness.light
          ? const Color(0xFFF5F8F6)
          : const Color(0xFF101A15),
      appBarTheme: const AppBarTheme(
        centerTitle: false,
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: colors.surface,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(18),
          borderSide: BorderSide(color: colors.outlineVariant),
        ),
        contentPadding: const EdgeInsets.all(18),
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          minimumSize: const Size.fromHeight(56),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(18),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) => ValueListenableBuilder(
    valueListenable: lang,
    builder: (_, locale, child) => ValueListenableBuilder(
      valueListenable: theme,
      builder: (_, mode, child) => MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'WhatsApp Direct Pro',
        locale: locale,
        theme: appearance(Brightness.light),
        darkTheme: appearance(Brightness.dark),
        themeMode: mode,
        supportedLocales: names.keys.map(Locale.new),
        localizationsDelegates: [
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
          // Missing picker translations fall back to the country names.
          if (CountryLocalizations.delegate.isSupported(locale))
            CountryLocalizations.delegate,
        ],
        home: SplashScreen(
          child: onboarded
              ? const HomePage()
              : OnboardingPage(onDone: () => setState(() => onboarded = true)),
        ),
      ),
    ),
  );
}

/// Saves the selected language and refreshes localized reminders.
Future<void> chooseLanguage(BuildContext context) async {
  final code = await showModalBottomSheet<String>(
    context: context,
    isScrollControlled: true,
    useSafeArea: true,
    builder: (context) => SizedBox(
      height: MediaQuery.sizeOf(context).height,
      child: Material(
        borderRadius: const BorderRadius.vertical(top: Radius.circular(28)),
        clipBehavior: Clip.antiAlias,
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 20, 24, 8),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      t('language'),
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                  ),
                  IconButton(
                    tooltip: t('cancel'),
                    onPressed: () => Navigator.pop(context),
                    icon: const Icon(Icons.close),
                  ),
                ],
              ),
            ),
            const Divider(height: 1),
            Expanded(
              child: ListView(
                padding: const EdgeInsets.symmetric(vertical: 8),
                children: [
                  RadioGroup<String>(
                    groupValue: prefs.getBool('systemLanguage') == true
                        ? ''
                        : lang.value.languageCode,
                    onChanged: (v) => Navigator.pop(context, v),
                    child: Column(
                      children: [
                        for (final code in ['', ...names.keys])
                          RadioListTile<String>(
                            title: Text(
                              code.isEmpty ? t('systemDefault') : names[code]!,
                            ),
                            value: code,
                          ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    ),
  );
  if (code == null) return;
  final locale = code.isEmpty ? deviceLocale() : Locale(code);
  if (!await persist(prefs.setString('lang', locale.languageCode)) ||
      !await persist(prefs.setBool('systemLanguage', code.isEmpty))) {
    if (context.mounted) notice(context, 'errSave');
    return;
  }
  lang.value = locale;
  if (prefs.getBool('reminders') == true &&
      !await updateReminders(true) &&
      context.mounted) {
    notice(context, 'errNotify');
  }
}

/// Applies the theme after the preference is saved successfully.
Future<void> chooseTheme(BuildContext context, bool dark) async {
  if (await persist(prefs.setBool('dark', dark))) {
    theme.value = dark ? ThemeMode.dark : ThemeMode.light;
  } else if (context.mounted) {
    notice(context, 'errSave');
  }
}


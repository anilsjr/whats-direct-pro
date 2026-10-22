import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_timezone/flutter_timezone.dart';
import 'package:timezone/data/latest.dart' as tzdata;
import 'package:timezone/timezone.dart' as tz;
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:country_picker/country_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'config/ads.dart';
import 'screens/home.dart';
import 'screens/recent.dart';
import 'screens/settings.dart';
import 'config/lang.dart';

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
  int index = 0;
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
          showAppOpen();
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
    disposeAds();
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
        localizationsDelegates: const [
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
          CountryLocalizations.delegate,
        ],
        home: !onboarded
            ? OnboardingPage(
                onDone: () {
                  setState(() => onboarded = true);
                  unawaited(initAds());
                },
              )
            : Scaffold(
                // Preserve each tab's state while switching destinations.
                body: IndexedStack(
                  index: index,
                  children: const [HomePage(), RecentPage(), SettingsPage()],
                ),
                bottomNavigationBar: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    ValueListenableBuilder(
                      valueListenable: noAds,
                      builder: (_, off, child) =>
                          off ? const SizedBox.shrink() : const BannerBox(),
                    ),
                    NavigationBar(
                      selectedIndex: index,
                      onDestinationSelected: (next) {
                        if (next == index) return;
                        setState(() => index = next);
                        if (next == 1) recentTick.value++;
                        showTabAd();
                      },
                      destinations: [
                        NavigationDestination(
                          icon: const Icon(Icons.chat_outlined),
                          selectedIcon: const Icon(Icons.chat),
                          label: t('home'),
                        ),
                        NavigationDestination(
                          icon: const Icon(Icons.history),
                          label: t('recent'),
                        ),
                        NavigationDestination(
                          icon: const Icon(Icons.settings_outlined),
                          selectedIcon: const Icon(Icons.settings),
                          label: t('settings'),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
      ),
    ),
  );
}

/// Saves the selected language and refreshes localized reminders.
Future<void> chooseLanguage(BuildContext context) async {
  final code = await showDialog<String>(
    context: context,
    builder: (context) => SimpleDialog(
      title: Text(t('language')),
      children: [
        RadioGroup<String>(
          groupValue: prefs.getBool('systemLanguage') == true
              ? ''
              : lang.value.languageCode,
          onChanged: (v) => Navigator.pop(context, v),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              for (final code in ['', ...names.keys])
                RadioListTile<String>(
                  title: Text(code.isEmpty ? t('systemDefault') : names[code]!),
                  value: code,
                ),
            ],
          ),
        ),
      ],
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

final notifications = FlutterLocalNotificationsPlugin();
Future<void>? _notificationsReady;

/// Caches notification setup and allows retries after initialization failures.
Future<void> prepareNotifications() => _notificationsReady ??=
    (() async {
      tzdata.initializeTimeZones();
      await notifications.initialize(
        const InitializationSettings(
          android: AndroidInitializationSettings('ic_notification'),
          iOS: DarwinInitializationSettings(
            requestAlertPermission: false,
            requestBadgePermission: false,
            requestSoundPermission: false,
          ),
        ),
      );
    })().catchError((Object error) {
      _notificationsReady = null;
      throw error;
    });
bool get mobileNotifications =>
    !kIsWeb &&
    (defaultTargetPlatform == TargetPlatform.android ||
        defaultTargetPlatform == TargetPlatform.iOS);
Future<bool>? _reminderWork;

/// Serializes reminder changes to avoid overlapping scheduling operations.
Future<bool> updateReminders(bool enabled, {bool request = false}) async {
  if (!mobileNotifications) return !enabled;
  final work = (_reminderWork ?? Future.value(true)).then(
    (_) => _setReminders(enabled, request: request),
  );
  _reminderWork = work;
  try {
    final result = await work;
    reminders.value = prefs.getBool('reminders') ?? false;
    return result;
  } finally {
    if (identical(_reminderWork, work)) _reminderWork = null;
  }
}

Future<bool> _setReminders(bool enabled, {required bool request}) async {
  try {
    await prepareNotifications();
    if (!enabled) {
      await notifications.cancel(1001);
      await notifications.cancel(1002);
      return await persist(prefs.setBool('reminders', false));
    }
    final android = notifications
        .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin
        >();
    final ios = notifications
        .resolvePlatformSpecificImplementation<
          IOSFlutterLocalNotificationsPlugin
        >();
    final allowed = android != null
        ? (request
              ? await android.requestNotificationsPermission()
              : await android.areNotificationsEnabled())
        : (request
              ? await ios?.requestPermissions(
                  alert: true,
                  badge: false,
                  sound: false,
                )
              : (await ios?.checkPermissions())?.isEnabled);
    if (allowed != true) {
      await notifications.cancel(1001);
      await notifications.cancel(1002);
      await persist(prefs.setBool('reminders', false));
      return false;
    }
    tz.setLocalLocation(
      tz.getLocation((await FlutterTimezone.getLocalTimezone()).identifier),
    );
    final now = tz.TZDateTime.now(tz.local);
    for (final hour in [10, 18]) {
      var date = tz.TZDateTime(tz.local, now.year, now.month, now.day, hour);
      if (!date.isAfter(now)) {
        date = tz.TZDateTime(tz.local, now.year, now.month, now.day + 1, hour);
      }
      // Repeat each reminder daily at the selected local time.
      await notifications.zonedSchedule(
        hour == 10 ? 1001 : 1002,
        'WhatsApp Direct Pro',
        t(hour == 10 ? 'reminderMorning' : 'reminderEvening'),
        date,
        NotificationDetails(
          android: AndroidNotificationDetails(
            'daily_reminders_low',
            t('reminders'),
            channelDescription: t('reminderTimes'),
            importance: Importance.low,
            priority: Priority.low,
            playSound: false,
            enableVibration: false,
            channelShowBadge: false,
          ),
          iOS: const DarwinNotificationDetails(
            presentSound: false,
            presentBadge: false,
            interruptionLevel: InterruptionLevel.passive,
          ),
        ),
        androidScheduleMode: AndroidScheduleMode.inexactAllowWhileIdle,
        matchDateTimeComponents: DateTimeComponents.time,
      );
    }
    if (!await persist(prefs.setBool('reminders', true))) {
      throw StateError('save');
    }
    return true;
  } catch (_) {
    try {
      await notifications.cancel(1001);
      await notifications.cancel(1002);
    } catch (_) {
      // Keep the app usable if notification cleanup fails.
    }
    await persist(prefs.setBool('reminders', false));
    return false;
  }
}

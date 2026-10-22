import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_timezone/flutter_timezone.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:timezone/data/latest.dart' as tzdata;
import 'package:timezone/timezone.dart' as tz;
import 'lang.dart';

class LocalNotificationService {
  LocalNotificationService({
    required SharedPreferences preferences,
    required ValueNotifier<bool> reminderState,
  }) : _prefs = preferences,
       _reminders = reminderState;

  final SharedPreferences _prefs;
  final ValueNotifier<bool> _reminders;
  final notifications = FlutterLocalNotificationsPlugin();
  Future<void>? _ready;
  Future<bool>? _work;

  bool get isSupported =>
      !kIsWeb &&
      (defaultTargetPlatform == TargetPlatform.android ||
          defaultTargetPlatform == TargetPlatform.iOS);

  Future<void> prepare() => _ready ??=
      (() async {
        tzdata.initializeTimeZones();
        await notifications.initialize(
          settings: const InitializationSettings(
            android: AndroidInitializationSettings('ic_notification'),
            iOS: DarwinInitializationSettings(
              requestAlertPermission: false,
              requestBadgePermission: false,
              requestSoundPermission: false,
            ),
          ),
        );
      })().catchError((Object error) {
        _ready = null;
        throw error;
      });

  Future<bool> update({bool enabled = true, bool request = false}) async {
    if (!isSupported) return !enabled;
    final work = (_work ?? Future.value(true)).then(
      (_) => _setReminders(enabled, request: request),
    );
    _work = work;
    try {
      final result = await work;
      _reminders.value = _prefs.getBool('reminders') ?? false;
      return result;
    } finally {
      if (identical(_work, work)) _work = null;
    }
  }

  Future<bool> _setReminders(bool enabled, {required bool request}) async {
    try {
      await prepare();
      if (!enabled) {
        await notifications.cancel(id: 1001);
        await notifications.cancel(id: 1002);
        return _save(_prefs.setBool('reminders', false));
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
        await notifications.cancel(id: 1001);
        await notifications.cancel(id: 1002);
        await _save(_prefs.setBool('reminders', false));
        return false;
      }
      tz.setLocalLocation(
        tz.getLocation((await FlutterTimezone.getLocalTimezone()).identifier),
      );
      final now = tz.TZDateTime.now(tz.local);
      for (final hour in [10, 18]) {
        var date = tz.TZDateTime(tz.local, now.year, now.month, now.day, hour);
        if (!date.isAfter(now)) {
          date = tz.TZDateTime(
            tz.local,
            now.year,
            now.month,
            now.day + 1,
            hour,
          );
        }
        await notifications.zonedSchedule(
          id: hour == 10 ? 1001 : 1002,
          title: 'WhatsApp Direct Pro',
          body: t(hour == 10 ? 'reminderMorning' : 'reminderEvening'),
          scheduledDate: date,
          notificationDetails: NotificationDetails(
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
      if (!await _save(_prefs.setBool('reminders', true))) {
        throw StateError('save');
      }
      return true;
    } catch (_) {
      try {
        await notifications.cancel(id: 1001);
        await notifications.cancel(id: 1002);
      } catch (_) {}
      await _save(_prefs.setBool('reminders', false));
      return false;
    }
  }

  Future<bool> _save(Future<bool> operation) async {
    try {
      return await operation;
    } catch (_) {
      return false;
    }
  }
}

late LocalNotificationService localNotification;

Future<void> prepareNotifications() => localNotification.prepare();

bool get mobileNotifications => localNotification.isSupported;

Future<bool> updateReminders(bool enabled, {bool request = false}) =>
    localNotification.update(enabled: enabled, request: request);
